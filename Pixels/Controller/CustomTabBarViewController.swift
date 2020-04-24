//
//  CustomTabBarViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 24/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    var tabItem = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = ImagesViewController()
        let imageVC = UINavigationController(rootViewController: vc1)
        
        let vc2 = VideosViewController()
        let videoVC = UINavigationController(rootViewController: vc2)
        
        let tabBarList = [imageVC , videoVC]
        viewControllers = tabBarList
        
        
        setUpViews()
        
        customTab(selectedImage: "images-selected", deselectedImage: "images", indexOfTab: 0 , tabTitle: "")
        customTab(selectedImage: "videos-selected", deselectedImage: "videos", indexOfTab: 1 , tabTitle: "")
    }
    
    func setUpViews(){
        self.tabBar.isTranslucent = true
        self.tabBar.barTintColor = UIColor.white
    }
    
    func customTab(selectedImage image1 : String , deselectedImage image2: String , indexOfTab index: Int , tabTitle title: String ){

        let selectedImage = UIImage(named: image1)!.withRenderingMode(.alwaysOriginal)
        let deselectedImage = UIImage(named: image2)!.withRenderingMode(.alwaysOriginal)
        tabItem = self.tabBar.items![index]
        tabItem.image = deselectedImage
        tabItem.selectedImage = selectedImage
        tabItem.title = .none
        tabItem.imageInsets.bottom = -11

    }
}
