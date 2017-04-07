//
//  BucketListTableViewController.swift
//  Running Total
//
//  Created by Tyler Drussel on 4/2/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

protocol AddItemFromBucketCellDelegate {
    func addButtonTapped(in cell: BucketCell)
}

class BucketListTableViewController: UITableViewController, AddItemFromBucketCellDelegate {
    
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
        
        // TODO: Add the new item to the stack view
        
//        cell.entryStackView.addArrangedSubview( as! UIView)
        
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
        bucketCell.bucketTitleLabelClosedCell.text = bucket.bucketTitle
        bucketCell.bucketTitleLabelOpenCell.text = bucket.bucketTitle
        bucketCell.bucketDatetimeLabelClosedCell.text = "\(bucketDate)"
        bucketCell.bucketClosedIndex.text = "\(BucketController.shared.buckets.index(of: bucket))"
        bucketCell.bucketOpenIndex.text = "\(BucketController.shared.buckets.index(of: bucket))"
        if bucket.entries?.count == 0 {
            bucketCell.bucketTotalLabelClosedCell.text = "0"
            bucketCell.bucketItemCountLabelClosedCell.text = "None"
            bucketCell.bucketTotalLabelOpenCell.text = "Please add an item"
        } else {
            let entryCount = bucket.entries!.count
            let entriesArray = bucket.entries!
            let total = BucketController.shared.total(bucket: bucket)
            bucketCell.bucketTotalLabelClosedCell.text = "\(total)"
            bucketCell.bucketItemCountLabelClosedCell.text = "\(entryCount)"
            bucketCell.bucketTotalLabelOpenCell.text = "Running Total: \(total)"

            for entry in entriesArray {
                bucketCell.entryStackView.addArrangedSubview(entry as! UIView)
            }
        }
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
