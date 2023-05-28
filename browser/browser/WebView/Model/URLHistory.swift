//
//  URLHistory.swift
//  browser
//
//  Created by Edgar Borovik on 28/05/2023.
//

import Foundation

struct URLHistory {
    static var empty = Self.init(items: [])
    private var items: [URLHistoryItem]
    var itemsSeparatedByDates: [[URLHistoryItem]] {
        guard !items.isEmpty else { return [] }
        var result: [[URLHistoryItem]] = [[]]
        var currentDay = items.first!.date
        var buf = [URLHistoryItem]()

        for item in items.reversed() {
            if item.date.isInSameDay(with: currentDay) {
                if buf.first(where: { $0.title == item.title }) == nil {
                    buf.append(item)
                }
            } else {
                result.append(buf)
                buf = [item]
                currentDay = item.date
            }
        }
        if !buf.isEmpty {
            result.append(buf)
        }
        return result
    }

    private init(items: [URLHistoryItem]) {
        self.items = items
    }

    mutating func add(item: URLHistoryItem) {
        items.append(item)
    }
}

// MARK: Codable
extension URLHistory: Codable {
    enum CodingKeys: CodingKey {
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([URLHistoryItem].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
    }
}

// MARK: RawRepresentable
extension URLHistory: RawRepresentable {
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(URLHistory.self, from: data)
        else {
            return nil
        }
        self = result
    }

    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return result
    }
}
