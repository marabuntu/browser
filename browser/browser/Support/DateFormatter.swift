//
//  DateFormatter.swift
//  browser
//
//  Created by Edgar Borovik on 28/05/2023.
//

import Foundation

enum Formatter {
    static var fullDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
}
