//
//  NextPreviousButtonTableViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 08/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

class NextPreviousButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var backPreviousView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonClass.makeViewCircularWithRespectToHeight(self.backPreviousView, borderColor: .clear, borderWidth: 0)
        self.backgroundColor = .clear
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
