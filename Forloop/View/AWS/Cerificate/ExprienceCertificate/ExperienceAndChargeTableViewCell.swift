//
//  ExperienceAndChargeTableViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 09/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

class ExperienceAndChargeTableViewCell: UITableViewCell {
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var freeCallsLabel: UILabel!
    @IBOutlet weak var chargeTextField: UITextField!
    @IBOutlet weak var chargeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonClass.makeViewCircularWithRespectToHeight(self.chargeView, borderColor: .clear, borderWidth: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
