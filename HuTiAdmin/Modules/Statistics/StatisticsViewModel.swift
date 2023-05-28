//
//  StatisticsViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 28/05/2023.
//

import Foundation
import RxSwift
import RxRelay
import Charts

class StatisticsViewModel {
    let bag = DisposeBag()
    let postService = PostService()
    let reportService = ReportService()
    let type = BehaviorRelay<[String]>(value: [])
    let date = BehaviorRelay<[String]>(value: [])
    var selectedType = -1
    var selectedDate = ""
    var previousDate = ""
    var nextDate = ""
    var formatString = ""
    var chartYLabel = [String]()
    var isStatisticsPost = true
    
    func pickItem(pickerTag: Int) -> String? {
        switch pickerTag{
        case PickerTag.type:
            if type.value.count > 0 && selectedType >= 0 {
                return type.value[selectedType]
            } else if selectedType == -1 {
                selectedType = 0
                return type.value[0]
            } else {
                return ""
            }
        default:
            return ""
        }
    }
    
    func getAllPosts() -> Observable<[Post]> {
        return postService.getAllPost()
    }
    
    func getAllReport() -> Observable<[Report]> {
        return reportService.getAllReport()
    }
    
    func parsePostArray(posts: [Post]) -> [BarChartDataEntry] {
        let dateFormatter = DateFormatter.instance(formatString: formatString)

        switch formatString {
        case CommonConstants.DATE_FORMAT:
            previousDate = selectedDate.getYesterday() ?? ""
            nextDate = selectedDate.getTomorrow() ?? ""
        case CommonConstants.MONTH_FORMAT:
            previousDate = selectedDate.getLastMonth() ?? ""
            nextDate = selectedDate.getNextMonth() ?? ""
        default:
            previousDate = selectedDate.getLastYear() ?? ""
            nextDate = selectedDate.getNextYear() ?? ""
        }
        
        let currentDatePosts = posts.filter { post in
            let postDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(post.createdAt/1000)))
            return postDate == selectedDate
        }

        let previousDatePosts = posts.filter { post in
            let postDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(post.createdAt/1000)))
            return postDate == previousDate
        }
        
        let nextDatePosts = posts.filter { post in
            let postDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(post.createdAt/1000)))
            return postDate == nextDate
        }
        let data: [BarChartDataEntry] = [
            BarChartDataEntry(x: 0, y: Double(previousDatePosts.count)),
            BarChartDataEntry(x: 1, y: Double(currentDatePosts.count)),
            BarChartDataEntry(x: 2, y: Double(nextDatePosts.count)),
        ]
        chartYLabel = [previousDate, selectedDate, nextDate]
        return data
    }
    
    func parseReportArray(reports: [Report]) -> [BarChartDataEntry] {
        let dateFormatter = DateFormatter.instance(formatString: formatString)

        switch formatString {
        case CommonConstants.DATE_FORMAT:
            previousDate = selectedDate.getYesterday() ?? ""
            nextDate = selectedDate.getTomorrow() ?? ""
        case CommonConstants.MONTH_FORMAT:
            previousDate = selectedDate.getLastMonth() ?? ""
            nextDate = selectedDate.getNextMonth() ?? ""
        default:
            previousDate = selectedDate.getLastYear() ?? ""
            nextDate = selectedDate.getNextYear() ?? ""
        }
        
        let currentDatePosts = reports.filter { report in
            let postDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(report.createdAt/1000)))
            return postDate == selectedDate
        }

        let previousDatePosts = reports.filter { report in
            let postDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(report.createdAt/1000)))
            return postDate == previousDate
        }
        
        let nextDatePosts = reports.filter { report in
            let postDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(report.createdAt/1000)))
            return postDate == nextDate
        }
        let data: [BarChartDataEntry] = [
            BarChartDataEntry(x: 0, y: Double(previousDatePosts.count)),
            BarChartDataEntry(x: 1, y: Double(currentDatePosts.count)),
            BarChartDataEntry(x: 2, y: Double(nextDatePosts.count)),
        ]
        chartYLabel = [previousDate, selectedDate, nextDate]
        return data
    }
}
