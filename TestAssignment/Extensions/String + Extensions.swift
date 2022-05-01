//
//  String + Extensions.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import Foundation

extension String {

    var isoDateConverter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        } else {
            return "not a valid date"
        }
    }
}
