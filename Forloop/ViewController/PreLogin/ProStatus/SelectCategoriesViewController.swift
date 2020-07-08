//
//  SelectCategoriesViewController.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 09/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

class SelectCategoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var aSearchBar: UISearchBar!
    @IBOutlet weak var submitView:UIView!
    var heightOfRows:[CGFloat] = [50,140]
        var page = 1
        var perPage = 5
    //    var totalPage = 0
       var isLoading = false
    var categories = [CategoryModel]()
    var selectCatecory = [CategoryModel]()
    var isSeachActive = false
    var isSeconndTimeLoading = false
    var user = User()
    var isEdit:Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.loadSavedUser()
        
//        for i in (0..<self.user.skillSets.count){
//            var cat = CategoryModel()
//            cat.title = self.user.skillSets[i].subcategoryTitle
//            cat.id = self.user.skillSets[i].subcategory.id
//            self.selectCatecory.append(cat)
//
//        }
        self.aSearchBar.delegate = self
        self.aSearchBar.placeholder = "Search Skills"
        self.aSearchBar.becomeFirstResponder()

        self.view.backgroundColor = appColor.backgroundAppColor
        self.tableView.backgroundColor = .clear

        self.registerCells()
        // Do any additional setup after loading the view.
        self.loadCategoriesFromServer(self.page, perPage: self.perPage, keyword: "")
        print_debug("\(self.user.skillSets.count)")
        if self.isEdit{
            self.setPreviousData()
        }
    }
    
    func setPreviousData(){
        self.selectCatecory = self.user.skillSets
        self.tableView.reloadData()
    }
                
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden =  true
    }
    
    override func viewDidLayoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.submitView, borderColor: .clear, borderWidth: 0)
    }
                
    func registerCells() {
        let getStartedCellNib = UINib(nibName: "GetStartedTableViewCell", bundle: nil)
        self.tableView.register(getStartedCellNib, forCellReuseIdentifier: "GetStartedTableViewCell")
        let SelectCategoriesTableViewCellnib = UINib(nibName: "SelectCategoriesTableViewCell", bundle: nil)
        self.tableView.register(SelectCategoriesTableViewCellnib, forCellReuseIdentifier: "SelectCategoriesTableViewCell")
        let nextCellnib = UINib(nibName: "NextPreviousButtonTableViewCell", bundle: nil)
        self.tableView.register(nextCellnib, forCellReuseIdentifier: "NextPreviousButtonTableViewCell")
        let categoryCellnib = UINib(nibName: "ShowCategoryTableViewCell", bundle: nil)
         self.tableView.register(categoryCellnib, forCellReuseIdentifier: "ShowCategoryTableViewCell")
        let noDataNib = UINib(nibName: "NoDataTableViewCell", bundle: nil)
        tableView.register(noDataNib, forCellReuseIdentifier: "NoDataTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    
    func loadCategoriesFromServer(_ page: Int,perPage:Int,keyword:String) -> Void {
        if !isSeconndTimeLoading{
            AppSettings.shared.showLoader(withStatus: "Loading..")
        }
           if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
               if self.page > 1{
                   self.page = self.page - 1
               }
            AppSettings.shared.hideLoader()
               return
           }
           self.isLoading = true
        LogInService.sharedInstance.getSubCategoriesFromServer(keyword: keyword, pageNumber: self.page, perPage: self.perPage) { (success, resCategory, responseMessage) in
            AppSettings.shared.hideLoader()
            self.isSeconndTimeLoading = true
               self.isLoading = false
               if let someCategory = resCategory{
                   if someCategory.count == 0{
                       if self.page > 1{
                           self.page = self.page - 1
                       }
                   }
                   self.categories.append(contentsOf:someCategory)
               }else{
                   if self.page > 1{
                       self.page = self.page - 1
                   }
               }
    
               self.tableView.reloadData()
           }
       }
    
    func getUserCompleteSessionData(){
        LogInService.sharedInstance.getUserCompleteSessionData { (success, resUser, message) in
            AppSettings.shared.hideLoader()
            if success{
                AppSettings.shared.proceedToDashboard()
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)

            }
        }
    }
    
    
                    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.pop(true)
    }
                    
    @IBAction func nextTapped(_ sender: Any) {
        if self.selectCatecory.count == 0 {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please select category or subcategory")
            return
        }
        self.updateSubCategoryArray()
    }
    
    
    func updateSubCategoryArray(){
        
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }
        AppSettings.shared.showLoader(withStatus: "Loading..")

        let IdArray = selectCatecory.compactMap({ $0.id })
        LogInService.sharedInstance.UpdateSubCategoriesToServer(subcategoriesArray: IdArray) { (success, resModel, message) in
            if success{
                self.getUserCompleteSessionData()

            }else{
                AppSettings.shared.hideLoader()

            }
        }

    }

    
    
    @IBAction func onClickSearchButton(_ sender:UIButton ){
//        let searchVC = AppStoryboard.Main.viewController(SearchCategoryViewController.self)
//        self.navigationController?.pushViewController(searchVC, animated: true)
        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)

        
    }
    
//    @IBAction func plusTapped(_ sender:Any) {
//        let emojiVC = AppStoryboard.Main.viewController(SelectSubCategoriesViewController.self)
//        emojiVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        let nav = UINavigationController(rootViewController: emojiVC)
//        nav.navigationBar.isHidden = true
//        nav.modalPresentationStyle = .overCurrentContext
//        nav.modalTransitionStyle = .crossDissolve
//        self.present(nav, animated: true, completion: nil)
//    }
          
}

extension SelectCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
                
    func numberOfSections(in tableView: UITableView) -> Int {

        return self.selectCatecory.count == 0 ? 1 : 2
    }
                    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
         return self.categories.count == 0 ? 1 : self.categories.count
        }else{
           return 1
        }
        
    }
                    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        if selectCatecory.count == 0{
            if indexPath.section == 0{
                height = 60
            }else{
              height =  0
            }
        }else{
            if indexPath.section == 0{
                height = 60
            }else{
              height =  200
            }
        }

        return height
//        let section = indexPath.section
//        switch section {
//            case 1:
//                return heightOfRows[section]
//
//            default:
//                return 50
//        }
    }
                    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let section = indexPath.section
        switch section {

            case 0:
                if self.categories.count == 0{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as! NoDataTableViewCell
                    cell.labelText.text = isLoading ? "Loading.." : "No data found"
                    return cell
                }else{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCategoryTableViewCell") as! ShowCategoryTableViewCell
                    let category = self.categories[indexPath.row]
                    cell.backgroundColor = appColor.backgroundAppColor
                    cell.titleLabel.text = category.title
                    cell.selectionStyle = .none
                    cell.selectButton.isSelected = category.isSelect
                    //
                    let isContains = self.selectCatecory.contains { (aCat) -> Bool in
                        return category.id == aCat.id
                    }
                    cell.selectButton.isSelected = isContains
                    //
                    
                    return cell
                }
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoriesTableViewCell") as! SelectCategoriesTableViewCell
                cell.backgroundColor = appColor.backgroundAppColor
                cell.collectionView.backgroundColor = appColor.backgroundAppColor
                cell.loadCategories(categories: self.selectCatecory)
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            
            default:
                 break
            }
        return UITableViewCell()

        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.categories.count == 0{return}
        
        let category = self.categories[indexPath.item]
        let isContains = self.selectCatecory.contains { (aCategory) -> Bool in
            return aCategory.id == category.id
        }
        
        if isContains{
            self.selectCatecory = selectCatecory.filter { $0.id != category.id}
        }else{
            selectCatecory.append(category)
        }

        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
        return 40
        }
        else {
            return 0
        }
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Dequeue with the reuse identifier
        var headerView : UIView?
        if section == 1{
            let nib = Bundle.main.loadNibNamed("SubCategoryHeader", owner: self, options: nil)
            let header = nib?[0] as! SubCategoryHeader
            header.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
            headerView = header
        }

      return headerView

    }

}


extension SelectCategoriesViewController:SelectCategoriesDelegate{
    func deleteCategory(contactCell cell: SelectCategoriesTableViewCell, indexPath: IndexPath, success: Bool, deleteCategory: CategoryModel) {
                if success{
                    
                self.selectCatecory.removeAll { (ct) -> Bool in
                    return ct.id == deleteCategory.id
                }
//
//            let indexOfCat = self.categories.firstIndex(where: { (cat) -> Bool in
//                return cat.id == deleteCategory.id
//            })
//            guard let index = indexOfCat else {
//                self.tableView.reloadData()
//                return
//            }
//            self.categories[index].isSelect = false
            self.tableView.reloadData()



        }
    }
    

    

    func selectCategories(contactCell cell: SelectCategoriesTableViewCell, selectIndex: Int, success: Bool) {
        if success{
            let category = self.categories[selectIndex]
            let emojiVC = AppStoryboard.Main.viewController(SelectSubCategoriesViewController.self)
            emojiVC.selectCategory = category
            emojiVC.delegate = self
            emojiVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            let nav = UINavigationController(rootViewController: emojiVC)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
}

extension SelectCategoriesViewController:SelectSubCategoriesViewControllerDeledate{
    func selectSubCategoriesViewController(viewController: UIViewController, selectCategories: [CategoryModel], success: Bool) {
             viewController.dismiss(animated: true, completion: nil)
           if success{
               
           }
    }

    
    
    
    
}



extension SelectCategoriesViewController: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSeachActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
//        if searchBar.text!.count==0{
//            self.keyword = ""
//            return
//        }
        AppSettings.shared.clearAllPendingRequests()
        self.page = 1
        isSeachActive = true
        self.isLoading = true
        self.categories.removeAll()
        self.tableView.reloadData()
        self.loadCategoriesFromServer(self.page, perPage: self.perPage, keyword: searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text!.count==0{
//            self.keyword = ""
//            return
//        }
        AppSettings.shared.clearAllPendingRequests()
        self.page = 1
        self.isLoading = true
        isSeachActive = true
        self.categories.removeAll()
        self.tableView.reloadData()
        self.loadCategoriesFromServer(self.page, perPage: self.perPage, keyword: searchBar.text!.lowercased())
    }
}



