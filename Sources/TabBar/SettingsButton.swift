import UIKit

final class SettingsButton: TVFocusControl {
    var canFocusAfterDismiss: Bool = true
    override var canBecomeFocused: Bool { canFocusAfterDismiss }

    private let config: TabBarConfiguration

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "gearshape.fill")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    init(config: TabBarConfiguration) {
        self.config = config
        super.init(frame: .zero)

        iconView.tintColor = config.inactiveColor
        addSubview(iconView)

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            bgView.widthAnchor.constraint(equalToConstant: 52),
            bgView.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    override func applyFocusAppearance(focused: Bool) {
        iconView.tintColor = focused ? config.activeColor : config.inactiveColor
    }
}
