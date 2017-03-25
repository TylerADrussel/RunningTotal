//
//  EntryTableViewController.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = bucket?.entries.count, count != 0 else { return 0 }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = bucket?.entries[indexPath.row]
        cell.textLabel?.text = entry?.title
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    var bucket: Bucket? {
        didSet {
            if isViewLoaded { tableView.reloadData() }
        }
    }
}
