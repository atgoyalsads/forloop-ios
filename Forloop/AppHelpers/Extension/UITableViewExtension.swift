//
//  TableViewExtension.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

public extension UITableView {
    func addFooterSpinner(){
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        self.tableFooterView = spinner
    }

    func removeFooterSpinner(){
        self.tableFooterView = nil
    }

//    func registerCellClass(cellClass: AnyClass) {
//        let identifier = String. className(aClass: cellClass)
//        self.register(cellClass, forCellReuseIdentifier: identifier)
//    }
//    
//    func registerCellNib(cellClass: AnyClass) {
//        let identifier = String.className(aClass: cellClass)
//        let nib = UINib(nibName: identifier, bundle: nil)
//        self.register(nib, forCellReuseIdentifier: identifier)
//    }
//    
//    func registerHeaderFooterViewClass(viewClass: AnyClass) {
//        let identifier = String.className(aClass: viewClass)
//        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
//    }
//    
//    func registerHeaderFooterViewNib(viewClass: AnyClass) {
//        let identifier = String.className(aClass: viewClass)
//        let nib = UINib(nibName: identifier, bundle: nil)
//        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
//    }
}
