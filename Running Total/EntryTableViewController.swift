//
//  EntryTableViewController.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {
    
    
    @IBAction func createNewItemTapped(_ sender: Any) {
        guard let bucket = bucket,
            let entryTitle = itemNameField.text,
            let entryAmountString = itemAmountField.text else { return }
        
        let itemAmountFloat = Float(entryAmountString) ?? 0
        
        entrycontroller.create(entry: entryTitle, amount: itemAmountFloat, timestamp: Date(), bucket: bucket)
        itemNameField.text = ""
        itemAmountField.text = ""
        tableView.reloadData()
    }
    
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var itemAmountField: UITextField!
    @IBOutlet weak var runningTotalAmountLabel: UILabel!
    
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
        var entryAmountString = ""
        if let entryAmountFloat = entry?.amount {
            entryAmountString = "\(entryAmountFloat)"
        }
        cell.detailTextLabel?.text = entryAmountString
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
