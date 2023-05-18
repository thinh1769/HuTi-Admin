//
//  ReportViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 18/05/2023.
//

import Foundation
import RxSwift
import RxRelay

class ReportViewModel {
    let bag = DisposeBag()
    let reportService = ReportService()
    let report = BehaviorRelay<[Report]>(value: [])
    var page = 1
    
    func getListReport() -> Observable<[Report]> {
        return reportService.getAllReport(page: page)
    }
}
