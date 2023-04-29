//
//  HuTiViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import UIKit
import MBProgressHUD
import SDWebImage
import SVPullToRefresh

class HuTiViewController: UIViewController {
 
    let pullToRefresh = SVPullToRefreshView()
    var progressHUD = MBProgressHUD()
    
    var mainTabBarController: MainTabBarController? {
        return tabBarController as? MainTabBarController
    }
    
    var isHiddenMainTabBar = false {
        didSet {
            self.mainTabBarController?.tabBar.isHidden = isHiddenMainTabBar
        }
    }
    
    var isHiddenNavigationBar = true {
        didSet {
            self.navigationController?.isNavigationBarHidden = isHiddenNavigationBar
        }
    }
    
    var isTouchDismissKeyboardEnabled = false {
        didSet {
            if isTouchDismissKeyboardEnabled {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGesture.cancelsTouchesInView = false
                view.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHiddenNavigationBar = true
    }
    
    @objc func dismissKeyboard() {
        view.window?.endEditing(true)
    }
    
    func navigateTo(_ controller: UIViewController, _ animated: Bool = true) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
    func backToPreviousView(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func setRootTabBar() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: {},
                          completion: nil)
    }
    
    func showLoading() {
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.mode = MBProgressHUDMode.indeterminate
    }
    
    func hideLoading() {
        progressHUD.hide(animated: true)
    }
    
//    func isFavoritePost(postId: String?) -> Bool {
//        guard let likePosts = UserDefaults.userInfo?.likePosts,
//              likePosts.count > 0,
//              let postId = postId
//        else { return false }
//        for (_, element) in likePosts.enumerated() {
//            if element == postId {
//                return true
//            }
//        }
//        return false
//    }
    
    func showAlert(title: String) {
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        
//        let okAction = UIAlertAction(title: LocalizedString("lbl_ok", nil), style: .default) { [weak self] (_) in
//            guard let self = self else { return }
//            self.loginManager.logout()
//            self.navigationController?.popToRootViewController(animated: true)
//        }
        
        let okAction = UIAlertAction(
            title: Alert.ok,
            style: .cancel,
            handler: nil
        )
        
//        alert.addAction(okAction)
        alert.addAction(okAction)
        
        self.parent?.present(alert, animated: true, completion: nil)
    }
}
