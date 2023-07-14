//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Dom Montalto on 14/7/2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
