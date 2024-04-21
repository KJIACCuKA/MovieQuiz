import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(with model: AlertModel)
}
