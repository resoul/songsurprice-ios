//
//  OnboardItem.swift
//  songsurprise
//
//  Created by resoul on 04.09.2024.
//

import Foundation

struct OnboardItem {
    let icon: String
    let title: String
    let description: String
    
    init(icon: String, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}
