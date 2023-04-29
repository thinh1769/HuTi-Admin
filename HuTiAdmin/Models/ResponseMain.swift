//
//  ResponseMain.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation

class ResponseMain<Payload: Codable>: Codable {
    var status: Int
    var message: String
    var payload: Payload? = nil
}
