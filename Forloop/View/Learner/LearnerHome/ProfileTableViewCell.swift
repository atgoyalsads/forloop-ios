//
//  ProfileTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 13/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import Tags

protocol ProfileTableViewCellDelegate {
    func profileTableViewCellIndex(selectIndexPath:IndexPath,success:Bool,setProfile:Bool,user:User,tableIndex:Int)
    func profileTableViewCellPagination(success:Bool,tableViewIndex:Int,isTopUSer:Bool)
}

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    var setProfile : Bool?
    var delegate:ProfileTableViewCellDelegate?
    
    var userData = [User]()
    var topProUsers = [User]()
    var tableViewIndex:Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCells()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func registerCells() {
        let trainerCollectionViewCellNib = UINib(nibName: "TrainerCollectionViewCell", bundle: nil)
        self.collectionView.register(trainerCollectionViewCellNib, forCellWithReuseIdentifier: "TrainerCollectionViewCell")
        let topProCollectionViewCellNib = UINib(nibName: "TopProCollectionViewCell", bundle: nil)
        self.collectionView.register(topProCollectionViewCellNib, forCellWithReuseIdentifier: "TopProCollectionViewCell")
        self.collectionView.backgroundColor  = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    
    func setSubCategoryData(user:[User]){
        self.userData = user
        self.collectionView.reloadData()
        
    }
    
    func setTopProUserData(user:[User]){
        self.topProUsers = user
        self.collectionView.reloadData()
    }
    
    
    private func makeButton(_ text: String) -> TagButton {
        let button = TagButton()
        button.setTitle(text, for: .normal)
        //button.setImage(UIImage(named: "tick_unsel"), for: .normal)
        //button.setImage(UIImage(named: "tick_sel"), for: .selected)
        
        let options = ButtonOptions(
            layerColor: appColor.blue,//UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0),
            layerRadius: 5,
            layerWidth: 1,
            tagTitleColor: UIColor.blue,
            tagFont: fonts.Roboto.regular.font(.small),
            tagBackgroundColor: appColor.lightGray)//UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0))
        button.setEntity(options)
        return button
    }
    
    
}

extension ProfileTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let check = self.setProfile {
            if check {
                var tempWidth:CGFloat = 0
                if self.userData.count == 1{
                    tempWidth = (self.collectionView.frame.width )
                    
                }else{
                    tempWidth = ((self.collectionView.frame.width ) * 9 ) / 10
                    
                }
                let height = self.collectionView.frame.height
                return CGSize(width: tempWidth , height: height)
            } else {
                let width = ((self.collectionView.frame.width) * 9 ) / 10
                let height = ( self.collectionView.frame.height / 2 ) - 5
                return CGSize(width: width , height: height)
            }
        }
        let width = (self.collectionView.frame.width )
        let height = self.collectionView.frame.height
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let check = self.setProfile {
            if check{
                return self.userData.count
            }else{
                return self.topProUsers.count
                
            }
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let check = self.setProfile {
            if check {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCollectionViewCell", for: indexPath) as! TrainerCollectionViewCell
                let user = self.userData[indexPath.item]
                cell.displayName.text = user.displayName.capitalized
                cell.descriptionLabel.text = user.userDescription
                cell.ratingLabel.text = user.callsDataHome.avgRating.isZero ? "0" : String(format: "%.1f", user.callsDataHome.avgRating)
                cell.onBaseCount.text = "(\(user.callsDataHome.totalReviews)) "
                cell.lessonsLabel.text = "\(user.callsDataHome.totalCalls) Calls"
                cell.chargeLabel.text = Rs + String(format: "%.1f", user.pricePerHours) + "/hour"
                cell.tutorImage.sd_setImage(with: URL(string:user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "profile_icon"))
                
                cell.tagButton = user.skills.compactMap({ self.makeButton($0.skill.uppercased()) })
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopProCollectionViewCell", for: indexPath) as! TopProCollectionViewCell
                let user = self.topProUsers[indexPath.item]
                cell.topperImage.sd_setImage(with: URL(string:user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "profile_icon"))
                cell.topperName.text = user.displayName.capitalized
                cell.topperDescription.text = user.userDescription
                cell.ratingView.rating = Float(user.callsDataHome.avgRating)
                cell.ratingView.isUserInteractionEnabled = false
                cell.ratinglabel.text = user.callsDataHome.avgRating.isZero ? "(0)" : String(format: "(%.1f)", user.callsDataHome.avgRating)
                cell.lessonsLabel.text = "\(user.callsDataHome.totalCalls) Calls"
                switch indexPath.item % 4 {
                case 0:
                    cell.backgroundImage.image = UIImage(named: "rect_one")
                case 1:
                    cell.backgroundImage.image = UIImage(named: "rect_two")
                case 2:
                    cell.backgroundImage.image = UIImage(named: "rect_three")
                case 3:
                    cell.backgroundImage.image = UIImage(named: "rect_four")
                default:
                    cell.backgroundImage.image = UIImage(named: "rect_one")
                }
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopProCollectionViewCell", for: indexPath) as! TopProCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let check = self.setProfile {
            if check {
                let user = self.userData[indexPath.item]
                
                self.delegate?.profileTableViewCellIndex(selectIndexPath: indexPath, success: true, setProfile: true, user: user, tableIndex: tableViewIndex)
                
            }else{
                let user = self.topProUsers[indexPath.item]
                
                self.delegate?.profileTableViewCellIndex(selectIndexPath: indexPath, success: true, setProfile: false, user: user, tableIndex: tableViewIndex)
                
            }
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= scrollView.contentSize.width-10){
            if let check = self.setProfile {
                if check {
                    self.delegate?.profileTableViewCellPagination(success: true, tableViewIndex: tableViewIndex, isTopUSer: false)
                }else{
                    self.delegate?.profileTableViewCellPagination(success: true, tableViewIndex: tableViewIndex, isTopUSer: true)
                }
            }
        }
    }
}
