//
//  PostService.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation
import RxSwift
import RxRelay

class PostService: BaseService {
    func getAllPost(page: Int) -> Observable<[Post]> {
        return request(api: "\(APIConstants.getAllPosts.rawValue)\(page)", method: .get)
    }
    
    func addPost(params: [String: Any]) -> Observable<PostDetail> {
        return request(api: APIConstants.addNewPost.rawValue, method: .post, params: params)
    }
    
    func getListPosts(isSell: Bool, page: Int) -> Observable<[Post]> {
        let param = ["isSell": isSell]
        return request(api: "\(APIConstants.getPosts.rawValue)?page=\(page)" , method: .post, params: param)
    }
    
    func getPostById(postId: String) -> Observable<PostDetail> {
        return request(api: APIConstants.getPostById.rawValue + postId, method: .get)
    }
    
    func getPostByUserId(page: Int, userId: String) -> Observable<[Post]> {
        return request(api: "\(APIConstants.getPostByUserId.rawValue)\(userId)?page=\(page)", method: .get)
    }
    
    func getFavoritePost(page: Int) -> Observable<[Post]> {
        return request(api: "\(APIConstants.getFavoritePost.rawValue)?page=\(page)", method: .get)
    }
    
    func findPost(param: [String: Any], page: Int) -> Observable<[Post]> {
        return request(api: "\(APIConstants.findPost.rawValue)?page=\(page)", method: .post, params: param)
    }
    
    func updatePost(postId: String, param: [String: Any]) -> Observable<Post> {
        return request(api: APIConstants.updatePost.rawValue + postId, method: .put, params: param)
    }
}

