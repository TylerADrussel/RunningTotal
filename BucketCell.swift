//
//  BucketCell.swift
//  Running Total
//
//  Created by Tyler Drussel on 4/2/17.
//  Copyright © 2017 Tyler Drussel. All rights reserved.
//

import UIKit

class BucketCell: FoldingCell {
    
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

    @IBAction func createNewEntryTapped(_ sender: Any) {
        delegate?.addButtonTapped(in: self)
    }
    
    var delegate: AddItemFromBucketCellDelegate?
    
    var bucket: Bucket? {
        didSet {
            updateViews()
        }
    }
    
    var bucketDate: String?

    var bucketIndex: Int = 0 {
        didSet {
            bucketClosedIndex.text = String(bucketIndex)
            bucketOpenIndex.text = String(bucketIndex)
        }
    }
    
    func updateViews() {
        guard let bucket = self.bucket else { return }
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
                entryStackView.removeArrangedSubview(view)
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
//                let label = UILabel()
                
                labelTitle.text = entry.title
                labelAmount.text = "\(entry.amount)"
                
                stackView.addArrangedSubview(labelTitle)
                stackView.addArrangedSubview(labelAmount)
//                UITapGestureRecognizer(target: <#T##Any?#>, action: #selector(delete))
                stackView.axis = .horizontal
//                stackView.leftAnchor.constraint(equalTo: entryStackView.leftAnchor)
//                stackView.rightAnchor.constraint(equalTo: entryStackView.rightAnchor)
                
//                stackView.distribution = .fillEqually
//                stackView.alignment = .center
                
//                entryStackView.leadingAnchor.constraint(equalTo: entryStackViewEmbeddedView.leadingAnchor)
//                entryStackView.trailingAnchor.constraint(equalTo: entryStackViewEmbeddedView.trailingAnchor)
                
                entryStackView.addArrangedSubview(stackView)
            }
        }
    }
    
    func delete() {
        
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

