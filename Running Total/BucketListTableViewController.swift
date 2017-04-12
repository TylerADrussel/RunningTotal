//
//  BucketListTableViewController.swift
//  Running Total
//
//  Created by Tyler Drussel on 4/2/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

protocol AddItemFromBucketCellDelegate: class {
    func addButtonTapped(in cell: BucketCell)
}

protocol EditItemListInBucketCellDelegate: class {
    func editButtonTapped(in cell: BucketCell)
}

protocol DeleteItemInBucketCellDelegate: class {
    func deleteItemButtonTapped(in cell: BucketCell)
}

protocol DeleteAllEntriesInBucketCellDelegate: class {
    func deleteAllEntriesButtonTapped(in cell: BucketCell)
}

protocol CancelEditInBucketCellDelegate: class {
    func cancelButtonTapped(in cell: BucketCell)
}

class BucketListTableViewController: UITableViewController, AddItemFromBucketCellDelegate, DeleteAllEntriesInBucketCellDelegate {
    
    @IBOutlet weak var newBucketTitleTextField: UITextField!

    @IBAction func createNewBucketTapped(_ sender: Any) {
        
        guard let bucketName = newBucketTitleTextField.text, !bucketName.isEmpty else { return }
        BucketController.shared.create(bucket: bucketName)
        newBucketTitleTextField.text = ""
        tableView.reloadData()
    }    
    
    let kCloseCellHeight: CGFloat = 90
    let kOpenCellHeight: CGFloat = 520
    let kRowsCount = BucketController.shared.buckets.count
    var cellHeights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        createCellHeightsArray()
    }
    
    // MARK: AddItemFromBucketCellDelegate Methods
    
    func addButtonTapped(in cell: BucketCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let bucket = BucketController.shared.buckets[indexPath.row]
        guard let entryTitle = cell.newEntryTitleTextField.text,
            let entryAmountString = cell.newEntryAmountTextField.text else { return }
        
        let itemAmountFloat = Float(entryAmountString) ?? 0
        
        EntryController.shared.create(entry: entryTitle, amount: itemAmountFloat, bucket: bucket)
        cell.newEntryTitleTextField.text = ""
        cell.newEntryAmountTextField.text = ""
        tableView.reloadData()
    }
    
    // MARK: EditItemListInBucketCellDelegate Methods
    
    func editButtonTapped(in cell: BucketCell) {
        guard let _ = tableView.indexPath(for: cell) else { return }
        tableView.reloadData()
    }
    
    // MARK: DeleteItemInBucketCellDelegate Methods
    
    func deleteItemButtonTapped(in cell: BucketCell) {
        
    }
    
    // MARK: DeleteAllEntriesInBuckerCellDelegate Methods
    
    func deleteAllEntriesButtonTapped(in cell: BucketCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let bucket = BucketController.shared.buckets[indexPath.row]
        let entriesSet = bucket.entries!
        for entry in entriesSet {
            guard let entry = entry as? Entry else { return }
            EntryController.shared.remove(entry: entry)
        }
        tableView.reloadData()
    }
    
    // MARK: CancelEditInBuckerCellDelegate Methods
    
    func cancelButtonTapped(in cell: BucketCell) {
        guard let _ = tableView.indexPath(for: cell) else { return }
        tableView.reloadData()
    }
    
    // MARK: Configure
    
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    // MARK: TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BucketController.shared.buckets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bucketCell: BucketCell = self.tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! BucketCell
        
        let bucket = BucketController.shared.buckets[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let bucketDate = dateFormatter.string(from: bucket.bucketTimestamp as! Date)
        
        bucketCell.bucketDate = bucketDate
        bucketCell.bucket = bucket
        bucketCell.addItemDelegate = self
        bucketCell.deleteAllEntriesDelegate = self
        return bucketCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    // MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath as IndexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5            
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if case let cell as FoldingCell = cell {
            if cellHeights[indexPath.row] == kCloseCellHeight {
                cell.selectedAnimation(false, animated: false, completion: nil)
            } else {
                cell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
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
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
