//
//  Report.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 18/05/2023.
//

import Foundation

struct Report: Codable {
    var id: String?
    var postId: String
    var reportUserId: String
    var reportUserName: String?
    var reportUserPhone: String?
    var postUserId: String
    var postUserName: String?
    var postUserPhone: String?
    var postTitle: String
    var content: String
    
//    enum CodingKeys: String, CodingKey {
//            case id = "id"
//            case postId = "postId"
//        }
}
