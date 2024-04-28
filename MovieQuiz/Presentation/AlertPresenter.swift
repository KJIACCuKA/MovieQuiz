import UIKit


class AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
    
    func presenterAlert(with model: AlertModel) {
        delegate?.showAlert(with: model)
    }
}
