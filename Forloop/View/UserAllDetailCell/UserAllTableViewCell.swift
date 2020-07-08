//
//  UserAllTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 31/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class UserAllTableViewCell: UITableViewCell {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
                self.backgroundColor = .clear
        CommonClass.makeViewCircularWithRespectToHeight(self.firstNameTextField, borderColor: .clear, borderWidth: 0)
                CommonClass.makeViewCircularWithRespectToHeight(self.lastNameTextField, borderColor: .clear, borderWidth: 0)
                CommonClass.makeViewCircularWithRespectToHeight(self.zipCodeTextField, borderColor: .clear, borderWidth: 0)
                CommonClass.makeViewCircularWithRespectToHeight(self.genderTextField, borderColor: .clear, borderWidth: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
