//
//  Entry.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    static let titleKey = "title"
    static let amountKey = "amount"
    static let timestampKey = "timestamp"
    
    convenience init(title: String, amount: Float, timestamp: Date = Date(), bucket: Bucket, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.title = title
        self.amount = amount
        self.timestamp = timestamp as NSDate?
        self.bucket = bucket
    }
}
