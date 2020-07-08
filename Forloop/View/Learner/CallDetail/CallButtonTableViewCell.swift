//
//  CallButtonTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class CallButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var callButton : UIButton!
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var callAgainLabel: UILabel!
    @IBOutlet weak var swipeRightLabel: UILabel!
    @IBOutlet weak var doubleArrowImageOne: UIImageView!
    @IBOutlet weak var doubleArrowImageTwo: UIImageView!
    @IBOutlet weak var swipeView: MTSlideToOpenView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.createSwipeView()
    }
    
    
        func createSwipeView(){
    //        swipeView.sliderViewTopDistance = 0
            swipeView.sliderViewTopDistance = 0
            swipeView.thumbnailViewTopDistance = 4;
            swipeView.thumbnailViewStartingDistance = 4;
//            swipeView.cornerRadius = 25
    //        swipeView.
            swipeView.showSliderText = true
            swipeView.thumbnailColor = UIColor.white//UIColor(red:245.0/255, green:187.0/255, blue:30.0/255, alpha:1.0)
            swipeView.slidingColor = appColor.appGreenColor//UIColor(red:117.0/255, green:211.0/255, blue:128.0/255, alpha:1.0)//UIColor.red
            swipeView.textColor = UIColor.clear
            swipeView.sliderBackgroundColor = UIColor.clear//UIColor(red:0.88, green:1, blue:0.98, alpha:1.0)
    //        swipeView.delegate = self
            swipeView.thumnailImageView.image = UIImage(named: "phone_icon")
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.callButton, borderColor: .clear, borderWidth: 0)
    }
    
    
    
}
