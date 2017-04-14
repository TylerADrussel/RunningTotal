//
//  EntryController.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func create(entry title: String, amount: Float, bucket: Bucket) {
    
        let _ = Entry(title: title, amount: amount, bucket: bucket)
        saveToPersistentStorage()
    }

    private static let EntriesKey = "entries"
    
    static let shared = EntryController()
    
    func remove(entry: Entry) {
        
        entry.managedObjectContext?.delete(entry)
        saveToPersistentStorage()
    }
    
    func removeAll(bucket: Bucket) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        fetch.predicate = NSPredicate(format: "bucket = %@", bucket)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            _ = try CoreDataStack.context.execute(request)
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
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
