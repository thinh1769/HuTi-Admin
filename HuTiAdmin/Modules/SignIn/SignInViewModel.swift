//
//  SignInViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation
import RxRelay
import RxSwift

class SignInViewModel {
    let bag = DisposeBag()
    let authService = AuthService()
    
    func signIn(email: String, password: String) -> Observable<User> {
        return authService.signIn(email: email, password: password)
    }
}
