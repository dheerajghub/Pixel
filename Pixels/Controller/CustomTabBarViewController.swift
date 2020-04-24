//
//  CustomTabBarViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 24/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = HomeViewController()
        let imageVC = UINavigationController(rootViewController: vc1)
        imageVC.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.search, tag: 0)
        
        let vc2 = VideosViewController()
        let videoVC = UINavigationController(rootViewController: vc2)
        videoVC.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.contacts, tag: 1)
        let tabBarList = [imageVC , videoVC]
        viewControllers = tabBarList
    }
}
