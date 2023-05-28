//
//  Date+Extensions.swift
//  browser
//
//  Created by Edgar Borovik on 28/05/2023.
//

import Foundation

extension Date {
    func isInSameDay(with date: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date, to: self)
        return diff.day == 0
    }
}
