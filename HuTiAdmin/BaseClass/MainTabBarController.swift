//
//  MainTabBarController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let postTab = PostViewController()
        let postNaVC = UINavigationController(rootViewController: postTab)
        
        let projectTab = ProjectViewController()
        let projectNaVC = UINavigationController(rootViewController: projectTab)
        
        let userTab = PostViewController()
        let userNaVC = UINavigationController(rootViewController: userTab)
        
        postTab.title = "Tin đăng"
        projectTab.title = "Dự án"
        userTab.title = "Tài khoản"

        postTab.tabBarItem.image = UIImage(named: ImageName.house)
        projectTab.tabBarItem.image = UIImage(named: ImageName.project)
        userTab.tabBarItem.image = UIImage(named: ImageName.user)
        
        let tabBarItemList = [postNaVC, projectNaVC, userNaVC]
        
        self.setViewControllers(tabBarItemList, animated: true)
        
        self.tabBar.tintColor = UIColor(named: ColorName.themeText)
        self.tabBar.backgroundColor = UIColor(named: ColorName.white)
    }
}

