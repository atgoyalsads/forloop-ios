//
//  TempTextViewTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 27/02/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class TempTextViewTableViewCell: UITableViewCell {
    @IBOutlet weak var  aTextView:RSKPlaceholderTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
