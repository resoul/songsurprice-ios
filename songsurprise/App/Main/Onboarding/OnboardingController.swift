//
//  OnboardingController.swift
//  songsurprise
//
//  Created by resoul on 04.09.2024.
//

import UIKit

class OnboardingController: UIViewController {
    
    private let onboardItems: [OnboardItem] = [
        choseTrackItem,
        recordAudioMessageItem,
        payOnceItem
    ]
    private var currentIndex = 0
    private var currentController: UIViewController?
    
    private lazy var getStartedButton: ActualGradientButton = {
        let button = ActualGradientButton(type: .custom)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleStartedButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        
        let controller = UIViewController()
        currentController = controller
        addChildController(controller)
        
        view.addSubview(getStartedButton)
        getStartedButton.constraints(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 25, bottom: 25, right: 25), size: .init(width: 0, height: 50))
    }
    
    private func addChildController(_ childVC: UIViewController) {
        addChild(childVC)
        childVC.view.frame = view.bounds
        
        let onboard = OnboardView()
        
        childVC.view.addSubview(onboard)
        onboard.constraints(top: childVC.view.safeAreaLayoutGuide.topAnchor, leading: childVC.view.leadingAnchor, bottom: childVC.view.safeAreaLayoutGuide.bottomAnchor, trailing: childVC.view.trailingAnchor)
        onboard.setup(title: onboardItems[currentIndex].title, description: onboardItems[currentIndex].description, icon: UIImage(named: onboardItems[currentIndex].icon))
        
        view.insertSubview(childVC.view, belowSubview: getStartedButton)
        childVC.didMove(toParent: self)
    }
    
    @objc
    func handleStartedButton() {
        currentIndex = currentIndex + 1
        guard currentIndex != onboardItems.count else {
            UserDefaults.standard.setValue(true, forKey: "onborded")
            UserDefaults.standard.synchronize()
            dismiss(animated: true)
            return
        }
        
        if onboardItems.count == (currentIndex + 1) {
            getStartedButton.setTitle("Get Started", for: .normal)
        }
        
        guard let currentVC = currentController else { return }
        currentVC.willMove(toParent: nil)
        currentVC.view.removeFromSuperview()
        currentVC.removeFromParent()
        
        let controller = UIViewController()
        currentController = controller
        addChildController(controller)
    }
}
