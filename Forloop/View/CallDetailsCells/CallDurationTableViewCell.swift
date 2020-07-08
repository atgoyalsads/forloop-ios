//
//  CallDurationTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 11/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class CallDurationTableViewCell: UITableViewCell {

    @IBOutlet weak var userOneImage: UIImageView!
    @IBOutlet weak var userTwoImage: UIImageView!
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var callerName: UILabel!
    @IBOutlet weak var callDate: UILabel!
    @IBOutlet weak var callDurationLabel: UILabel!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var lightViewUserOne: UIView!
    @IBOutlet weak var darkViewUserOne: UIView!
    @IBOutlet weak var lightViewUserTwo: UIView!
    @IBOutlet weak var darkViewUserTwo: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.userOneImage, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.userTwoImage, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.lightViewUserOne, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.lightViewUserTwo, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.darkViewUserOne, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.darkViewUserTwo, borderColor: .clear, borderWidth: 0)
    }
    
}
