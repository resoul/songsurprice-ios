//
//  OnboardItem.swift
//  songsurprise
//
//  Created by resoul on 04.09.2024.
//

import UIKit

struct OnboardItem {
    let icon: String
    let title: String
    let description: String
    let controller: UIViewController
    
    init(icon: String, title: String, description: String, controller: UIViewController) {
        self.icon = icon
        self.title = title
        self.description = description
        self.controller = controller
    }
}
