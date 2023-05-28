//
//  URLHistoryItem.swift
//  browser
//
//  Created by Edgar Borovik on 28/05/2023.
//

import Foundation

struct URLHistoryItem: Codable, Hashable {
    let title: String
    let dateStamp: Double
    var date: Date {
        .init(timeIntervalSince1970: dateStamp)
    }

    init(title: String, date: Date) {
        self.title = title
        self.dateStamp = date.timeIntervalSince1970
    }
}
