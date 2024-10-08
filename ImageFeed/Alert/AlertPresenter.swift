import UIKit

final class AlertPresenter: AlertPresenterDelegate {
    
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController? = nil) {
        self.delegate = delegate
    }
    
    func showAlert(vc: UIViewController, model: AlertModel) {
        let alertController = UIAlertController(title: model.title,
                                                message: model.message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: model.title, style: .default, handler: model.completion)
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
}
