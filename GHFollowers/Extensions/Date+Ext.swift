//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Dom Montalto on 14/7/2023.
//

import Foundation

extension Date {
    
    // Old way
    
//    func convertToMonthYearFormat() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//        return dateFormatter.string(from: self)
//    }
    
    // New way
    
    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month(.wide).year())
    }
}
