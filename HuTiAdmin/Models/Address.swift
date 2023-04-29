//
//  Address.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation

struct Province: Codable {
    var code: String
    var name: String
    var unit: String
}

struct District: Codable {
    var code: String
    var name: String
    var unit: String
    var province_code: String
    var province_name: String
    var full_name: String
}

struct Ward: Codable {
    var code: String
    var name: String
    var unit: String
    var district_code: String
    var district_name: String
    var province_code: String
    var province_name: String
    var full_name: String
}
