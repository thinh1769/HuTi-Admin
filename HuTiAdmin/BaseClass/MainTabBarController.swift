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
        
        let userTab = UserViewController()
        let userNaVC = UINavigationController(rootViewController: userTab)
        
        let reportTab = ReportViewController()
        let reportNaVC = UINavigationController(rootViewController: reportTab)
        
        let statisticsTab = StatisticsViewController()
        let statisticsNaVC = UINavigationController(rootViewController: statisticsTab)
        
        postTab.title = "Tin đăng"
        projectTab.title = "Dự án"
        userTab.title = "Tài khoản"
        reportTab.title = "Báo cáo"
        statisticsTab.title = "Thống kê"

        postTab.tabBarItem.image = UIImage(named: ImageName.house)
        projectTab.tabBarItem.image = UIImage(named: ImageName.project)
        userTab.tabBarItem.image = UIImage(named: ImageName.user)
        reportTab.tabBarItem.image = UIImage(systemName: "exclamationmark.triangle")
        statisticsTab.tabBarItem.image = UIImage(systemName: ImageName.chart)
        
        let tabBarItemList = [postNaVC, projectNaVC, userNaVC, reportNaVC, statisticsNaVC]
        
        self.setViewControllers(tabBarItemList, animated: true)
        
        self.tabBar.tintColor = UIColor(named: ColorName.themeText)
        self.tabBar.backgroundColor = UIColor(named: ColorName.white)
    }
}

