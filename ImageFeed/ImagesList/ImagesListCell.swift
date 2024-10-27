import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageCell: UIImageView!
    
    weak var delegate: ImagesListCellDelegate?
    
    private let imageListService: ImageListService = .shared
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
        imageCell.image = nil
    }

    @IBAction func didTabLikeButton(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
    
    func setIsLiked(isLike: Bool, cell: ImagesListCell) {
        if isLike {
            cell.likeButton.setImage(UIImage(named: "active_like"), for: .normal)
            cell.likeButton.accessibilityIdentifier = "like button on"
        } else {
            cell.likeButton.setImage(UIImage(named: "no_active_like"), for: .normal)
            cell.likeButton.accessibilityIdentifier = "like button off"
        }
    }
}
