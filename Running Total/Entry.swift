//
//  Entry.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import Foundation

class Entry: Equatable {
    
    static let titleKey = "title"
    static let amountKey = "amount"
    static let timestampKey = "timestamp"
    
    init(title: String, amount: Float, timestamp: Date = Date()) {
        self.title = title
        self.amount = amount
        self.timestamp = timestamp
    }
    
    var title: String
    var amount: Float
    var timestamp: Date
}

func ==(lhs: Entry, rhs: Entry) -> Bool {
    return lhs.title == rhs.title && lhs.amount == rhs.amount && lhs.timestamp == rhs.timestamp
}
