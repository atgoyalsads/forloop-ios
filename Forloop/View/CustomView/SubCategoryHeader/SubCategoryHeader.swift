//
//  SubCategoryHeader.swift
//  Forloop
//
//  Created by Tecorb on 08/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit

class SubCategoryHeader: UIView {
    class func instanceFromNib() -> SubCategoryHeader {
        return UINib(nibName: "SubCategoryHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SubCategoryHeader
    }
}
