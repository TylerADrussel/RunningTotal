//
//  Bucket.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import Foundation
import CoreData

extension Bucket {
    
    static let bucketTitleKey = "bucketTitle"
    static let bucketTimestampKey = "bucketTimestamp"
    static let bucketColorKey = "bucketColor"
    
    convenience init(bucketTitle: String, bucketTimestamp: Date = Date(),bucketColor: String, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.bucketTitle = bucketTitle
        self.bucketTimestamp = bucketTimestamp as NSDate
        self.bucketColor = bucketColor

    }
}


