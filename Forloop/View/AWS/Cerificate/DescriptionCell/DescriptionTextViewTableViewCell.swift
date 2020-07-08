//
//  DescriptionTextViewTableViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 09/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class DescriptionTextViewTableViewCell: UITableViewCell {
    @IBOutlet weak var textviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addCertificationConstraint: NSLayoutConstraint!
    @IBOutlet weak var minConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var descTextview: RSKPlaceholderTextView!
    @IBOutlet weak var minCharacterLabel: UILabel!
    @IBOutlet weak var addCertificationLabel: UILabel!
    @IBOutlet weak var cornerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
