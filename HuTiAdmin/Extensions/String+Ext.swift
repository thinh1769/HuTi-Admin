//
//  String+Ext.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 28/05/2023.
//

import Foundation

extension String {
    func getYesterday() -> String? {
        let dateFormatter = DateFormatter.instance(formatString: CommonConstants.DATE_FORMAT)
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: date) {
                return dateFormatter.string(from: yesterday)
            }
        }
        return nil
    }
    
    func getLastMonth() -> String? {
        let dateFormatter = DateFormatter.instance(formatString: CommonConstants.MONTH_FORMAT)
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            if let lastMonth = calendar.date(byAdding: .month, value: -1, to: date) {
                return dateFormatter.string(from: lastMonth)
            }
        }
        return nil
    }
    
    func getLastYear() -> String? {
        let dateFormatter = DateFormatter.instance(formatString: CommonConstants.YEAR_FORMAT)
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            if let lastYear = calendar.date(byAdding: .year, value: -1, to: date) {
                return dateFormatter.string(from: lastYear)
            }
        }
        return nil
    }
    
    func getTomorrow() -> String? {
        let dateFormatter = DateFormatter.instance(formatString: CommonConstants.DATE_FORMAT)
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            if let yesterday = calendar.date(byAdding: .day, value: +1, to: date) {
                return dateFormatter.string(from: yesterday)
            }
        }
        return nil
    }
    
    func getNextMonth() -> String? {
        let dateFormatter = DateFormatter.instance(formatString: CommonConstants.MONTH_FORMAT)
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            if let lastMonth = calendar.date(byAdding: .month, value: +1, to: date) {
                return dateFormatter.string(from: lastMonth)
            }
        }
        return nil
    }
    
    func getNextYear() -> String? {
        let dateFormatter = DateFormatter.instance(formatString: CommonConstants.YEAR_FORMAT)
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            if let lastYear = calendar.date(byAdding: .year, value: +1, to: date) {
                return dateFormatter.string(from: lastYear)
            }
        }
        return nil
    }
}
