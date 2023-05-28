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
}
