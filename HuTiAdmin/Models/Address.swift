//
//  Address.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation

struct Province: Codable {
    var id: String
    var idProvince: String
    var name: String
}

struct District: Codable {
    var id: String
    var idProvince: String
    var idDistrict: String
    var name: String
}

struct Ward: Codable {
    var id: String
    var idDistrict: String
    var idWard: String
    var name: String
}
