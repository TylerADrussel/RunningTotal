//
//  BucketTableViewController.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

class BucketTableViewController: UITableViewController {
    
    @IBOutlet weak var bucketTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func createNewBucketTapped(_ sender: Any) {
    
        guard let bucketName = bucketTitleTextField.text, !bucketName.isEmpty else { return }
        BucketController.shared.create(bucket: bucketName)
        bucketTitleTextField.text = ""
        tableView.reloadData()
        
//        tableView.selectRow(at: <#T##IndexPath?#>, animated: <#T##Bool#>, scrollPosition: <#T##UITableViewScrollPosition#>)
//        performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BucketController.shared.buckets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketCell", for: indexPath)
        let bucket = BucketController.shared.buckets[indexPath.row]
        cell.textLabel?.text = bucket.bucketTitle
        if bucket.entries?.count == 0 {
            cell.detailTextLabel?.text = "No entries yet"
        } else {
            let entryCount = bucket.entries!.count
            let total = BucketController.shared.total(bucket: bucket)
            cell.detailTextLabel?.text = "\(entryCount) entries: \(total)"
        }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            BucketController.shared.delete(bucket: BucketController.shared.buckets[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEntries" {
            
            if let detailViewController = segue.destination as? EntryTableViewController, let selectedRow = tableView.indexPathForSelectedRow?.row {
                
                let bucket = BucketController.shared.buckets[selectedRow]
                detailViewController.bucket = bucket
            }
        }
    }
}
