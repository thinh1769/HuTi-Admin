//
//  PostViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation
import RxSwift
import RxRelay

class PostViewModel {
    let bag = DisposeBag()
    let post = BehaviorRelay<[Post]>(value: [])
    let postService = PostService()
    var page = 1
    
    func getAllPosts() -> Observable<[Post]> {
        return postService.getAllPost(page: page)
    }
}
