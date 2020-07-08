//
//  LoginUserCell.swift
//  Forloop
//
//  Created by Tecorb on 04/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class LoginUserCell: UITableViewCell {
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var forgotPasswordButton:UIButton!
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var emailView:UIView!
    @IBOutlet weak var passwordView:UIView!

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
