//
//  UserPhoneNumberTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 31/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import  CountryPickerView

protocol UserContactCellDelegate {
    func contact(contactCell cell:UserPhoneNumberTableViewCell, didSelectCountry selectedCountry:Country)
}

class UserPhoneNumberTableViewCell: UITableViewCell {
    @IBOutlet weak var countryCodeLabel : UILabel!
    @IBOutlet weak var countryCodeButton : UIButton!
    @IBOutlet weak var countryPickerView: UIView!
    @IBOutlet weak var userDetailTextfield: UITextField!
    @IBOutlet weak var userDetailLabel: UILabel!
    @IBOutlet weak var phoneView: UIView!

    
    var delegate: UserContactCellDelegate?

    var viewController:UIViewController!
    var cpv : CountryPickerView!
    var selectedCountry: Country!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonClass.makeViewCircularWithRespectToHeight(self.phoneView, borderColor: .clear, borderWidth: 0)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickCountryCodeButton(_ sender: UIButton){
        if self.viewController != nil{
            cpv.showCountriesList(from: viewController)
        }
    }
    
}

extension UserPhoneNumberTableViewCell: CountryPickerViewDataSource,CountryPickerViewDelegate{
    
    func countryPickerSetUp(with country:Country? = nil) {
        if cpv != nil{
            cpv.removeFromSuperview()
        }
        
        cpv = CountryPickerView(frame: self.countryPickerView.frame)
        self.countryPickerView.addSubview(cpv)
        cpv.countryDetailsLabel.font = fonts.Roboto.regular.font(.medium)
//        cpv.setCountryByPhoneCode("+251")
        cpv.countryDetailsLabel.textColor = UIColor.clear
        cpv.showPhoneCodeInView = true
        cpv.showCountryCodeInView = true
        cpv.dataSource = self
        cpv.delegate = self
        
        cpv.translatesAutoresizingMaskIntoConstraints = false
        let topConstraints = NSLayoutConstraint(item: cpv, attribute: .top, relatedBy: .equal, toItem: self.countryPickerView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraints = NSLayoutConstraint(item: cpv, attribute: .bottom, relatedBy: .equal, toItem: self.countryPickerView, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraints = NSLayoutConstraint(item: cpv, attribute: .leading, relatedBy: .equal, toItem: self.countryPickerView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraints = NSLayoutConstraint(item: cpv, attribute: .trailing, relatedBy: .equal, toItem: self.countryPickerView, attribute: .trailing, multiplier: 1, constant: 0)
        self.countryPickerView.addConstraints([topConstraints,leadingConstraints,trailingConstraints,bottomConstraints])
        
        if let selCountry = country{
            self.selectedCountry = selCountry
            cpv.setCountryByCode(selCountry.code)
        }else{
            self.selectedCountry = cpv.selectedCountry
            delegate?.contact(contactCell: self, didSelectCountry: self.selectedCountry)
        }
        self.countryCodeLabel.text = self.selectedCountry.phoneCode
//        self.countryImage.image = self.selectedCountry.flag
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return (AppSettings.shared.currentCountryCode.count != 0) ? "Current" : nil
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select Country"
    }
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil
        //        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: nil, action: nil)
        //        barButton.tintColor = appColor.blue
        //        return barButton
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .navigationBar
    }
    
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.selectedCountry = country
        self.countryCodeLabel.text = self.selectedCountry.phoneCode
//        self.countryImage.image = self.selectedCountry.flag
        delegate?.contact(contactCell: self, didSelectCountry: self.selectedCountry)
    }
    
    
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        if let currentCountry = countryPickerView.getCountryByPhoneCode(AppSettings.shared.currentCountryCode){
            return [currentCountry]
        }else{
            return [countryPickerView.selectedCountry]
        }
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    
}




