//
//  ChatListTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 10/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
   
    @IBOutlet weak var otherUserImage: UIImageView!
    @IBOutlet weak var otherUserName: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var onlineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.otherUserImage, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.onlineView, borderColor: .white, borderWidth: 2)
    }
    
}
