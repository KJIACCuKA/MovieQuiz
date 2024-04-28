import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(with model: AlertModel)
}
