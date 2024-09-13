import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLogo()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func setUpLogo() {
        // Unsplash Logo
        let unsplashLogo = UIImage(named: "logo_of_unsplash")
        let unsplashLogoImageView = UIImageView(image: unsplashLogo)
        unsplashLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(unsplashLogoImageView)
        
        NSLayoutConstraint.activate([
            unsplashLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unsplashLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            unsplashLogoImageView.heightAnchor.constraint(equalToConstant: 60),
            unsplashLogoImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.didAuthenticate(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
}



