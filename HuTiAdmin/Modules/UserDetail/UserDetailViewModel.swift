//
//  UserDetailViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 03/05/2023.
//

import Foundation
import RxSwift
import RxRelay

class UserDetailViewModel {
    let bag = DisposeBag()
    let postService = PostService()
    let authService = AuthService()
    let post = BehaviorRelay<[Post]>(value: [])
    var user: User?
    var userId = ""
    var page = 1
    
    func getPostByUser() -> Observable<[Post]> {
        return postService.getPostByUserId(page: page, userId: user?.id ?? "")
    }
    
    func blockUser() -> Observable<User> {
        return authService.blockUser(userId: user?.id ?? "")
    }
    
    func getUserById() -> Observable<User> {
        return authService.getUserById(userId: userId)
    }
}
