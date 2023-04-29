//
//  SignInViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import UIKit

class SignInViewController: HuTiViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didTapSignInButton(_ sender: UIButton) {
        guard let phoneNumber = phoneTextField.text,
              phoneNumber.count == 10
        else {
            self.showAlert(title: Alert.numberOfPhoneNumber)
            return
        }
        guard let password = passTextField.text,
              password.count > 4,
              password.count < 21
        else {
            self.showAlert(title: Alert.numberOfPass)
            return
        }
        showLoading()
        viewModel.signIn(phoneNumber: phoneNumber, password: password)
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
}
