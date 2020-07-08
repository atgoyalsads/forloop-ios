//
//  SubmitButtonTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 05/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class SubmitButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var notAccountSignUpButton:UIButton!
    @IBOutlet weak var alreadyAccoutLoginButton:UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        CommonClass.makeCircularCornerNewMethodRadius(loginButton, cornerRadius: loginButton.frame.size.height/2)
        loginButton.backgroundColor = appColor.appBlueColor

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
