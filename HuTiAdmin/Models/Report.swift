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
    var reportUserName: String
    var reportUserPhone: String
    var reportUserEmail: String
    var postUserId: String
    var postUserName: String
    var postUserPhone: String
    var postUserEmail: String
    var status: Int
    var postTitle: String
    var content: String
    var createdAt: Int
    
    func getDate() -> String {
        return createdAt.parseDateTime()
    }
}
