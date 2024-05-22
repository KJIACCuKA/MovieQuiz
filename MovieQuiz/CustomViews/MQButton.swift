import UIKit

final class MQButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, accessibilityID: String) {
        self.init(frame: .zero)
        set(title: title, accessibilityID: accessibilityID)
    }
    
    private func configure() {
        layer.cornerRadius = 15
        titleLabel?.font = UIFont.YSDisplay(.medium, size: 20)
        setTitleColor(.ypBlack, for: .normal)
        backgroundColor = UIColor.ypWhite
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func set(title: String, accessibilityID: String) {
        setTitle(title, for: .normal)
        accessibilityIdentifier = accessibilityID
    }
    
}
