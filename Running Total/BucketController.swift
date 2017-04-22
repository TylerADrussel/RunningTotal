//
//  BucketController.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import Foundation
import CoreData

class BucketController {
    
    static let shared = BucketController()
    
    var buckets: [Bucket] {
        let request: NSFetchRequest<Bucket> = Bucket.fetchRequest()
        
        do {
            return try CoreDataStack.context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func create(bucket bucketTitle: String, timestamp: Date = Date(), bucketColor: String) {
        let _ = Bucket(bucketTitle: bucketTitle, bucketColor: bucketColor)
        saveToPersistentStorage()
    }
    
    func delete(bucket: Bucket) {
        bucket.managedObjectContext?.delete(bucket)
        saveToPersistentStorage()
    }
        
    func total(bucket: Bucket) -> Float {
        
        var total: Float = 0
        
        for entry in bucket.entries! {
            if let entry = entry as? Entry {
                total += entry.amount
            }
        }
        return total
    }
    
    // MARK: Private
    
    private func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Context. Items Not Saved.")
        }
    }
}
