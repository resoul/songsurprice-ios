//
//  MainController.swift
//  songsurprise
//
//  Created by resoul on 04.09.2024.
//

import UIKit

class MainController: UIViewController {
    
    private lazy var orderItemOne = OrderView()
    private lazy var orderItemTwo = OrderView()
    private lazy var orderItemThree = OrderView()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Create track"
        
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleButton))
        navigationItem.rightBarButtonItems = [settings]
        
        orderItemOne.configure(choseTrackItem)
        orderItemTwo.configure(recordAudioMessageItem)
        orderItemThree.configure(payOnceItem)
        
        orderItemOne.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectGenres)))
        orderItemTwo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        orderItemThree.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func setupLayout() {
        let height = UIScreen.main.bounds.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom + 215)
        view.addSubviews(orderItemOne, orderItemTwo, orderItemThree)
        orderItemOne.constraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 65, left: 15, bottom: 0, right: 15), size: .init(width: 0, height: height / 3))
        orderItemTwo.constraints(top: orderItemOne.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 15, bottom: 0, right: 15), size: .init(width: 0, height: height / 3))
        orderItemThree.constraints(top: orderItemTwo.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 15, bottom: 0, right: 15), size: .init(width: 0, height: height / 3))
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
    func handleSelectGenres() {
        navigationController?.pushViewController(GenresController(), animated: true)
    }
    
    @objc
    func handleTap() {
        navigationController?.pushViewController(SettingsController(), animated: true)
    }
    
    @objc
    func handleButton() {
        navigationController?.pushViewController(SettingsController(), animated: true)
    }
}
