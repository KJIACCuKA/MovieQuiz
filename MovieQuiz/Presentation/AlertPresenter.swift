import UIKit


class AlertPresenter: AlertPresenterProtocol {
    func showAlert(with model: AlertModel) {
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alertController.addAction(action)
        delegate?.present(alertController, animated: true, completion: nil)
    }
    
    
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
}
