//
//  EntryTableViewController.swift
//  Running Total
//
//  Created by Tyler Drussel on 3/25/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBAction func createNewItemTapped(_ sender: Any) {
        guard let bucket = bucket,
            let entryTitle = itemNameField.text,
            let entryAmountString = itemAmountField.text else { return }
        
        let itemAmountFloat = Float(entryAmountString) ?? 0
        
        EntryController.shared.create(entry: entryTitle, amount: itemAmountFloat, bucket: bucket)
        itemNameField.text = ""
        itemAmountField.text = ""
reloadRunningTotalLabel()
        tableView.reloadData()
    }
    
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var itemAmountField: UITextField!
    @IBOutlet weak var runningTotalAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        title = bucket?.bucketTitle
        self.reloadRunningTotalLabel()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == itemAmountField {
            let inverseSet = NSCharacterSet(charactersIn: ".0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = bucket?.entries?.count, count != 0 else { return 0 }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = bucket?.entries?[indexPath.row] as? Entry
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
            // TODO: unwrap entries and cast as Entry
            EntryController.shared.remove(entry: bucket?.entries![indexPath.row] as! Entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        self.reloadRunningTotalLabel()
    }
    
    var bucket: Bucket? {
        didSet {
            if isViewLoaded { tableView.reloadData() }
        }
    }
    
    func reloadRunningTotalLabel() {
        if bucket?.entries?.count == 0 {
            runningTotalAmountLabel.text = "Please enter an item."
        } else {
            if let bucket = bucket {
                let total = BucketController.shared.total(bucket: bucket)
                runningTotalAmountLabel.text = "Running Total: \(total)"
            }
        }
    }
}


