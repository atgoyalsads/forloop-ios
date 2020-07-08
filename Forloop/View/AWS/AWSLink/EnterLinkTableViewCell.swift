//
//  EnterLinkTableViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 08/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

class EnterLinkTableViewCell: UITableViewCell {

    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var linkTextfield: UITextField!
    @IBOutlet weak var linkView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonClass.makeViewCircularWithRespectToHeight(self.linkView, borderColor: .clear, borderWidth: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
