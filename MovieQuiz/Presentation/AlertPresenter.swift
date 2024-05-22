import UIKit

final class AlertPresenter {
    
    var alertModel: AlertModel
    
    init(alertModel: AlertModel) {
        self.alertModel = alertModel
    }
    
    func showAlert(viewController: UIViewController) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            self.alertModel.completion()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
