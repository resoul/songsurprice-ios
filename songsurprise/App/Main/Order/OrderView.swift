//
//  OrderView.swift
//  songsurprise
//
//  Created by resoul on 07.09.2024.
//

import UIKit

class OrderView: UIView {
    
    private lazy var iconView = UIImageView()
    private lazy var textView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#9ca3af")!
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .justified
        label.textColor = UIColor(hex: "#9ca3af")!
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var content: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(content)
        content.constraints(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        content.addSubviews(titleLabel, textView)
        
        titleLabel.constraints(top: content.topAnchor, leading: content.leadingAnchor, bottom: nil, trailing: content.trailingAnchor, padding: .init(top: 15, left: 5, bottom: 0, right: 5))
        textView.constraints(top: titleLabel.bottomAnchor, leading: content.leadingAnchor, bottom: content.bottomAnchor, trailing: content.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 5, right: 5))
        textView.addSubviews(iconView, descriptionLabel)
        iconView.centerYconstraint(for: textView)
        iconView.constraints(top: nil, leading: textView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 75, height: 75))
        descriptionLabel.centerYconstraint(for: textView)
        descriptionLabel.constraints(top: nil, leading: iconView.trailingAnchor, bottom: nil, trailing: textView.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
    }
    
    func configure(_ item: OnboardItem) {
        iconView.image = UIImage(named: item.icon)
        descriptionLabel.text = item.description
        titleLabel.text = item.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(hex: "#ea580c")!.cgColor, UIColor(hex: "#4f46e5")!.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 8
        layer.insertSublayer(l, at: 0)
        return l
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
