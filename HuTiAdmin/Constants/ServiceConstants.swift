//
//  ServiceConstants.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation

enum HTTPMethodSupport: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct StatusCode {
    static let OK = 200
    static let BAD_REQUEST = 400
    static let UNAUTHORIZED = 401
    static let NOT_FOUND = 404
    static let SERVER_ERROR = 500
}

struct Base {
//    static let URL = "http://192.168.2.3:3000/api/"
    static let URL = "http://172.20.10.3:3000/api/"
}

enum APIConstants: String {
    case signIn = "user/signin"
    case sendOTP = "user/send-otp-for-register"
    case sendOTPResetPassword = "user/send-otp-for-reset-password"
    case register = "user/register"
    case resetPassword = "user/reset-password"
    case confirmOTP = "user/confirm-otp"
    case updateInfo = "user/update-info"
    case getAllUser = "user/"
    case getAllProvinces = "province"
    case getDistrictsByProvinceId = "district/p"
    case getWardsByDistrictId = "ward/d"
    case addNewPost = "post/add-post"
    case getPosts = "post/get-post"
    case getAllPosts = "post/get-all-post?page="
    case updatePost = "post/"
    case getPostById = "post/get-post-by-id/"
    case getPostByUserId = "post/get-post-by-user/"
    case getFavoritePost = "post/get-favorite-post"
    case findPost = "post/find"
    case findProject = "project/find"
    case getProject = "project"
    case getProjectById = "project/get-project-by-id/"
    case updateProject = "project/"
    case likePost = "user/like-post/"
    case dislikePost = "user/dislike-post/"
    case blockUser = "user/change-active-status/"
    
    var method: HTTPMethodSupport {
        switch self {
        case .signIn:
            return .post
        case .sendOTP:
            return .post
        case .sendOTPResetPassword:
            return .post
        case .register:
            return .post
        case .resetPassword:
            return .put
        case .confirmOTP:
            return .post
        case .updateInfo:
            return .put
        case .getAllUser:
            return .get
        case .getAllProvinces:
            return .get
        case .getDistrictsByProvinceId:
            return .get
        case .getWardsByDistrictId:
            return .get
        case .addNewPost:
            return .post
        case .getPosts:
            return .post
        case .getAllPosts:
            return .get
        case .updatePost:
            return .put
        case .getPostById:
            return .get
        case .getPostByUserId:
            return .get
        case .getFavoritePost:
            return .get
        case .findPost:
            return .post
        case .findProject:
            return .post
        case .getProject:
            return .get
        case .getProjectById:
            return .get
        case .updateProject:
            return .put
        case .likePost:
            return .put
        case .dislikePost:
            return .put
        case .blockUser:
            return .put
        }
    }
}

enum ServiceError: Error {
    case network
    case badRequest(message: String)
    case unauthorized(message: String)
    case serverError(message: String)
    case unknown(message: String)
    case emptyResponse(message: String)
    case invalidMethod
    
    func get() -> String {
        switch self {
        case .network:
            return CommonConstants.networkError
        case .badRequest(let message):
            return message
        case .unauthorized(let message):
            return message
        case .serverError(let message):
            return message
        case .unknown(let message):
            return message
        case .emptyResponse(let message):
            return message
        case .invalidMethod:
            return CommonConstants.networkError
        }
    }
}

struct AWSConstants {
    static let accessKey = "AKIA4SZBYIUOX2L46WOP"
    static let secretKey = "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"
    static let s3Bucket = "huti-kltn"
    static let objectURL = "https://huti-kltn.s3.ap-southeast-1.amazonaws.com/"
}
