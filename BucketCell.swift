//
//  BucketCell.swift
//  Running Total
//
//  Created by Tyler Drussel on 4/2/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

class BucketCell: FoldingCell, UITextFieldDelegate {
    
    // MARK: Cell Indexes
    @IBOutlet weak var bucketClosedIndex: UILabel!
    @IBOutlet weak var bucketOpenIndex: UILabel!
    
    // MARK: Closed Cell Outlets
    @IBOutlet weak var bucketTitleLabelClosedCell: UILabel!
    @IBOutlet weak var bucketTotalLabelClosedCell: UILabel!
    @IBOutlet weak var bucketDatetimeLabelClosedCell: UILabel!
    @IBOutlet weak var bucketItemCountLabelClosedCell: UILabel!
    
    // Mark: Open Cell Outlets
    @IBOutlet weak var bucketTitleLabelOpenCell: UILabel!
    @IBOutlet weak var bucketTotalLabelOpenCell: UILabel!
    @IBOutlet weak var newEntryTitleTextField: UITextField!
    @IBOutlet weak var newEntryAmountTextField: UITextField!
    @IBOutlet weak var entryStackViewEmbeddedView: UIView!
    @IBOutlet weak var entryStackView: UIStackView!
    
    var editListButton: UIButton!
//    var deleteAllEntriesButton: UIButton!
    var cancelEditListButton: UIButton!
    var deleteEntryButtons: [UIButton] = []
    
    @IBAction func createNewEntryTapped(_ sender: Any) {
        bucketCellDelegate?.addButtonTapped(in: self)
    }
    
    func editListButtonTapped(_ sender: Any) {
        updateViews(withDeleteButton: true)
        bucketCellDelegate?.editButtonTapped(in: self)
    }
    
    func deleteItemButtonTapped(_ sender: Any) {
        updateViews(withDeleteButton: true)
    }
    
    func deleteAllEntriesButtonTapped(_ sender: Any) {
        bucketCellDelegate?.deleteAllEntriesButtonTapped(in: self)
        updateViews(withDeleteButton: false)
    }
    
    func cancelEditListButtonTapped(_ sender: Any) {
        updateViews(withDeleteButton: false)
    }
    
    weak var bucketCellDelegate: BucketCellDelegate?
    
    var bucket: Bucket? {
        didSet {
            updateViews(withDeleteButton: false)
        }
    }
    
    var bucketDate: String?

    var bucketIndex: Int = 0 {
        didSet {
            bucketClosedIndex.text = String(bucketIndex)
            bucketOpenIndex.text = String(bucketIndex)
        }
    }
    
    func updateViews(withDeleteButton: Bool) {
        guard let bucket = self.bucket else { return }
        self.newEntryTitleTextField.delegate = self
        self.newEntryAmountTextField.delegate = self        
        self.bucketTitleLabelClosedCell.text = bucket.bucketTitle
        self.bucketTitleLabelOpenCell.text = bucket.bucketTitle
        self.bucketDatetimeLabelClosedCell.text = "\(bucketDate ?? "No date")"
        self.bucketClosedIndex.text = "\(BucketController.shared.buckets.index(of: bucket))"
        self.bucketOpenIndex.text = "\(BucketController.shared.buckets.index(of: bucket))"
        
        if bucket.entries?.count == 0 {
            self.bucketTotalLabelClosedCell.text = "0"
            self.bucketItemCountLabelClosedCell.text = "None"
            self.bucketTotalLabelOpenCell.text = "Please add an item"
        } else {

            let removeViews = entryStackView.arrangedSubviews
            for view in removeViews {
                view.removeFromSuperview()
            }

            let entryCount = bucket.entries!.count
            let entriesSet = bucket.entries!
            let total = BucketController.shared.total(bucket: bucket)
            self.bucketTotalLabelClosedCell.text = "\(total)"
            self.bucketItemCountLabelClosedCell.text = "\(entryCount)"
            self.bucketTotalLabelOpenCell.text = "Running Total: \(total)"
            
            let entryStackViewTitleStackView = UIStackView()
            let entryStackViewTitleLabel = UILabel()
            let entryStackViewAmountLabel = UILabel()
            entryStackViewTitleLabel.text = "Item name"
            entryStackViewAmountLabel.text = "Amount"
            entryStackViewTitleStackView.addArrangedSubview(entryStackViewTitleLabel)
            entryStackViewTitleStackView.addArrangedSubview(entryStackViewAmountLabel)
            
            let labelAmountHeaderWidthConstraint = NSLayoutConstraint(item: entryStackViewAmountLabel, attribute: .width, relatedBy: .equal, toItem: entryStackViewTitleStackView, attribute: .width, multiplier: 1/6, constant: 0)
            entryStackViewTitleStackView.addConstraint(labelAmountHeaderWidthConstraint)
            
            self.entryStackView.addArrangedSubview(entryStackViewTitleStackView)
            
            var entriesArray: [Entry] = []
            
            for entry in entriesSet {
                guard let entry = entry as? Entry else { return }
                entriesArray.append(entry)
            }
            
            for entry in entriesArray {
                
                let stackView = UIStackView()
                let labelTitle = UILabel()
                let labelAmount = UILabel()

                labelTitle.text = entry.title
                labelTitle.adjustsFontSizeToFitWidth = true
                labelAmount.adjustsFontSizeToFitWidth = true
                labelAmount.text = "\(entry.amount)"
                
                stackView.addArrangedSubview(labelTitle)
                stackView.addArrangedSubview(labelAmount)
                labelAmount.translatesAutoresizingMaskIntoConstraints = false
                let labelAmountWidthConstraint = NSLayoutConstraint(item: labelAmount, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1/6, constant: 0)
                stackView.addConstraint(labelAmountWidthConstraint)
                
                stackView.axis = .horizontal
                entryStackView.addArrangedSubview(stackView)
            }
            
            if withDeleteButton == true {
                
                self.cancelEditListButton = UIButton()
                self.cancelEditListButton.setTitle("Cancel", for: .normal)
                self.cancelEditListButton.backgroundColor = UIColor.darkGray
                self.cancelEditListButton.addTarget(self, action: #selector(cancelEditListButtonTapped(_:)), for: .touchUpInside)
                entryStackView.addArrangedSubview(self.cancelEditListButton)
                
                var deleteAllEntriesButton: UIButton

                deleteAllEntriesButton = UIButton()
                deleteAllEntriesButton.setTitle("Delete All", for: .normal)
                deleteAllEntriesButton.backgroundColor = UIColor.red
                deleteAllEntriesButton.addTarget(self, action: #selector(deleteAllEntriesButtonTapped(_:)), for: .touchUpInside)
                entryStackView.addArrangedSubview(deleteAllEntriesButton)
                
            } else {
                
                self.editListButton = UIButton()
                self.editListButton.setTitle("Edit list", for: .normal)
                self.editListButton.backgroundColor = UIColor.darkGray
                entryStackView.addArrangedSubview(self.editListButton)
                editListButton.addTarget(self, action: #selector(editListButtonTapped(_:)), for: .touchUpInside)

            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == newEntryAmountTextField {
            let inverseSet = NSCharacterSet(charactersIn: ".0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered
        } else if textField == newEntryTitleTextField {
            if string == "" {
                return true
            }
            let maxLength = 30
            let currentLength = newEntryTitleTextField.text?.characters.count ?? 0
            if currentLength > maxLength {
                return false
            }
        }
        return true
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        let durations = [0.26, 0.2, 0.2] // Timing animation for each view
        return durations[itemIndex]
    }
}

// MARK: Actions
extension BucketCell {
    
    @IBAction func buttonHandler(_ sender: AnyObject) {
        print("tap")
    }
}

