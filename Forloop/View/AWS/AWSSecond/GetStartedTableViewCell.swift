//
//  GetStartedTableViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 08/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

class GetStartedTableViewCell: UITableViewCell {
    @IBOutlet weak var getStartedLabel: UILabel!
//    @IBOutlet weak var informationUsedLabel: UILabel!
    @IBOutlet weak var professionalDetailsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
                self.backgroundColor = .clear

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
