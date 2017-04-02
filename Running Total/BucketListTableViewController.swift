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
        
        cell.backgroundColor = UIColor.clear
        
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion: nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
//        cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath)
        let bucket = BucketController.shared.buckets[indexPath.row]
//        cell.textLabel?.text = bucket.bucketTitle
        if bucket.entries?.count == 0 {
//            cell.detailTextLabel?.text = "No entries yet"
        } else {
            let entryCount = bucket.entries!.count
            let total = BucketController.shared.total(bucket: bucket)
//            cell.detailTextLabel?.text = "\(entryCount) entries: \(total)"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAt indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[(indexPath as NSIndexPath).row]
    }
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: NSIndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath as IndexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
