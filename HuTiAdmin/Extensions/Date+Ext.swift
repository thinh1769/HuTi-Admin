//
//  Date+Ext.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 28/05/2023.
//

import Foundation

extension Date {
    func getTodayDate(day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }

    func getMaximumDate() -> Date {
        let date = Date()
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        if let maximumDate = calendar.date(from: components) {
            return maximumDate
        } else {
            return Date()
        }
    }
    
    func getMinimumDate() -> Date {
        let calendar = Calendar.current
        let components = DateComponents(year: 2000, month: 1, day: 1)
        if let minimum = calendar.date(from: components) {
            return minimum
        } else {
            return Date()
        }
    }
}

extension DateFormatter {
    static func instance(formatString: String) -> DateFormatter {
        let format = DateFormatter()
        format.dateFormat = formatString
        return format
    }
}
