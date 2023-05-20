//
//  ReportDetailViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 19/05/2023.
//

import Foundation
import RxSwift
import RxRelay

class ReportDetailViewModel {
    var report: Report?
    let bag = DisposeBag()
    let reportService = ReportService()
    
    func processReport() -> Observable<String> {
        return reportService.processReport(reportId: report?.id ?? "")
    }
    
    func sendEmail(email: String, content: String) -> Observable<String> {
        return reportService.sendEmail(email: email, content: content)
    }
    
}
