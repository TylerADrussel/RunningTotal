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
        createCellHeightsArray() // Folding Cell
//        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!) // Folding Cell
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath)
//        let bucket = BucketController.shared.buckets[indexPath.row]
//        cell.textLabel?.text = bucket.bucketTitle
//        if bucket.entries?.count == 0 {
//            cell.detailTextLabel?.text = "No entries yet"
//        } else {
//            let entryCount = bucket.entries!.count
//            let total = BucketController.shared.total(bucket: bucket)
//            cell.detailTextLabel?.text = "\(entryCount) entries: \(total)"
//        }
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
    
    // MARK: Folding Cell
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
//    var cellHeights = [CGFloat]()
    
        // MARK: Configure
    
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
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
        cell.number = indexPath.row
    }
    
    // This is stated twice, once in the paste in, and this one is on the main table view controller
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cellHeights[(indexPath as NSIndexPath).row]
//    }
    
    // add table view delegate part here
    // this probably needs to be split out into 2 different table view controllers

    
    
    fileprivate struct C {
        struct CellHeight{
            static let close: CGFloat = 179
            static let open: CGFloat = 488
        }
    }
    
    var cellHeights = (0..<BucketController.shared.buckets.count).map { _ in C.CellHeight.close }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
        } else { // close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if case let foldingCell as FoldingCell = cell {
        if cellHeights[indexPath.row] == C.CellHeight.close {
            foldingCell.selectedAnimation(false, animated: false, completion: nil)
        } else {
            foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
}

    //MARK: Extension

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
