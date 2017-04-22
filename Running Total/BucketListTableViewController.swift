//
//  BucketListTableViewController.swift
//  Running Total
//
//  Created by Tyler Drussel on 4/2/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

protocol BucketCellDelegate: class {
    func addButtonTapped(in cell: BucketCell)
    func editButtonTapped(in cell: BucketCell)
    func cancelButtonTapped(in cell: BucketCell)
    func deleteItemButtonTapped(in cell: BucketCell)
    func deleteAllEntriesButtonTapped(in cell: BucketCell)
}

class BucketListTableViewController: UITableViewController, BucketCellDelegate {
    
    @IBOutlet weak var newBucketTitleTextField: UITextField!

    @IBAction func createNewBucketTapped(_ sender: Any) {
        
        guard let bucketName = newBucketTitleTextField.text, !bucketName.isEmpty else { return }
        let colorsArray = ["blue", "brown", "cyan", "green", "magenta", "orange", "purple", "red", "yellow"]
        let bucketColorUIColor = Int(arc4random_uniform(UInt32(colorsArray.count)))
        let bucketColorString = colorsArray[bucketColorUIColor]
        BucketController.shared.create(bucket: bucketName, bucketColor: bucketColorString)
        newBucketTitleTextField.text = ""
//        tableView.beginUpdates()
//        let indexPath = NSIndexPath(row: BucketController.shared.buckets.count, section: 0)
//        tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
//        tableView.endUpdates()
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
        tableView.tableFooterView = UIView()
    }
    
    // MARK: BucketCellDelegate Methods
    
    func addButtonTapped(in cell: BucketCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if cell.newEntryTitleTextField.text == "" || cell.newEntryAmountTextField.text == "" {
            return
        } else {
            let bucket = BucketController.shared.buckets[indexPath.row]
            guard let entryTitle = cell.newEntryTitleTextField.text,
                let entryAmountString = cell.newEntryAmountTextField.text else { return }
            
            let itemAmountFloat = Float(entryAmountString) ?? 0
            
            EntryController.shared.create(entry: entryTitle, amount: itemAmountFloat, bucket: bucket)
            cell.newEntryTitleTextField.text = ""
            cell.newEntryAmountTextField.text = ""
            cell.updateViews(withDeleteButton: false)
            cellHeights[indexPath.row] = cell.totalOpenHeight
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func editButtonTapped(in cell: BucketCell) {
        guard let _ = tableView.indexPath(for: cell) else { return }
    }
    
    func deleteItemButtonTapped(in cell: BucketCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        cell.updateViews(withDeleteButton: true)
        cellHeights[indexPath.row] = cell.totalOpenHeight
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func deleteAllEntriesButtonTapped(in cell: BucketCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let bucket = BucketController.shared.buckets[indexPath.row]
        EntryController.shared.removeAll(bucket: bucket)
        cell.updateViews(withDeleteButton: true)
        cellHeights[indexPath.row] = cell.totalOpenHeight
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func cancelButtonTapped(in cell: BucketCell) {
        guard let _ = tableView.indexPath(for: cell) else { return }
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
        let bucketDate = dateFormatter.string(from: bucket.bucketTimestamp! as Date)
        
        bucketCell.bucketDate = bucketDate
        bucketCell.bucket = bucket
        bucketCell.bucketCellDelegate = self
        return bucketCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    // MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? BucketCell else { return }
        var duration = 0.0
    // Open cell
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cellHeights[indexPath.row] = cell.totalOpenHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {
    // Close cell
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
