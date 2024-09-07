//
//  TracksItemView.swift
//  songsurprise
//
//  Created by resoul on 07.09.2024.
//

import UIKit

class TracksItemView: UITableViewCell {
    
    private lazy var coverView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "#9ca3af")!
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(titleLabel, detailsLabel, coverView)
        coverView.constraints(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 0), size: .init(width: 90, height: 90))
        titleLabel.constraints(top: topAnchor, leading: coverView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 22, left: 15, bottom: 0, right: 0))
        detailsLabel.constraints(top: nil, leading: coverView.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 15, bottom: 22, right: 0))
    }
    
    func configure(_ song: Track) {
        coverView.image = UIImage(named: song.imageName)
        titleLabel.text = song.artistName
        detailsLabel.text = song.trackName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
