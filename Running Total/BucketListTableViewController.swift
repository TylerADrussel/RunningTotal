//
//  BucketListTableViewController.swift
//  Running Total
//
//  Created by Tyler Drussel on 4/2/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

class BucketListTableViewController: UITableViewController {
    
    @IBOutlet weak var newBucketTitleTextField: UITextField!

    
    @IBAction func createNewBucketTapped(_ sender: Any) {
        
        guard let bucketName = newBucketTitleTextField.text, !bucketName.isEmpty else { return }
        BucketController.shared.create(bucket: bucketName)
        newBucketTitleTextField.text = ""
        tableView.reloadData()
    }    
    
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 75
            static let open: CGFloat = 500
        }
    }
    
    let kCloseCellHeight: CGFloat = 75
    let kOpenCellHeight: CGFloat = 500
    let kRowsCount = BucketController.shared.buckets.count
    
    var cellHeights = (0..<BucketController.shared.buckets.count).map { _ in C.CellHeight.close }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        createCellHeightsArray()
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as BucketCell = cell else {
            return
        }
        
        cell.backgroundColor = UIColor.darkGray
        
        if cellHeights[(indexPath as IndexPath).row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion: nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        cell.bucketIndex = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bucketCell: BucketCell = self.tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! BucketCell
        
        let bucket = BucketController.shared.buckets[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let bucketDate = dateFormatter.string(from: bucket.bucketTimestamp as! Date)
        bucketCell.bucketTitleLabelClosedCell.text = bucket.bucketTitle
        bucketCell.bucketDatetimeLabelClosedCell.text = "\(bucketDate)"
        bucketCell.bucketClosedIndex.text = "\(BucketController.shared.buckets.index(of: bucket))"
        bucketCell.bucketOpenIndex.text = "\(BucketController.shared.buckets.index(of: bucket))"
        if bucket.entries?.count == 0 {
            bucketCell.bucketTotalLabelClosedCell.text = "0"
            bucketCell.bucketItemCountLabelClosedCell.text = "None"
        } else {
            let entryCount = bucket.entries!.count
            let total = BucketController.shared.total(bucket: bucket)
            bucketCell.bucketTotalLabelClosedCell.text = "\(total)"
            bucketCell.bucketItemCountLabelClosedCell.text = "\(entryCount)"
        }
        
        return bucketCell
    }
    
    func tableView(tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[(indexPath as IndexPath).row]
    }
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: IndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath as IndexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[(indexPath as IndexPath).row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as IndexPath).row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as IndexPath).row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        
        if case let cell as FoldingCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
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
