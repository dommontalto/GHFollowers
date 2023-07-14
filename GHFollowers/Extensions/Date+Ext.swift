//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Dom Montalto on 14/7/2023.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
