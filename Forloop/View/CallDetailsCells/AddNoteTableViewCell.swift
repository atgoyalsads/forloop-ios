//
//  AddNoteTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 11/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class AddNoteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var buttonToCall: UIButton!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var sendMessageLabel: UILabel!
    @IBOutlet weak var swipeRightLabel: UILabel!
    @IBOutlet weak var doubleArrowImageOne: UIImageView!
    @IBOutlet weak var doubleArrowImageTwo: UIImageView!
    @IBOutlet weak var swipeView: MTSlideToOpenView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.createSwipeView()
        //swipeView.isHidden = true
    }
    
    func createSwipeView(){
//        swipeView.sliderViewTopDistance = 0
        swipeView.sliderViewTopDistance = 0
        swipeView.thumbnailViewTopDistance = 4;
        swipeView.thumbnailViewStartingDistance = 4;
//        swipeView.
        swipeView.showSliderText = true
        swipeView.thumbnailColor = UIColor.white//UIColor(red:245.0/255, green:187.0/255, blue:30.0/255, alpha:1.0)
        swipeView.slidingColor = UIColor(red:245.0/255, green:187.0/255, blue:30.0/255, alpha:1.0)//UIColor.red
        swipeView.textColor = UIColor.clear
        swipeView.sliderBackgroundColor = UIColor.clear//UIColor(red:0.88, green:1, blue:0.98, alpha:1.0)
//        swipeView.delegate = self
        swipeView.thumnailImageView.image = UIImage(named: "msg_box")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.buttonToCall, borderColor: .clear, borderWidth: 0)
    }
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        
    }
    
    
}
