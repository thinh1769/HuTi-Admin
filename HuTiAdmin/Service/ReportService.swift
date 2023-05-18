//
//  ReportService.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 18/05/2023.
//

import Foundation
import RxSwift
import RxRelay

class ReportService: BaseService {
    func getAllReport(page: Int) -> Observable<[Report]> {
        return request(api: "\(APIConstants.getAllReport.rawValue)\(page)", method: .get)
    }
}
