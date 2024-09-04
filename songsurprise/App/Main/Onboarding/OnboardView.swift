//
//  OnboardView.swift
//  songsurprise
//
//  Created by resoul on 04.09.2024.
//

import UIKit

class OnboardView: UIView {
    
    private lazy var iconView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
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
        addSubviews(iconView, titleLabel, descriptionLabel)
        
        iconView.constraints(top: nil, leading: nil, bottom: titleLabel.topAnchor, trailing: nil, size: .init(width: 75, height: 75))
        iconView.centerXconstraint(for: self)
        titleLabel.centerXconstraint(for: self)
        titleLabel.centerYconstraint(for: self)
        descriptionLabel.constraints(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 17, left: 25, bottom: 0, right: 25))
    }
    
    func setup(title: String, description: String, icon: UIImage?) {
        titleLabel.text = title
        descriptionLabel.text = description
        if let icon = icon {
            iconView.image = icon
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradient = getGradientLayer(bounds: titleLabel.bounds)
        titleLabel.textColor = gradientColor(bounds: titleLabel.bounds, gradientLayer: gradient)
    }
    
    func gradientColor(bounds: CGRect, gradientLayer : CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: image!)
    }
    
    func getGradientLayer(bounds : CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor(hex: "#ea580c")!.cgColor, UIColor(hex: "#4f46e5")!.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradient
    }
}
