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
    @IBOutlet weak var bucketCellColorLabaelClosedCell: UIView!
    
    // Mark: Open Cell Outlets
    @IBOutlet weak var bucketTitleLabelOpenCell: UILabel!
    @IBOutlet weak var bucketTotalLabelOpenCell: UILabel!
    @IBOutlet weak var bucketCellColorLabelOpenCell: UIView!
    @IBOutlet weak var newEntryTitleTextField: UITextField!
    @IBOutlet weak var newEntryAmountTextField: UITextField!
    @IBOutlet weak var entryStackViewEmbeddedView: UIView!
    @IBOutlet weak var entryStackView: UIStackView!
    @IBOutlet weak var bucketCellOpenHeight: NSLayoutConstraint!
    
    var editListButton: UIButton!
    var cancelEditListButton: UIButton!
    var deleteEntryButtons: [UIButton] = []
    
    @IBAction func createNewEntryTapped(_ sender: Any) {
        bucketCellDelegate?.addButtonTapped(in: self)
    }
    
    func editListButtonTapped(_ sender: Any) {
        updateViews(withDeleteButton: true)
    }
    
    func deleteItemButtonTapped(_ sender: Any) {
        print((sender as AnyObject).tag)
        guard let tempTag = (sender as AnyObject).tag else { return }
        let entry = bucket?.entries?.object(at: tempTag)
        EntryController.shared.remove(entry: entry as! Entry)
        bucketCellDelegate?.deleteItemButtonTapped(in: self)
    }
    
    func deleteAllEntriesButtonTapped(_ sender: Any) {
        bucketCellDelegate?.deleteAllEntriesButtonTapped(in: self)
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
    
    var totalOpenHeight: CGFloat {
        return openHeight + 16
    }
    
    var openHeight: CGFloat {
        let countOfViews = entryStackView.arrangedSubviews.count
        let staticItemsHeight: CGFloat = 160
        var stackViewHeight: CGFloat = 0
        
        if countOfViews == 0 {
            
            stackViewHeight = 8
            
        } else {
            
            stackViewHeight = CGFloat(countOfViews * 33)
        }
        return staticItemsHeight + stackViewHeight
    }

        let colorsDictionary : [String:String] = ["Pale Aqua":"B7D3F2", "Maximum Blue Purple":"AFAFDC", "Medium Purple":"8A84E2", "Light Cobalt Blue":"84AFE6", "Aero":"79BEEE", "Steel Blue":"457EAC", "Bedazzled Blue":"2D5D7B", "Salmon Pink":"FFA8A9", "Melon":"FBC2B5", "Magenta Haze":"A14A76", "Lapis Lazuli":"2660A4", "Ceil":"8D91C7", "Rhythm":"6E75A8", "Light Blue":"B0DAF1", "Dark Purple":"3E1929", "Fuzzy Wuzzy":"C17786", "Dark Vanilla":"D3B99F", "Wild Blue Yonder":"9AADBF", "Cerulean Frost":"6D98BA"]
    
    // MARK: Update Views method. Creates normal view, or editing view.
    
    func updateViews(withDeleteButton: Bool) {
        guard let bucket = self.bucket else { return }
        self.newEntryTitleTextField.delegate = self
        self.newEntryAmountTextField.delegate = self        
        self.bucketTitleLabelClosedCell.text = bucket.bucketTitle
        self.bucketTitleLabelOpenCell.text = bucket.bucketTitle
        
        guard let bucketColorString = bucket.bucketColor else { return }
        let colorHex = colorsDictionary[bucketColorString]?.colorFromHex()
        let colorHexAlpha = colorHex?.withAlphaComponent(0.5)
        self.bucketCellColorLabaelClosedCell.backgroundColor = colorHex
        self.bucketCellColorLabelOpenCell.backgroundColor = colorHexAlpha
        self.bucketTitleLabelClosedCell.layer.backgroundColor = colorHexAlpha?.cgColor
 
        self.bucketDatetimeLabelClosedCell.text = "Created: \(bucketDate ?? "No date")"
        self.bucketClosedIndex.text = "\(String(describing: BucketController.shared.buckets.index(of: bucket)))"
        self.bucketOpenIndex.text = "\(String(describing: BucketController.shared.buckets.index(of: bucket)))"
        
        let removeViews = entryStackView.arrangedSubviews
        for view in removeViews {
            view.removeFromSuperview()
        }
        
        if bucket.entries?.count == 0 {
            self.bucketTotalLabelClosedCell.text = "Running Total: 0"
            self.bucketItemCountLabelClosedCell.text = "No Items"
            self.bucketTotalLabelOpenCell.text = "Please add an item"
            
        } else {

            let entryCount = bucket.entries!.count
            let entriesSet = bucket.entries!
            let total = BucketController.shared.total(bucket: bucket)
            self.bucketTotalLabelClosedCell.text = "Running Total: \(total)"
            self.bucketItemCountLabelClosedCell.text = "Items: \(entryCount)"
            self.bucketTotalLabelOpenCell.text = "Running Total: \(total)"
            
            let entryStackViewTitleStackView = UIStackView()
            let entryStackViewTitleLabel = UILabel()
            let entryStackViewAmountLabel = UILabel()
            entryStackViewTitleLabel.text = "Item name"
            entryStackViewAmountLabel.text = "Amount"
            entryStackViewTitleStackView.addArrangedSubview(entryStackViewTitleLabel)
            entryStackViewTitleStackView.addArrangedSubview(entryStackViewAmountLabel)
            
            let labelAmountHeaderWidthConstraint = NSLayoutConstraint(item: entryStackViewAmountLabel, attribute: .width, relatedBy: .equal, toItem: entryStackViewTitleStackView, attribute: .width, multiplier: 1/5, constant: 0)
            entryStackViewTitleStackView.addConstraint(labelAmountHeaderWidthConstraint)
            
            self.entryStackView.addArrangedSubview(entryStackViewTitleStackView)
            
            var entriesArray: [Entry] = []
            
            for entry in entriesSet {
                guard let entry = entry as? Entry else { return }
                entriesArray.append(entry)
            }
            
            if withDeleteButton == true {
                
                for entry in entriesArray {
                    
                    let stackView = UIStackView()
                    let labelTitle = UILabel()
                    let labelAmount = UILabel()
                    let deleteButton = UIButton()
                    
                    guard let entryIndex = entriesArray.index(of: entry) else { return }
                    
                    deleteButton.tag = entryIndex
                    deleteButton.setTitle("delete", for: .normal)
                    deleteButton.backgroundColor = UIColor.darkGray
                    deleteButton.addTarget(self, action: #selector(deleteItemButtonTapped(_:)), for: .touchUpInside)
                    self.deleteEntryButtons.append(deleteButton)
                    stackView.addArrangedSubview(deleteButton)
                    let deleteButtonConstraint = NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1/6, constant: 0)
                    stackView.addConstraint(deleteButtonConstraint)
                    
                    labelTitle.text = entry.title
                    labelTitle.adjustsFontSizeToFitWidth = true
                    labelAmount.adjustsFontSizeToFitWidth = true
                    
                    labelAmount.text = "\(entry.amount)"
                    stackView.addArrangedSubview(labelTitle)
                    stackView.addArrangedSubview(labelAmount)
                    labelAmount.translatesAutoresizingMaskIntoConstraints = false
                    let labelAmountWidthConstraint = NSLayoutConstraint(item: labelAmount, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1/5, constant: 0)
                    stackView.addConstraint(labelAmountWidthConstraint)
                    stackView.axis = .horizontal
                    entryStackView.addArrangedSubview(stackView)
                }
                
                let buttonStackView = UIStackView()
                var deleteAllEntriesButton: UIButton

                deleteAllEntriesButton = UIButton()
                deleteAllEntriesButton.setTitle("Delete All", for: .normal)
                deleteAllEntriesButton.backgroundColor = UIColor.red
                deleteAllEntriesButton.addTarget(self, action: #selector(deleteAllEntriesButtonTapped(_:)), for: .touchUpInside)
               
                cancelEditListButton = UIButton()
                cancelEditListButton.setTitle("Cancel", for: .normal)
                cancelEditListButton.backgroundColor = UIColor.darkGray
                cancelEditListButton.addTarget(self, action: #selector(cancelEditListButtonTapped(_:)), for: .touchUpInside)
                
                buttonStackView.addArrangedSubview(deleteAllEntriesButton)
                buttonStackView.addArrangedSubview(cancelEditListButton)
                
                let deleteAllButtonWidthConstraint = NSLayoutConstraint(item: deleteAllEntriesButton, attribute: .width, relatedBy: .equal, toItem: buttonStackView, attribute: .width, multiplier: 1/2, constant: 0)
                buttonStackView.addConstraint(deleteAllButtonWidthConstraint)
                
                entryStackView.addArrangedSubview(buttonStackView)
                
            } else {
                
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
                
                self.editListButton = UIButton()
                self.editListButton.setTitle("Edit list", for: .normal)
                self.editListButton.backgroundColor = UIColor.darkGray
                entryStackView.addArrangedSubview(self.editListButton)
                editListButton.addTarget(self, action: #selector(editListButtonTapped(_:)), for: .touchUpInside)
            }
        }
        bucketCellOpenHeight.constant = openHeight
    }
    
    // MARK: Text field restraints
    
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

extension String {
    
    func colorFromHex() -> UIColor {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: self)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        
        // Convert hex string to an integer
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        let alpha = CGFloat(1.0)
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}

