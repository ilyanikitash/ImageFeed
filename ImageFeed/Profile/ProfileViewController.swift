import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        create()
    }
    private func create() {
//      Profile Image
        let profileImage = UIImage(named: "Userpick")
        let imageView = UIImageView(image: profileImage)
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
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ])
//      Login Label
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = .ypGray
        loginLabel.font = UIFont.systemFont(ofSize: 13.0)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
//      Description Label
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello World!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13.0)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor)
        ])
//      Escape Button
        let escapeButton = UIButton.systemButton(with: UIImage(
                                                systemName: "ipad.and.arrow.forward") ?? UIImage(),
                                                target: nil,
                                                action: nil)
        escapeButton.tintColor = .ypRed
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
