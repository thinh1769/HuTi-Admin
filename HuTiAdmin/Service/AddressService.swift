//
//  AddressService.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation
import RxSwift
import RxRelay

class AddressService: BaseService {
    func getAllProvinces() -> Observable<[Province]> {
        return request(api: .getAllProvinces)
    }
    
    func getDistrictsByProvinceId(provinceId: String) -> Observable<[District]> {
        let param = ["province": provinceId]
        return request(api: APIConstants.getDistrictsByProvinceId.rawValue, method: .post, params: param )
    }
    
    func getWardsByDistrictId(districtId: String) -> Observable<[Ward]> {
        let param = ["district": districtId]
        return request(api: APIConstants.getWardsByDistrictId.rawValue, method: .post, params: param)
    }
}
