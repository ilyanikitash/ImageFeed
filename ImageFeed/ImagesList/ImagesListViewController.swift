import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let imageListService = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    var photos: [Photo] = []
    private var alertPresenter: AlertPresenter?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupObserver()
        imageListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let image = photos[indexPath.row]
            viewController.imageURL = URL(string: image.largeImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func setupObserver() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(forName: ImageListService.didChageNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { 
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let image = photos[indexPath.row]
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(with: URL(string: image.largeImageURL), placeholder: UIImage(named: "stub"))
        let isLiked = image.isLiked
        let likeImage = isLiked ? UIImage(named: "active_like") : UIImage(named: "no_active_like")
        cell.likeButton.setImage(likeImage, for: .normal)
        guard let createdAt = image.createdAt else {
            cell.dateLabel.text = ""
            return
        }
        
        let dateF = ISO8601DateFormatter()
        let date = dateF.date(from: createdAt)
        
        guard let date else {
            cell.dateLabel.text = ""
            return
        }
        
        cell.dateLabel.text = dateFormatter.string(from: date)
        cell.dateLabel.textColor = .white
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = imageListService.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        let isLike = !photo.isLiked
        imageListService.changeLike(photoId: photo.id, isLike: isLike) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                ImagesListCell().setIsLiked(isLike: isLike, cell: cell)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("\(error.localizedDescription) - error change like")
                let alertModel = AlertModel(title: "Что-то пошло не так(",
                                            message: "Не удалось поставить лайк",
                                            buttonText: "Ок",
                                            completion: nil)
                
                self.alertPresenter?.showAlert(vc: self, model: alertModel)
            }
        }
    }
}


