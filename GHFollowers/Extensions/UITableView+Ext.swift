//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Dom Montalto on 18/7/2023.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
