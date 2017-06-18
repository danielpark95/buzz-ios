//
//  customTabBarController.swift
//  familiarize
//
//  Created by Alex Oh on 5/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
extension UITabBarController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}
class CustomTabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
        contactsNavigationController.tabBarItem.image = UIImage(named: "contacts")?.withRenderingMode(.alwaysOriginal)
        contactsNavigationController.tabBarItem.selectedImage = UIImage(named: "contacts-bold")?.withRenderingMode(.alwaysOriginal)
        contactsNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        
        let famController = FamiliarizeController(collectionViewLayout: UICollectionViewFlowLayout())
        let famNavigationController = UINavigationController(rootViewController: famController)
        famNavigationController.tabBarItem.image = UIImage(named: "fam")?.withRenderingMode(.alwaysOriginal)
        famNavigationController.tabBarItem.selectedImage = UIImage(named: "fam-bold")?.withRenderingMode(.alwaysOriginal)
        famNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        
        let userController = FamiliarizeController(collectionViewLayout: UICollectionViewFlowLayout())
        let userNavigationController = UINavigationController(rootViewController: userController)
        userNavigationController.tabBarItem.image = UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
        userNavigationController.tabBarItem.selectedImage = UIImage(named: "user-bold")?.withRenderingMode(.alwaysOriginal)
        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        viewControllers = [contactsNavigationController, famNavigationController, userNavigationController]
        
        setupCustomTabBar()
    }
    

    
    func tabBarController(_ didSelecttabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        if let vc = viewController as? UINavigationController {
            vc.dismiss(animated: false)
        }
    }

    func setupCustomTabBar() {
        tabBar.isTranslucent = false
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 45
        tabFrame.origin.y = self.view.frame.size.height - 45
        self.tabBar.frame = tabFrame
    }
    

}


