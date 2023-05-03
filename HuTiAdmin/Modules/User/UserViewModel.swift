//
//  UserViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 03/05/2023.
//

import Foundation
import RxSwift
import RxRelay

class UserViewModel {
    let bag = DisposeBag()
    let authService = AuthService()
    let user = BehaviorRelay<[User]>(value: [])
    var page = 1
    
    func getAllUser() -> Observable<[User]> {
        return authService.getAllUser(page: page)
    }
}
