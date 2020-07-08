//
//  UserAccountProfileCellTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 09/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class UserAccountProfileCellTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var switchProfileButton:UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CommonClass.makeViewCircularWithRespectToHeight(switchProfileButton, borderColor: .clear, borderWidth: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
