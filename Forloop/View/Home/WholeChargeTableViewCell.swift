//
//  WholeChargeTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 11/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class WholeChargeTableViewCell: UITableViewCell {

    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var totalChargeLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var yearTextField:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewRound(self.yearTextField, cornerRadius: 3.0, borderColor: .lightGray, borderWidth: 1.0)
        self.yearTextField.backgroundColor = appColor.backgroundAppColor
    }
    
}
