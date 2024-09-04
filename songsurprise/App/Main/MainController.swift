//
//  MainController.swift
//  songsurprise
//
//  Created by resoul on 04.09.2024.
//

import UIKit

class MainController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = .systemBackground
        navigationItem.title = "Create track"
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleButton))
        navigationItem.rightBarButtonItems = [settings]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: "onborded") == false {
            let controller = OnboardingController()
            controller.modalPresentationStyle = .overCurrentContext
            parent?.present(controller, animated: false)
        }
    }
    
    @objc
    func handleButton() {
        navigationController?.pushViewController(SettingsController(), animated: true)
    }
}
