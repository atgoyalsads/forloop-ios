//
//  UserDetailTextfieldsTableViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 08/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

class UserDetailTextfieldsTableViewCell: UITableViewCell {
    @IBOutlet weak var userDetailTextfield: UITextField!
    @IBOutlet weak var userDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        CommonClass.makeViewCircularWithRespectToHeight(self.userDetailTextfield, borderColor: .clear, borderWidth: 0)
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
