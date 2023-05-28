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
    var formatString = ""
    var chartYLabel = [String]()
    
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

        let yesterday = selectedDate.getYesterday()

        let currentDayPosts = posts.filter { post in
            let postDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(post.createdAt/1000)))
            return postDate == selectedDate
        }

        let previousDayPosts = posts.filter { post in
            let postDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(post.createdAt/1000)))
            guard let yesterday = yesterday else { return false }
            return postDate == yesterday
        }
        let data: [BarChartDataEntry] = [
            BarChartDataEntry(x: 0, y: Double(previousDayPosts.count)),
            BarChartDataEntry(x: 1, y: Double(currentDayPosts.count))]
        chartYLabel = [yesterday ?? "", selectedDate]
        return data
    }
}
