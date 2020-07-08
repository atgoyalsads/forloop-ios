//
//  SelectPaymentCellTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 23/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class SelectPaymentCellTableViewCell: UITableViewCell {
    @IBOutlet weak var cardImage:UIImageView!
    @IBOutlet weak var cardNumberLabel:UILabel!
    @IBOutlet weak var cardNumberTextField:UITextField!
    @IBOutlet weak var cardHolderTextField:UITextField!
    @IBOutlet weak var expryTextField:UITextField!
    @IBOutlet weak var cvvTextField:UITextField!
    @IBOutlet weak var selectButton:UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .groupTableViewBackground
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
