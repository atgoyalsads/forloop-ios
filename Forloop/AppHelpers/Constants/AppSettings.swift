//
//  AppSettings.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//

import CoreFoundation
import UIKit
import SystemConfiguration
import CoreTelephony
import CoreLocation
import SwiftyJSON
import SVProgressHUD
import Alamofire
class AppSettings {

    static let shared = AppSettings()
    fileprivate init() {}


    func getNavigation(vc:UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isOpaque = false
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: fonts.Roboto.bold.font(.xXLarge),NSAttributedString.Key.foregroundColor:UIColor.black]
        nav.clearShadowLine()
        nav.navigationBar.backgroundColor = .white
        return nav
    }

    func prepareHeader(withAuth:Bool) -> Dictionary<String,String>{
        let accept = "application/json"
        var header = Dictionary<String,String>()
       // header.updateValue("ios", forKey: "deviceType")
        header.updateValue(accept, forKey: "Content-Type")
       // header.updateValue("123abc000xyz", forKey: "deviceId")

//        if let deviceID = kUserDefaults.value(forKey: kDeviceToken) as? String {
//            header.updateValue(deviceID, forKey: "deviceToken")
//        }else{
//            header.updateValue("--", forKey: "deviceToken")
//        }

        if withAuth{
            //let user = User.loadSavedUser()
            let userToken = AppSettings.shared.sessionToken
            header.updateValue(userToken, forKey: "sessionToken")
        }
        return header
    }
    
    func prepareHeaderAfterLogin(withAuth:Bool)-> Dictionary<String,String>{
        let accept = "application/json"
        var header = Dictionary<String,String>()
        header.updateValue("ios", forKey: "deviceType")
        if let deviceID = kUserDefaults.value(forKey: kDeviceToken) as? String {
            header.updateValue(deviceID, forKey: "deviceToken")
        }else{
            header.updateValue("--", forKey: "deviceToken")
        }
        header.updateValue(accept, forKey: "Content-Type")
        if withAuth{
            let user = User.loadSavedUser()
            let userToken = user.sessionToken
            header.updateValue(userToken, forKey: "sessionToken")
        }
        return header
    }
    

    class var isConnectedToNetwork: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    

    var twilloToken : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:"twilloToken") as? String{
                result = r
            }
            return result
        }
        set(newDefaultStartDate){
            kUserDefaults.set(newDefaultStartDate, forKey: "twilloToken")
            kUserDefaults.synchronize()
        }
    }

    

    var isLoggedIn: Bool{
        get {
            var result = false
            if let r = kUserDefaults.bool(forKey:kIsLoggedIN) as Bool?{
                result = r
            }
            return result
        }

        set(newIsLoggedIn){
            kUserDefaults.set(newIsLoggedIn, forKey: kIsLoggedIN)
            kUserDefaults.synchronize()
        }
    }
    
//    var isProFirstTimeStatus: Bool{
//        get {
//            var result = false
//            if let r = kUserDefaults.bool(forKey:kIsLearner) as Bool?{
//                result = r
//            }
//            return result
//        }
//        
//        set(newIsLoggedIn){
//            kUserDefaults.set(newIsLoggedIn, forKey: kIsLearner)
//            kUserDefaults.synchronize()
//        }
//    }

    var isRegistered: Bool{
        get {
            var result = false
            if let r = kUserDefaults.bool(forKey:kIsRegistered) as Bool?{
                result = r
            }
            return result
        }
        set(newIsRegistered){
            kUserDefaults.set(newIsRegistered, forKey: kIsRegistered)
            kUserDefaults.synchronize()
        }
    }

    var loginCount: Int{
        get {
            var result = 0
            if let r = kUserDefaults.integer(forKey:kLoginCount) as Int?{
                result = r
            }
            return result
        }

        set(newLoginCount){
            kUserDefaults.set(newLoginCount, forKey: kLoginCount)
            kUserDefaults.synchronize()
        }
    }

    var isFirstTimeLogin: Bool{
        get {
            var result = false
            if let r = kUserDefaults.bool(forKey:kIsFirstTimeLogin) as Bool?{
                result = r
            }
            return result
        }
        set(newIsFirstTimeLogin){
            kUserDefaults.set(newIsFirstTimeLogin, forKey: kIsFirstTimeLogin)
            kUserDefaults.synchronize()
        }
    }

    var interestedInLoginWithTouchID: Bool{
        get {
            var result = false
            if let r = kUserDefaults.bool(forKey:kInterestedInLoginWithTouchID) as Bool?{
                result = r
            }
            return result
        }
        set(newInterestedInLoginWithTouchID){
            kUserDefaults.set(newInterestedInLoginWithTouchID, forKey: kInterestedInLoginWithTouchID)
            kUserDefaults.synchronize()
        }
    }

    var isLoginWithTouchIDEnable: Bool{
        get {
            var result = false
            if let r = kUserDefaults.bool(forKey:kIsLoginWithTouchIDEnable) as Bool?{
                result = r
            }
            return result
        }
        set(newLoginWithTouchIDEnable){
            kUserDefaults.set(newLoginWithTouchIDEnable, forKey: kIsLoginWithTouchIDEnable)
            kUserDefaults.synchronize()
        }
    }
    var isNotificationEnable: Bool{
        get {
            var result = false
            if let r = kUserDefaults.bool(forKey:kIsNotificationsEnable) as Bool?{
                result = r
            }
            return result
        }
        set(newIsNotificationEnable){
            kUserDefaults.set(newIsNotificationEnable, forKey: kIsNotificationsEnable)
            kUserDefaults.synchronize()

        }
    }

    var isIntroShown: Bool{
        get {
            var result = false
            if let r = kUserDefaults.bool(forKey:"kIsIntroShown") as Bool?{
                result = r
            }
            return result
        }
        set(newIsIntroShown){
            kUserDefaults.set(newIsIntroShown, forKey: "kIsIntroShown")
            kUserDefaults.synchronize()
        }
    }

    var currentCountryCode:String{
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders?["home"]{
            let countryCode = carrier.isoCountryCode
            return countryCode ?? "US"
        }else{
            return Locale.autoupdatingCurrent.regionCode ?? "US"
        }
    }

    var deviceToken : String {
        get {
            var result = "test_token"
            if let r = kUserDefaults.value(forKey:"deviceToken") as? String{
                result = r
            }
            return result
        }
    }
    
    
    var sessionToken : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:kSessionToken) as? String{
                result = r
            }
            return result
        }
        set(newkSessionToken){
            kUserDefaults.set(newkSessionToken, forKey: kSessionToken)
            kUserDefaults.synchronize()
        }
    }

    var previousRatedVersion : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:kPreviousRatedVersion) as? String{
                result = r
            }
            return result
        }
        set(newpreviousRatedVersion){
            kUserDefaults.set(newpreviousRatedVersion, forKey: kPreviousRatedVersion)
            kUserDefaults.synchronize()
        }
    }

    func shouldOpenLocationAndCalendar()->Bool{
        return (self.defaultStartDate.count == 0 || self.defaultEndDate.count == 0 || self.defaultStartTime.count == 0 || self.defaultEndTime.count == 0 || self.selectedPickupLocation.count == 0)
    }

    var defaultStartDate : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:"defaultStartDate") as? String{
                result = r
            }
            return result
        }
        set(newDefaultStartDate){
            kUserDefaults.set(newDefaultStartDate, forKey: "defaultStartDate")
            kUserDefaults.synchronize()
        }
    }

    var selectedPickupLocation : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:"selectedPickupLocation") as? String{
                result = r
            }
            return result
        }
        set(newDefaultStartDate){
            kUserDefaults.set(newDefaultStartDate, forKey: "selectedPickupLocation")
            kUserDefaults.synchronize()
        }
    }

    func getSelectedDates()->(startDate:Date, endDate: Date){
        
        let startDate = CommonClass.getDateFromDateString(defaultStartDate, format:"MMM dd, YYYY")
        let endDate = CommonClass.getDateFromDateString(defaultEndDate, format:"MMM dd, YYYY")
        return (startDate:startDate, endDate: endDate)
    }

    var selectedPickupLocationCoordinates : CLLocationCoordinate2D{
        get {
            var result = CLLocationCoordinate2D()
            if let lat = kUserDefaults.value(forKey:"newSelectedPickupLocationLat") as? Double{
                if let long = kUserDefaults.value(forKey:"newSelectedPickupLocationLong") as? Double{
                    result = CLLocationCoordinate2D(latitude: lat, longitude: long)
                }
            }
            return result
        }
        set(newSelectedPickupLocationCoordinates){
            kUserDefaults.set(newSelectedPickupLocationCoordinates.latitude, forKey: "newSelectedPickupLocationLat")
            kUserDefaults.set(newSelectedPickupLocationCoordinates.longitude, forKey: "newSelectedPickupLocationLong")
            kUserDefaults.synchronize()
        }
    }

    var defaultEndDate : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:"defaultEndDate") as? String{
                result = r
            }
            return result
        }
        set(newDefaultEndDate){
            kUserDefaults.set(newDefaultEndDate, forKey: "defaultEndDate")
            kUserDefaults.synchronize()
        }
    }

    var defaultStartTime : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:"defaultStartTime") as? String{
                result = r
            }
            return result
        }
        set(newDefaultStartTime){
            kUserDefaults.set(newDefaultStartTime, forKey: "defaultStartTime")
            kUserDefaults.synchronize()
        }
    }

    

    var defaultEndTime : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:"defaultEndTime") as? String{
                result = r
            }
            return result
        }
        set(newDefaultEndTime){
            kUserDefaults.set(newDefaultEndTime, forKey: "defaultEndTime")
            kUserDefaults.synchronize()
        }
    }


    var isFirstLaunchAfterReset : Bool {
        get {
            var result = true
            if let r = kUserDefaults.value(forKey:kFirstLaunchAfterReset) as? String{
                if r.isEmpty || r.count == 0{
                    result = true
                }else{
                    result = false
                }
            }else{
                result = true
            }
            return result
        }
    }




    var shouldShowLeftMenuProfile : Bool {
        get {
            var result = false

            if let r = kUserDefaults.bool(forKey:kShouldShowLeftMenuProfile) as Bool?{
                result = r
            }
            return result
        }
        set(newShouldShowRatingPopUp){
            kUserDefaults.set(newShouldShowRatingPopUp, forKey: kShouldShowLeftMenuProfile)
            kUserDefaults.synchronize()
        }
    }

//cedential

    var passwordEncrypted : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:kPasswordEncrypted) as? String{
                result = r
            }
            return result
        }
        set(newPasswordEncrypted){

            kUserDefaults.set(newPasswordEncrypted, forKey: kPasswordEncrypted)
        }
    }

    var phoneNumber : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:kPhoneNumber) as? String{
                result = r
            }
            return result
        }
        set(newPhoneNumber){
            kUserDefaults.set(newPhoneNumber, forKey: kPhoneNumber)
            kUserDefaults.synchronize()

        }
    }


    var countryCode : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:kCountryCode) as? String{
                result = r
            }
            return result
        }
        set(newCountryCode){
            kUserDefaults.set(newCountryCode, forKey: kCountryCode)
            kUserDefaults.synchronize()

        }
    }

    var selectedLanguageCode : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:kSelectedLanguageCode) as? String{
                result = r
            }
            if result == ""{
                result = "en"
            }
            return result
        }
        set(newSelectedLanguageCode){
            kUserDefaults.set(newSelectedLanguageCode, forKey: kSelectedLanguageCode)
            kUserDefaults.synchronize()

        }
    }

    var selectedLanguageName : String {
        guard let r = kUserDefaults.value(forKey:kSelectedLanguageCode) as? String else{return "English"}

        if r == "fr" {return "French"}else{return "English"}
    }

    var languageBundle: Bundle{
        let pathForResource = Bundle.main.path(forResource: self.selectedLanguageCode, ofType: "lproj")!
        let myLangBundle = Bundle(path: pathForResource)
        return myLangBundle!
    }




    func resetOnFirstAppLaunch(){
        self.isLoginWithTouchIDEnable = false
        self.interestedInLoginWithTouchID = true
        self.isLoggedIn = false
        self.isRegistered = false
        self.isNotificationEnable = true
       // self.isIntroShown = false
        kUserDefaults.set("\(Date.timeIntervalSinceReferenceDate)", forKey:kFirstLaunchAfterReset)
    }

    func resetOnLogout() {
        self.isLoggedIn = false
        self.isFirstTimeLogin = false
        self.isIntroShown = true
        //self.isLoginWithTouchIDEnable = false
       // User().saveUserJSON(JSON.init(Data()))
    }



    func proceedToDashboard(completionBlock :(() -> Void)? = nil){

         let navigationController = AppStoryboard.Dashboard.viewController(DashboardNavigationController.self)
                  AppDelegate.getAppDelegate().window?.rootViewController = navigationController
                  guard let handler = completionBlock else{return}
                  handler()
        //
        
//        let navigationController = AppStoryboard.Dashboard.viewController(DashboardNavigationController.self)
//        if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow }){
//            UIView.transition(with: window, duration: 0.2, options: .beginFromCurrentState, animations: {
//                        AppDelegate.getAppDelegate().window?.rootViewController = navigationController
//                    }, completion: { completed in
//                        guard let handler = completionBlock else{return}
//                        handler()
//                    })
//              }



    }
    
    
    
    func proceedToLoginModule(completionBlock :(() -> Void)? = nil){
         self.isLoggedIn = false
          let navigationController = AppStoryboard.Main.viewController(MainNavigationController.self)
         AppDelegate.getAppDelegate().window?.rootViewController = navigationController
     }
    
    func proceedToAddContactScreen(completionBlock :(() -> Void)? = nil){
        let navigationController = AppStoryboard.Contact.viewController(CantactNavigationViewController.self)
         AppDelegate.getAppDelegate().window?.rootViewController = navigationController
     }
    
    func proceedToTwilloVerifyScreen(completionBlock :(() -> Void)? = nil){
        let navigationController = AppStoryboard.Contact.viewController(CantactNavigationViewController.self)
         AppDelegate.getAppDelegate().window?.rootViewController = navigationController
     }

    typealias presentComplitionHandler = (() -> Void)?

    func presentLoginModule(in viewController: UIViewController, animated:Bool=true, _ complitionHandler: presentComplitionHandler = nil) {
        self.isLoggedIn = false

    }

    func getFullError(errorString:String,andresponse data:Data?) -> String{
        var message:String = errorString
        if let somedata = data, let serverStr = String(data: somedata, encoding: String.Encoding.utf8){
            message = message+"\n"+serverStr
        }
        return message
    }
    
    func showSessionExpireAndProceedToLandingPage(){
//        self.hideLoader()
        NKToastHelper.sharedInstance.showErrorAlert(nil, message: warningMessage.sessionExpired.rawValue, completionBlock: {
           // self.proceedToLoginModule()
        })
    }
    
    func accountDeactivateAndShowToLoginPage(message:String){
                self.hideLoader()
        NKToastHelper.sharedInstance.showErrorAlert(nil, message: message, completionBlock: {
            self.proceedToLoginModule()
        })
    }
    

    func showForceUpdateAlert(){
//        self.hideLoader()
        let alert = UIAlertController(title: warningMessage.title.rawValue, message: warningMessage.updateVersion.rawValue, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "Update Now", style: .cancel) {[alert] (action) in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)"),
                UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: {[alert] (done) in
                    alert.dismiss(animated: false, completion: nil)
                })
            }
        }
        alert.addAction(updateAction)
        let toastShowingVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        toastShowingVC?.present(alert, animated: true, completion: nil)
    }



    //=====Loader showing methods==========//
    func showLoader()
    {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(appColor.appBlueColor)
        SVProgressHUD.setMinimumSize(loaderSize)
        SVProgressHUD.show()
    }


    var isLoaderOnScreen: Bool
    {
        return SVProgressHUD.isVisible()
    }
    func showError(withStatus status: String)
    {
        SVProgressHUD.showError(withStatus: status)
    }
    func showSuccess(withStatus status: String)
    {
        SVProgressHUD.showSuccess(withStatus: status)
    }


    func showLoader(withStatus status: String)
    {
        if SVProgressHUD.isVisible(){
            SVProgressHUD.setStatus(status)
            SVProgressHUD.setMinimumSize(loaderSize)
        }else{
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setBackgroundLayerColor(UIColor.white.withAlphaComponent(0.9))
            SVProgressHUD.setBackgroundColor(UIColor.white.withAlphaComponent(0.9))
            SVProgressHUD.setForegroundColor(appColor.appBlueColor)
            SVProgressHUD.setMinimumSize(loaderSize)
            SVProgressHUD.show(withStatus: status)
            SVProgressHUD.setImageViewSize(loaderSize)
        }

    }

    func updateLoader(withStatus status: String)
    {
        SVProgressHUD.setStatus(status)
        SVProgressHUD.setMinimumSize(loaderSize)
    }

    func hideLoader()
    {
        if SVProgressHUD.isVisible(){
            SVProgressHUD.dismiss()
        }
    }

    func clearAllPendingRequests(){
        Alamofire.SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel()
            }
        }
    }

    func clearLastPendingRequests(){
        Alamofire.SessionManager.default.session.getAllTasks { tasks in
            if let lastTask = tasks.last{
                lastTask.cancel()
            }
        }
    }

//====To open location setting of the application
    func openLocationSetting(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            })
        }
    }


    func getNavigationDefaultHeight() -> CGFloat{
        if UIDevice.isIphoneX{
            return 105
        }else{
            return 64
        }
    }
    //==========User Avatar Image
    func userAvatarImage(username:String) -> UIImage{
        let configuration = LetterAvatarBuilderConfiguration()

        configuration.username = (username.trimmingCharacters(in: .whitespaces).count == 0) ? "NA" : username.uppercased()
        configuration.lettersColor = UIColor.black
        configuration.singleLetter = false
        configuration.lettersFont = fonts.Roboto.bold.font(.xXLarge)
        configuration.backgroundColors = [UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.white]
        return UIImage.makeLetterAvatar(withConfiguration: configuration) ?? UIImage(named:"profile")!
    }

    func showGotoLocationSettingAlert(in viewController:UIViewController){
        let alert = UIAlertController(title: "Opps", message: "Location access seems disabled\r\nGo to settings to enable", preferredStyle: UIAlertController.Style.alert)
        let okayAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            let url = UIApplication.openSettingsURLString
            if UIApplication.shared.canOpenURL(URL(string: url)!){
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }
        }

        alert.addAction(okayAction)
        alert.addAction(settingsAction)
        viewController.present(alert, animated: true, completion: nil)
    }


//==========Keys=========//
    let kIsLearner = "is_learner"
    let kIsLoggedIN = "is_logged_in"
    let kIsRegistered = "isRegistered"
    let kIsFirstTimeLogin = "isFirstTimeLogin"
    let kLoginCount = "loginCount"
    let kIsAuthourisedForSession = "isAuthourisedForSession"
    let kShouldShowLeftMenuProfile = "shouldShowLeftMenuProfile"
    let kPreviousRatedVersion = "previousRatedVersion"
    let kPasswordEncrypted = "passwordEncrypted"
    let kPhoneNumber = "phoneNumber"
    let kCountryCode = "countryCode"
    let kInterestedInLoginWithTouchID = "interestedInLoginWithTouchID"
    let kIsLoginWithTouchIDEnable = "isLoginWithTouchIDEnable"
    let kIsNotificationsEnable = "isNotificationsEnable"
    let kIsIntroShown = "isIntroShown"
    let kSelectedLanguageCode = "SelectedLanguageCode"
    let kSessionToken = "sessionToken"


//==========End of Keys=========//
}




