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
    func getAllReport() -> Observable<[Report]> {
        return request(api: APIConstants.getAllReport.rawValue, method: .get)
    }
    
    func getReportByStatus(status: Int, page: Int) -> Observable<[Report]> {
        let param = ["status": status]
        return request(api: APIConstants.getReportByStatus.rawValue + "\(page)", method: .post , params: param)
    }
    
    func processReport(reportId: String) -> Observable<String> {
        let param = ["status": 1]
        return request(api: APIConstants.processReport.rawValue + reportId, method: .put, params: param)
    }
    
    func sendEmail(email: String, content: String) -> Observable<String> {
        let params = ["email": email, "content": content]
        return request(api: APIConstants.sendReportEmail.rawValue, method: .post, params: params)
    }
}
