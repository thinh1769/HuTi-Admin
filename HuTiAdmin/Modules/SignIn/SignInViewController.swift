//
//  SignInViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: HuTiViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var changeSecureTextButton: UIButton!
    
    var viewModel = SignInViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "thinh1769@gmail.com"
        passTextField.text = "11111"
    }

    @IBAction func didTapSignInButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passTextField.text,
              password.count > 4,
              password.count < 21
        else {
            self.showAlert(title: Alert.numberOfPass)
            return
        }
        showLoading()
        viewModel.signIn(email: email, password: password)
            .subscribe { [weak self] user in
                guard let self = self else { return}
                UserDefaults.userInfo = user
                UserDefaults.token = user.token
                self.hideLoading()
                self.setRootTabBar()
            } onError: { [weak self] _ in
                guard let self = self else { return }
                self.hideLoading()
                self.showAlert(title: Alert.wrongSignInInfo)
            } onCompleted: {
                self.hideLoading()
            }.disposed(by: viewModel.bag)
    }
    
    
    @IBAction func didTapChangeSecurePassTextFieldButton(_ sender: UIButton) {
        if passTextField.isSecureTextEntry {
            passTextField.isSecureTextEntry = false
            changeSecureTextButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passTextField.isSecureTextEntry = true
            changeSecureTextButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
}
