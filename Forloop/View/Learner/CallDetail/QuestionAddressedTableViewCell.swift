//
//  QuestionAddressedTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class QuestionAddressedTableViewCell: UITableViewCell {

    @IBOutlet weak var questionAddressedLabel: UILabel!
    @IBOutlet weak var yesNoButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.yesNoButton, borderColor: .clear, borderWidth: 0)
    }
    
}
