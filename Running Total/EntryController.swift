//
//  EntryController.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import Foundation

class entrycontroller {
    
    static func create(entry title: String, amount: Float, timestamp: Date = Date(), bucket: Bucket) {
    
    let entry = Entry(title: title, amount: amount)
    BucketController.shared.update(entryToBucket: entry, bucket: bucket)
    }
}

