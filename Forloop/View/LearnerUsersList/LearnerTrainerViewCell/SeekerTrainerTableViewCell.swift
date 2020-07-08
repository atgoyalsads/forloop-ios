//
//  SeekerTrainerTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 10/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import Tags

class SeekerTrainerTableViewCell: UITableViewCell {

    @IBOutlet weak var tutorImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var onBaseCount: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var lessonsLabel: UILabel!
    @IBOutlet weak var viewBehindCharge: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var tagsView: TagsView!
    @IBOutlet weak var displayName: UILabel!

    var tags: [String]? {
        willSet {
            if let newValue = newValue {
                self.tagsView.set(contentsOf: newValue)
            } else {
                self.tagsView.removeTags()
            }
        }
    }
    
    var tagButton: [TagButton]? {
        willSet {
            if let newValue = newValue {
                self.tagsView.set(contentsOf: newValue)
            } else {
                self.tagsView.removeTags()
            }
        }
    }
    
    var lastTag: String? {
        willSet {
            self.tagsView.lastTag = newValue
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        self.viewBehindCharge.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.viewBehindCharge.clipsToBounds = true
        self.viewBehindCharge.layer.cornerRadius = 10
        
    }

}


extension SeekerTrainerTableViewCell: TagsDelegate {
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
//        tagButton.isSelected = !tagButton.isSelected
//        tagButton.backgroundColor = tagButton.isSelected ? greenButtonColor : navigationColor
//        self.delegate?.selectTime(self, selectTime: tagButton.titleLabel!.text ?? "")
        
    }
    
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
    }
    
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
    }
}

