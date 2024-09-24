import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let storage = OAuthTokenStorage()
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var nameLabel = createLabel(
        text: "Екатерина Новикова",
        color: .white,
        font: .boldSystemFont(ofSize: 23.0)
    )
    
    private lazy var loginLabel = createLabel(
        text: "@ekaterina_nov",
        color: .ypGray,
        font: .systemFont(ofSize: 13.0)
    )
    
    private lazy var descriptionLabel = createLabel(
        text: "Hello World!",
        color: .white,
        font: .systemFont(ofSize: 13.0)
    )
    
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Userpick")
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var escapeButton = {
        let button = UIButton.systemButton(with: UIImage(
            systemName: "ipad.and.arrow.forward") ?? UIImage(),
                                           target: nil,
                                           action: nil)
        button.tintColor = .ypRed
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        view.backgroundColor = .ypBlack
        updateAvatar()
        setupConstraints()
        updateProfileDetails(profile: profileService.profile)
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "profile_placeholder")) { result in
            switch result {
            case .success(let value):
                print(value.image)
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {
            return
        }
        self.nameLabel.text = profile.name
        self.loginLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
    
    private func createLabel(text: String,
                             color: UIColor,
                             font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        
        return label
    }
    
    private func setupConstraints() {
//      Profile Image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 32)
        ])
//      Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ])
//      Login Label
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
//      Description Label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor)
        ])
//      Escape Button
        escapeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(escapeButton)
        
        NSLayoutConstraint.activate([
            escapeButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            escapeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -24),
            escapeButton.heightAnchor.constraint(equalToConstant: 24),
            escapeButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
