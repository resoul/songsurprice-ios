//
//  CollectionView.swift
//  songsurprise
//
//  Created by resoul on 07.09.2024.
//

import UIKit

extension UICollectionView {
    func register <T: UICollectionViewCell> (cell name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    func register <T: UICollectionReusableView> (supplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }
    
    func dequeueReusableCell <T: UICollectionViewCell> (withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name))")
        }
        
        return cell
    }
    
    func dequeueReusableSupplementaryView <T: UICollectionReusableView> (ofKind kind: String, withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionReusableView for \(String(describing: name))")
        }
        
        return view
    }
}
