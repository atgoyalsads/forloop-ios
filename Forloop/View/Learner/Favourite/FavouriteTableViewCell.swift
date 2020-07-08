//
//  FavouriteTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import Tags


class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var tutorImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var onBaseCount: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagsView: TagsView!
    @IBOutlet weak var titleLabel: UILabel!

    
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
    
}



extension FavouriteTableViewCell: TagsDelegate {
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
//        tagButton.isSelected = !tagButton.isSelected
//        tagButton.backgroundColor = tagButton.isSelected ? greenButtonColor : navigationColor
//        self.delegate?.selectTime(self, selectTime: tagButton.titleLabel!.text ?? "")
        
    }
    
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
    }
}

