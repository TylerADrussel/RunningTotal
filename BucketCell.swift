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
    @IBOutlet weak var entryStackView: UIStackView!

    @IBAction func createNewEntryTapped(_ sender: Any) {
        delegate?.addButtonTapped(in: self)
    }
    
    var delegate: AddItemFromBucketCellDelegate?

    var bucketIndex: Int = 0 {
        didSet {
            bucketClosedIndex.text = String(bucketIndex)
            bucketOpenIndex.text = String(bucketIndex)
        }
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

