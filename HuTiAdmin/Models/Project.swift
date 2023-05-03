//
//  Project.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation

struct Project: Codable {
    var id: String?
    var provinceCode: String
    var provinceName: String
    var districtCode: String
    var districtName: String
    var wardCode: String
    var wardName: String
    var name: String
    var minPrice: Double
    var maxPrice: Double
    var priceRange: String?
    var status: String
    var openForSaleTime: String?
    var lat: Double
    var long: Double
    var projectType: String
    var apartment: Int?
    var acreage: String
    var building: Int?
    var legal: String?
    var investor: String
    var description: String
    var images: [String]
    var posts: [String]?
    
    func getFullAddress() -> String {
        return "\(wardName), \(districtName), \(provinceName)"
    }
    
    func getPrice() -> String {
        return "\(minPrice) - \(maxPrice) triệu/m2"
    }
}
