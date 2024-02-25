////
////  BaseTabBarControllerViewController.swift
////  ChoiceOfTwo
////
////  Created by Yaroslav Sokolov on 17/02/2024.
////
//
//import UIKit
//
//class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {
//    
//    
//    //MARK: - Variables
////    weak var coordinator: AppCoordinator?
////    private let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
////    
//    private let menuController = MenuController()
//    private let profileController = ProfileController()
//    private let startGameController = ProfileController()
//    
//    
////    init(coordinator: AppCoordinator) {
//    init() {
////        self.coordinator = coordinator
//        super.init(nibName: "BaseTabBarController", bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
////        let app = UITabBarAppearance()
////        app.backgroundEffect = .none
////        app.shadowColor = .clear
////        tabBar.standardAppearance = app
//        
//        setupTabBar()
//        tabBarIcon()
//        
//        let layer = CAShapeLayer()
//        layer.path = UIBezierPath(roundedRect: 
//                                    CGRect(
//                                        x: 30,
//                                        y: self.tabBar.bounds.minY + 5,
//                                        width: self.tabBar.bounds.width - 60,
//                                        height: self.tabBar.bounds.height + 10
//                                    ), cornerRadius: (self.tabBar.frame.width/2)).cgPath
//        
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
//        layer.shadowRadius = 25.0
//        layer.shadowOpacity = 0.3
//        layer.borderWidth = 1.0
//        layer.opacity = 1.0
////        layer.isHidden = false
//        layer.masksToBounds = false
//        layer.fillColor = UIColor.white.cgColor
//        
//        self.tabBar.layer.insertSublayer(layer, at: 0)
//        
//        if let items = self.tabBar.items {
//            items.forEach { item in item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -25, right: 0) }
//        }
//        self.tabBar.itemWidth = 80.0
//        self.tabBar.itemPositioning = .centered
//
//    }
//    
//    
//    
//    //MARK: - Setup
//    private func setupTabBar() {
//        delegate = self
//        tabBar.isTranslucent = true
//        
//        configureControllers()
//    }
//    
//    private func tabBarIcon() {
//        let icon1 = UITabBarItem(title: "Home", image: UIImage(named: "Logout"), tag: 1)
//        menuController.tabBarItem = icon1
//        
//        let icon2 = UITabBarItem(title: "Play", image: UIImage(named: "Logout"), tag: 3)
//        startGameController.tabBarItem = icon2
//        
//        let icon3 = UITabBarItem(title: "Profile", image: UIImage(named: "Logout"), tag: 2)
//        profileController.tabBarItem = icon3
////        let icon1 = UITabBarI
//    }
//    
//    private func configureControllers() {
//        let navigationController1 = menuController
//        let navigationController2 = startGameController
//        let navigationController3 = profileController
//        viewControllers = [navigationController1, navigationController2, navigationController3]
//    }
//    
//    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
////        if viewController.isKind(of: )
//        return true
//    }
//}
