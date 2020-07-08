//
//  TextIncomingTableViewCell.swift
//  ViybApp
//
//  Created by Tecorb Techonologies on 19/08/19.
//  Copyright © 2019 Parikshit. All rights reserved.
//

import UIKit

class TextIncomingTableViewCell: UITableViewCell {
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.senderImage, borderColor: .clear, borderWidth: 0)
    }
    
}
