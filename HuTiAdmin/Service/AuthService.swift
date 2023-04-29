//
//  AuthService.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation
import Alamofire
import RxSwift
import Security

class AuthService: BaseService {
    func signIn(phoneNumber: String, password: String) -> Observable<User> {
        let params = ["phoneNumber" : phoneNumber, "password": password]
        return authRequest(api: APIConstants.signIn, method: .post, parameters: params)
    }
    
    func sendOTP(phoneNumber: String) -> Observable<User> {
        let param = ["phoneNumber" : phoneNumber]
        return authRequest(api: APIConstants.sendOTP, method: .post, parameters: param)
    }
    
    func confirmOTP(phoneNumber: String, otp: String) -> Observable<User> {
        let params = ["phoneNumber" : phoneNumber, "otp" : otp]
        return authRequest(api: APIConstants.confirmOTP, method: .post, parameters: params)
    }
    
    func register(phoneNumber: String, otp: String, password: String) -> Observable<User> {
        let params = ["phoneNumber" : phoneNumber, "otp" : otp, "password": password]
        return authRequest(api: APIConstants.register, method: .post, parameters: params)
    }
    
    func updateInfo(user: User) -> Observable<User> {
        return authRequest(api: APIConstants.updateInfo, method: .put, parameters: user)
    }
    
    func sendOTPResetPassword(phoneNumber: String) -> Observable<User> {
        let param = ["phoneNumber" : phoneNumber]
        return authRequest(api: APIConstants.sendOTPResetPassword, method: .post, parameters: param)
    }
    
    func resetPassword(phoneNumber: String, otp: String, password: String) -> Observable<User> {
        let params = ["phoneNumber" : phoneNumber, "otp" : otp, "password": password]
        return authRequest(api: APIConstants.resetPassword, method: .put, parameters: params)
    }
    
    func likePost(postId: String) -> Observable<String> {
        return request(api: APIConstants.likePost.rawValue + postId, method: .put)
    }
    
    func dislikePost(postId: String) -> Observable<String> {
        return request(api: APIConstants.dislikePost.rawValue + postId, method: .put)
    }
//    func logOut() -> Observable<String> {
//        return request(api: .logout)
//    }
}

