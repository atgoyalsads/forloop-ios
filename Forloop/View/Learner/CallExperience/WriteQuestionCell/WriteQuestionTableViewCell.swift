//
//  WriteQuestionTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 24/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

protocol WriteQuestionTableViewCellDelegate {
    func writeQuestionTableViewCell(tableViewIndexPathRow:Int,success:Bool,rating:Float)
}
class WriteQuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var  aTextView:RSKPlaceholderTextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: NKFloatRatingView!
    var delegate:WriteQuestionTableViewCellDelegate?
    var tableIndexRow: Int = 0
    

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTableViewData(index:Int){
        self.tableIndexRow = index
    }
    
    
    
}

extension WriteQuestionTableViewCell:NKFloatRatingViewDelegate{
func floatRatingView(_ ratingView: NKFloatRatingView, didUpdate rating: Float) {
    self.delegate?.writeQuestionTableViewCell(tableViewIndexPathRow: tableIndexRow, success: true, rating: rating)
    }
}
