import UIKit

final class GenreButton: TVFocusControl {

    var isActiveTab: Bool = false {
        didSet {
            guard oldValue != isActiveTab else { return }
            updateLook(animated: true)
        }
    }

    private let config: TabBarConfiguration

    private let label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let accentDot: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 2.5
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    init(genre: GenreItem, config: TabBarConfiguration) {
        self.config = config
        super.init(frame: .zero)

        label.text = genre.title
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = config.inactiveColor

        bgView.removeFromSuperview()
        addSubview(bgView)
        addSubview(label)
        addSubview(accentDot)
        bgView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),

            label.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -14),
            label.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),

            accentDot.bottomAnchor.constraint(equalTo: bottomAnchor),
            accentDot.centerXAnchor.constraint(equalTo: centerXAnchor),
            accentDot.widthAnchor.constraint(equalToConstant: 16),
            accentDot.heightAnchor.constraint(equalToConstant: 3),
        ])

        updateLook(animated: false)
    }
    required init?(coder: NSCoder) { fatalError() }

    private func updateLook(animated: Bool) {
        let block = {
            self.label.textColor = self.isActiveTab ? self.config.activeColor : self.config.inactiveColor
            self.label.font      = UIFont.systemFont(ofSize: 20, weight: self.isActiveTab ? .bold : .semibold)
            self.bgView.backgroundColor = UIColor(white: 1, alpha: self.isActiveTab ? 0.10 : 0)
            self.accentDot.alpha     = self.isActiveTab ? 1 : 0
            self.accentDot.transform = self.isActiveTab ? .identity : CGAffineTransform(scaleX: 0.4, y: 1)
        }
        if animated {
            UIView.animate(withDuration: 0.22, delay: 0,
                           usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5,
                           animations: block)
        } else { block() }
    }

    override func applyFocusAppearance(focused: Bool) {
        label.textColor = focused ? config.activeColor : (isActiveTab ? config.activeColor : config.inactiveColor)
        bgView.backgroundColor = UIColor(white: 1,
            alpha: focused ? focusedBgAlpha : (isActiveTab ? 0.10 : 0))
    }
}
