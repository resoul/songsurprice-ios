//
//  MainItem.swift
//  songsurprise
//
//  Created by resoul on 08.09.2024.
//

import UIKit

class MainItem: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#9ca3af")!
        
        return label
    }()
    
    private lazy var borderView = BorderGradientView()
    private lazy var iconView = UIImageView()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#9ca3af")!
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(titleLabel, iconView, descriptionLabel, borderView)
        iconView.centerYconstraint(for: self)
        titleLabel.centerXconstraint(for: self)
        iconView.constraints(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 75, height: 75))
        descriptionLabel.constraints(top: titleLabel.bottomAnchor, leading: iconView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 40, left: 10, bottom: 0, right: 10))
        borderView.constraints(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 20, right: 10), size: .init(width: 0, height: 2))
    }
    
    func configure(_ item: OnboardItem, showBorder: Bool) {
        titleLabel.text = item.title
        iconView.image = UIImage(named: item.icon)
        descriptionLabel.text = item.description
        borderView.isHidden = !showBorder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
