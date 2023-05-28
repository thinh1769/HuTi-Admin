//
//  Numeric+Ext.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 01/05/2023.
//

import Foundation

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
}

extension Int {
    func parseDateTime() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm dd/MM/yyyy"

        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func parseDateBaseOn(formatString: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self/1000))
        let dateFormatter = DateFormatter.instance(formatString: formatString)

        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
