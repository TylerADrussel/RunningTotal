//
//  Bucket.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import Foundation

class Bucket: Equatable {
    
    static let bucketTitleKey = "bucketTitle"
    static let bucketTimestampKey = "bucketTimestamp"
    
    init(bucketTitle: String, bucketTimestamp: Date = Date(), entries: [Entry] = []) {
        self.bucketTitle = bucketTitle
        self.bucketTimestamp = bucketTimestamp
        self.entries = entries
    }
    
    var bucketTitle: String
    var bucketTimestamp: Date
    var entries: [Entry]
    
    var total: Float {
        let flatArray = entries.flatMap{$0}
        let total = flatArray.reduce(0) {$0 + $1.amount}
        print(total)
        return total
    }
}

func ==(lhs: Bucket, rhs: Bucket) -> Bool {
    return lhs.bucketTitle == rhs.bucketTitle && lhs.bucketTimestamp == rhs.bucketTimestamp
}

