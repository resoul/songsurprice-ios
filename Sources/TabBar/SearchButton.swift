import UIKit

final class SearchButton: TVFocusControl {

    private let config: TabBarConfiguration

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "magnifyingglass")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let label: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    init(config: TabBarConfiguration, searchTitle: String = "Поиск") {
        self.config = config
        super.init(frame: .zero)

        label.text = searchTitle
        label.textColor = config.inactiveColor
        iconView.tintColor = config.inactiveColor

        addSubview(iconView)
        addSubview(label)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),

            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -18),
            label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            label.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -12),
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    override func applyFocusAppearance(focused: Bool) {
        label.textColor    = focused ? config.activeColor : config.inactiveColor
        iconView.tintColor = focused ? config.activeColor : config.inactiveColor
    }
}
