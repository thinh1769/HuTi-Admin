//
//  PostDetailViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 30/04/2023.
//

import Foundation
import RxSwift
import RxRelay

class PostDetailViewModel {
    var postId = ""
    let postService = PostService()
    let projectService = ProjectService()
    let images = BehaviorRelay<[String]>(value: [])
    var postDetail: PostDetail?
    var project: Project?
    var isFavorite = false
    var selectedTabIndex = 0
    let bag = DisposeBag()
    var browsePostParams = [String: Any]()
    
    func getPostDetail(postId: String) -> Observable<PostDetail> {
        return postService.getPostById(postId: postId)
    }
    
    func getProjectById(projectId: String) -> Observable<Project> {
        return projectService.getProjectById(projectId: projectId)
    }
    
    func browsePost() -> Observable<Post> {
        return postService.updatePost(postId: postId, param: browsePostParams)
    }
    
    func deletePost() -> Observable<String> {
        return postService.deletePost(postId: postId)
    }
}
