//
//  BucketController.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import Foundation

class BucketController {
    
    static let shared = BucketController()
    
    var buckets = [Bucket]()

    func create(bucket bucketTitle: String, timestamp: Date = Date()) {
        let bucket = Bucket(bucketTitle: bucketTitle)
        buckets.append(bucket)
    }
    
    func update(bucket: Bucket, bucketTitle: String) {
        bucket.bucketTitle = bucketTitle
    }
    
    func delete(bucket: Bucket) {
        guard let index = buckets.index(of: bucket) else { return }
        buckets.remove(at: index)
    }
    
//    func create(entry entry: Entry, bucket: Bucket) {
//        bucket.entries.append(entry)
//    }
    
    func update(entryToBucket entry: Entry, bucket: Bucket) {
        bucket.entries.append(entry)
    }
    
    func delete(entryFromBucket entry: Entry, bucket: Bucket) {
        guard let index = bucket.entries.index(of: entry) else { return }
        bucket.entries.remove(at: index)
    }
}
