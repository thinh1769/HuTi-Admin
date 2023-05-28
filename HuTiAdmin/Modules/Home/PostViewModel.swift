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
    var findPostParams = ["browseStatus": 0]
    var selectedTabIndex = 0
    
    func getAllPosts() -> Observable<[Post]> {
        return postService.getAllPost()
    }
    
    func findPost() -> Observable<[Post]> {
        return postService.findPost(param: findPostParams, page: page)
    }
}
