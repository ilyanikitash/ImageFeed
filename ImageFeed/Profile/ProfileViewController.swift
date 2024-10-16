import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileLogoutService = ProfileLogoutService.shared
    private let profileService = ProfileService.shared
    private let storage = OAuthTokenStorage()
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var animationLayers: [CALayer] = []
    private let gradient = CAGradientLayer()
    
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
        animateProfileImage()
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
        escapeButton.addTarget(self, action: #selector(didTapEscapeButton), for: .touchUpInside)
    }
    
    private func animateProfileImage() {
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 35
        gradient.masksToBounds = true
        animationLayers.append(gradient)
        imageView.layer.addSublayer(gradient)
        
        gradientAnimation()
    }
    
    private func gradientAnimation() {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locations")
    }
    
    @objc private func didTapEscapeButton() {
        profileLogoutService.logout()
        
        let viewController = SplashScreenViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "profile_placeholder")) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                self.gradient.removeFromSuperlayer()
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
