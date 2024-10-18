import UIKit
import ProgressHUD

final class SplashScreenViewController: UIViewController {
    private let storage = OAuthTokenStorage()
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private var alertPresenter: AlertPresenter?
    
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchScreenImage")
        return imageView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkToken()
        setupViewAndConstraints()
    }
    private func setupViewAndConstraints() {
        view.backgroundColor = .ypBlack
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 78),
            imageView.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
    private func checkToken() {
        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            let authViewController = AuthViewController()
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        }
    }
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self]  in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                guard let token = storage.token else { return }
                fetchProfile(token: token)
            case .failure(let error):
                print("\(error.localizedDescription) - error fetching oauth token")
                let alertModel = AlertModel(title: "Что-то пошло не так(",
                                            message: "Не удалось войти в систему",
                                            buttonText: "Ок",
                                            completion: nil)
                
                alertPresenter?.showAlert(vc: self, model: alertModel)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                switchToTabBarController()
            case .failure(let error):
                print("\(error.localizedDescription) - error fetching profile")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
