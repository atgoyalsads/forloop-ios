//
//  SignUpUserTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 06/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class SignUpUserTableViewCell: UITableViewCell {
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var confirmPasswordTextField:UITextField!

    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var emailView:UIView!
    @IBOutlet weak var passwordView:UIView!
    @IBOutlet weak var confirmPasswordView:UIView!

//    @IBOutlet weak var termsAndConditionButton:UIButton!
    @IBOutlet weak var selectConditionButton:UIButton!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CommonClass.makeCircularCornerNewMethodRadius(backView, cornerRadius: 20)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
