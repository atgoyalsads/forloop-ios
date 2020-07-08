//
//  HomeViewController.swift
//  Forloop
//
//  Created by Tecorb on 09/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import FSCalendar

class HomeViewController: UIViewController {
    
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var statusToggleButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var navView: UIView!
    var selected = 0
    var heightOfSection:[CGFloat] = [90,50,90]
    lazy var data: [Double] = []
    lazy var labels: [String] = []
    
    var selectYearField:UITextField!
    var yearPicker = UIPickerView()
    var yearArray = ["Weekly","Monthly","Yearly"]
    var selectYear = "Monthly"
    var defaultvalue :Int = 0
    var user = User()
    var homePro = HomeProModel()
    var totalPrice = ""
    
    
    //    @IBOutlet weak var calenderView:FSCalendar!
    //    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    //    var selectedDate = Date()
    //    var todayDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.loadSavedUser()
        
        self.registerCells()
        if !self.user.proUserStatus.isDisplayName || !self.user.proUserStatus.isDetails || !self.user.proUserStatus.isPrice || !self.user.proUserStatus.isSubcategories{
            self.askForSubmitProDetails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.loadHomeData(keyword: "monthly", requestOption: "3")

        }
        setNeedsStatusBarAppearanceUpdate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = User.loadSavedUser()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
          return .darkContent
      }
    
    
    func registerCells() {
        let monthCollectionViewCellNib = UINib(nibName: "MonthCollectionViewCell", bundle: nil)
        collectionView.register(monthCollectionViewCellNib, forCellWithReuseIdentifier: "MonthCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        let wholeChargeTableViewCellNib = UINib(nibName: "WholeChargeTableViewCell", bundle: nil)
        tableview.register(wholeChargeTableViewCellNib, forCellReuseIdentifier: "WholeChargeTableViewCell")
        let callSummaryTableViewCellNib = UINib(nibName: "CallSummaryTableViewCell", bundle: nil)
        tableview.register(callSummaryTableViewCellNib, forCellReuseIdentifier: "CallSummaryTableViewCell")
        let callInformationTableViewCellNib = UINib(nibName: "CallInformationTableViewCell", bundle: nil)
        tableview.register(callInformationTableViewCellNib, forCellReuseIdentifier: "CallInformationTableViewCell")
        let graphNib = UINib(nibName: "GraphTableViewCell", bundle: nil)
        self.tableview.register(graphNib, forCellReuseIdentifier: "GraphTableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    @IBAction func statusButtonTapped(_ sender: UIButton!) {
        //sender.isSelected = !sender.isSelected
    }
    
    
    func askForSubmitProDetails() {
        
        let alert = UIAlertController(title: warningMessage.title.rawValue, message: "Please complete your profile to receive call and list into the search results", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Accept", style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
            self.afterLoginGetDetailStatus()
        }
        let cancelAction = UIAlertAction(title: "Decline", style: .cancel){(action) in
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func afterLoginGetDetailStatus(){
        if !self.user.proUserStatus.isDisplayName{
            let addProfileVC = AppStoryboard.Main.viewController(UserAddProfilePictureViewController.self)
            self.navigationController?.pushViewController(addProfileVC, animated: true)
            
        }else if !self.user.proUserStatus.isDetails{
            let awsSecondVc = AppStoryboard.Main.viewController(UserDetailViewController.self)
            self.navigationController?.pushViewController(awsSecondVc, animated: true)
            
        }else if !self.user.proUserStatus.isLinks{
            let awsSecondVc = AppStoryboard.Main.viewController(AWSLinkViewController.self)
            self.navigationController?.pushViewController(awsSecondVc, animated: true)
            
        }
        else if !self.user.proUserStatus.isPrice{
            
            let awsSecondVc = AppStoryboard.Main.viewController(CertificateViewController.self)
            self.navigationController?.pushViewController(awsSecondVc, animated: true)
            
        }
        else if !self.user.proUserStatus.isSubcategories{
            
            let categoryVC = AppStoryboard.Main.viewController(SelectCategoriesViewController.self)
            self.navigationController?.pushViewController(categoryVC, animated: true)
            
        }
        else{
//            let awsSecondVc = AppStoryboard.Main.viewController(CertificateViewController.self)
//            self.navigationController?.pushViewController(awsSecondVc, animated: true)

            //AppSettings.shared.proceedToDashboard()
            
        }
        
    }
    
    
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = 70
        var height = 65
        if self.selectYear.lowercased() == "monthly" {
         width = 65
         height = 65
        }else if selectYear.lowercased() == "weekly"{
            width = 120
            height = 65
        }else if selectYear.lowercased() == "yearly"{
            width = 70
            height = 65
        }else{
            width = 70
            height = 70
        }
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print_debug("Count>>>>>>>\(self.homePro.availableOptions.count)")
        return self.homePro.availableOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as! MonthCollectionViewCell
        let availableSlot =  self.homePro.availableOptions[indexPath.item]
        
        cell.monthLabel.text = availableSlot.label1
        cell.yearLabel.text = availableSlot.label2
        if indexPath.item == selected {
            cell.backView.backgroundColor = UIColor.white
            cell.monthLabel.textColor = appColor.appBlueColor
            cell.yearLabel.textColor = appColor.appBlueColor
        } else {
            cell.backView.backgroundColor = .clear
            cell.monthLabel.textColor = .white
            cell.yearLabel.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.item
        if self.homePro.availableOptions.count == 0 {return}
        let mon = self.homePro.availableOptions[indexPath.item]
        self.loadHomeData(keyword: selectYear.lowercased(), requestOption: mon.value)
        //collectionView.reloadData()
    }
    
}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return heightOfSection.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return self.homePro.calls.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return heightOfSection[indexPath.section]
            } else {
                return 270
            }
        case 1:
            return heightOfSection[indexPath.section]
            
        case 2:
                return heightOfSection[indexPath.section]
        default :
            return CGFloat(80)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WholeChargeTableViewCell", for: indexPath) as! WholeChargeTableViewCell
                cell.totalChargeLabel.text = "$ " + self.totalPrice
                cell.yearTextField.text = self.selectYear
                self.selectYearField = cell.yearTextField
                self.selectYearField.inputView = self.yearPicker
                self.setUpYearPicker()
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphTableViewCell", for: indexPath) as! GraphTableViewCell
                cell.data = self.data
                cell.labels = self.labels
                if (selectYear != "monthly") &&  (selectYear != "weekly"){
                    cell.updateGraph(type: selectYear)

                }else{
                    cell.updateGraph(type: "yearly")

                }
                return cell
            }
        case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CallSummaryTableViewCell", for: indexPath) as! CallSummaryTableViewCell
                cell.selectionStyle = .none
                return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallInformationTableViewCell", for: indexPath) as! CallInformationTableViewCell
            let call = self.homePro.calls[indexPath.row]
            cell.callerName.text = call.dialerUser.displayName
            cell.timeLabel.text = "\(call.durationMinutes) minutes"
            cell.chargeLabel.text = String(format: "$ %.2f", call.totalPrice)
            cell.dateLabel.text = CommonClass.formattedDateWithString(call.createdAt, format: "dd-MMMM-yyyy")

            cell.selectionStyle = .none
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WholeChargeTableViewCell", for: indexPath) as! WholeChargeTableViewCell
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            if self.homePro.calls.count == 0{return}
            let call = self.homePro.calls[indexPath.row]
            let callDetailVC = AppStoryboard.Dashboard.viewController(CallDetailViewController.self)
            callDetailVC.call = call
            self.navigationController?.pushViewController(callDetailVC, animated: true)
        }
    }
}



extension HomeViewController{
    func setUpYearPicker() {
        self.yearPicker = UIPickerView()
        
        self.yearPicker.backgroundColor = UIColor.lightText
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action:#selector(onClickEventDone(_:)))
        doneButton.tintColor = UIColor.white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(onClickCancel(_:)))
        cancelButton.tintColor = UIColor.white
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.barStyle = UIBarStyle.default
        toolbar.barTintColor = appColor.appBlueColor
        toolbar.tintColor = UIColor.white
        self.selectYearField.inputView = self.yearPicker
        self.selectYearField.inputAccessoryView = toolbar;
        self.yearPicker.dataSource = self
        self.yearPicker.delegate = self
        
    }
    
    
    @IBAction func onClickEventDone(_ sender: UIBarButtonItem){
        self.selectYear = yearArray[yearPicker.selectedRow(inComponent: 0)]
        selectYearField.text = selectYear.capitalized
        selectYearField.resignFirstResponder()
        self.view.endEditing(true)
        self.selected = 0
        if self.selectYear.lowercased() == "monthly" {
            self.loadHomeData(keyword: self.selectYear.lowercased(), requestOption: "3")
        }else if self.selectYear.lowercased() == "weekly" {
            self.loadHomeData(keyword: self.selectYear.lowercased(), requestOption: "1")
        }else{
            self.loadHomeData(keyword: self.selectYear.lowercased(), requestOption: "2020")
        }
        
    }
    
    
    @IBAction func onClickCancel(_ sender: UIBarButtonItem){
        
        self.view.endEditing(true)
    }
}


extension HomeViewController: UIPickerViewDataSource,UIPickerViewDelegate{
    
    // Mark:- SetUp Year Picker
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectYear = yearArray[row]
    }
}

extension HomeViewController{
    func loadHomeData(keyword:String,requestOption:String){
        if !AppSettings.isConnectedToNetwork{
          NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
             return
         }
        AppSettings.shared.showLoader(withStatus: "Loading..")
        ProService.sharedInstance.proDashboard(keyword: keyword, requestOption: requestOption) { (success, resHome, message) in
            AppSettings.shared.hideLoader()
            if let someHome = resHome{
                self.homePro = someHome
                self.homePro.resultModel = self.homePro.resultModel.sorted(by: { (d1, d2) -> Bool in
                    return d1.intValue > d2.intValue
                })
                
                self.labels = self.homePro.resultModel.map{$0.label}
                self.data = self.homePro.resultModel.map{Double($0.value) ?? 0.0}
                self.totalPrice = String(format: "%.2f", self.data.reduce(0, +))
                

                self.collectionView.reloadData()
                self.tableview.reloadData()
                
            }
        }
        
    }
}



//extension HomeViewController:FSCalendarDataSource, FSCalendarDelegate {
//    
//    
//    func setupCalender(){
//        
//        calenderView.calendarHeaderView.backgroundColor = UIColor.white
//        calenderView.appearance.headerTitleColor = UIColor.white
//        calenderView.appearance.todayColor = appColor.white//appColor.appBlueColor
//        self.calenderView.appearance.titleTodayColor = appColor.appBlueColor//appColor.white
//        self.calenderView.appearance.titleFont = UIFont(name: "Roboto-Bold", size: 15.0)
//        self.calenderView.appearance.headerMinimumDissolvedAlpha = 0.8
//        self.calenderView.appearance.selectionColor = appColor.white//appColor.appBlueColor
//        self.calenderView.appearance.titleSelectionColor = appColor.appBlueColor//appColor.white
//        self.calenderView.appearance.subtitleDefaultColor = UIColor.white
//        self.calenderView.appearance.subtitleTodayColor = appColor.appBlueColor//appColor.white
//        self.calenderView.appearance.subtitleSelectionColor = appColor.appBlueColor//appColor.white
//        self.calenderView.appearance.weekdayTextColor = UIColor.white
//        self.calenderView.calendarWeekdayView.backgroundColor = appColor.appBlueColor//UIColor.white
//        self.calenderView.appearance.titleDefaultColor = appColor.white
//        self.calenderView.rowHeight = 200
//        self.calenderView.weekdayHeight = 0
//        self.calenderView.headerHeight = 0
//        self.calenderView.pagingEnabled = true
//        self.calenderView.appearance.borderRadius = 0.5
//        self.calenderView.scrollDirection = .horizontal
//        self.calenderView.setScope(.week, animated: false)
//        self.calenderView.scope = .month
//        calenderView.dataSource = self
//        calenderView.delegate = self
//        
//        
//        
//    }
//    
//    
//    //    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//    //        return 1
//    //    }
//    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.heightConstraint.constant = 50//bounds.height
//        self.calenderView.frame.size.height = 50//bounds.height
//        calenderView.layoutIfNeeded()
//        self.calenderView.setScope(.week, animated: true)
//        self.calenderView.scope = .week//(.week, animated: true)
//        
//        
//    }
//    /*func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//     if todayDate == date{
//     cell.imageView.image = UIImage(named: "line_icon")
//     }else{
//     cell.imageView.image = UIImage()
//     }
//     }*/
//    
//    
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        if monthPosition == .previous || monthPosition == .next {
//            calenderView.setCurrentPage(date, animated: true)
//        }
//        self.selectedDate = date
//        if todayDate == date{return}
//        self.todayDate = date
//        if self.todayDate != calenderView.currentPage{
//            self.calenderView.appearance.todayColor = UIColor.clear
//            self.calenderView.appearance.titleTodayColor = UIColor.white
//            self.calenderView.appearance.subtitleTodayColor = UIColor.white
//        }else{
//            calenderView.appearance.todayColor =  UIColor.clear
//            self.calenderView.appearance.selectionColor = appColor.white//appColor.appBlueColor
//            self.calenderView.appearance.titleSelectionColor = appColor.appBlueColor//UIColor.white
//            self.calenderView.appearance.subtitleSelectionColor = appColor.appBlueColor//UIColor.white
//        }
////        let date = CommonClass.formattedDate(date, format: "yyyy-MM-dd")
////        self.timeSlotsFromServer(slotDate: date)
//        
//        
//    }
//    
//    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        dateFormatter.dateFormat = "MMM"
//        return (dateFormatter.string(from: date))
//    }
//    
//    /*func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//     if self.todayDate == date{
//     return UIImage(named: "line_icon")
//     }else{
//     return nil
//     }
//     }*/
//    
//    
//   
//    
//}
//
//
