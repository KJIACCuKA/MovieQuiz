import UIKit

final class MQLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(labelText: String, fontSize: CGFloat, alignment: NSTextAlignment, fontStyle: UIFont.YSDisplayType, _ accessibilityID: String) {
        self.init(frame: .zero)
        set(labelText: labelText, fontSize: fontSize, alignment: alignment, fontStyle: fontStyle, accessibilityID: accessibilityID)
    }
    
    private func configure() {
        textColor = UIColor.ypWhite
        numberOfLines = 2
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func set(labelText: String, fontSize: CGFloat, alignment: NSTextAlignment, fontStyle: UIFont.YSDisplayType, accessibilityID: String) {
        text = labelText
        font = UIFont.YSDisplay(fontStyle, size: fontSize)
        textAlignment = alignment
        accessibilityIdentifier = accessibilityID
    }
}
