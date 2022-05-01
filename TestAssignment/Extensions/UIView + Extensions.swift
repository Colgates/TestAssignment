//
//  UIView + Extensions.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
