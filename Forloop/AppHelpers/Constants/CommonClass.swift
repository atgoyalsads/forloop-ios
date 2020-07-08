//
//  CommonClass.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//


import UIKit
import SystemConfiguration
import AWSCognitoIdentityProvider
import AWSMobileClient

let loaderSize = CGSize(width: 120, height: 120)

let screenWidth = UIScreen.main.bounds.width

enum ImageAction: String {
    case Update = "update"
    case Remove = "remove"
    case None = ""
}



class CommonClass: NSObject {
    
    static let sharedInstance = CommonClass()
    override init() {
        super.init()
    }
    

    
    func awsBackendMessageHandel(error:AWSMobileClientError) -> String{
           var mess = ""
           switch(error) {
           case .userNotConfirmed(let message),
                   .aliasExists(let message),
                    .badRequest(let message),
                    .codeDeliveryFailure(let message),
                    .codeMismatch(let message),
                    .cognitoIdentityPoolNotConfigured(let message),
                    .deviceNotRemembered(let message),
                    .errorLoadingPage(let message),
                    .expiredCode(let message),
                    .expiredRefreshToken(let message),
                    .federationProviderExists(let message),
                    .groupExists(let message),
                    .guestAccessNotAllowed(let message),
                    .idTokenAndAcceessTokenNotIssued(let message),
                    .idTokenNotIssued(let message),
                    .identityIdUnavailable(let message),
                    .internalError(let message),
                    .invalidConfiguration(let message),
                    .invalidLambdaResponse(let message),
                    .invalidOAuthFlow(let message),
                    .invalidParameter(let message),
                    .invalidPassword(let message),
                    .invalidState(let message),
                    .invalidUserPoolConfiguration(let message),
                    .limitExceeded(let message),
                    .mfaMethodNotFound(let message),
                    .notAuthorized(let message),
                    .notSignedIn(let message),
                    .passwordResetRequired(let message),
                    .resourceNotFound(let message),
                    .scopeDoesNotExist(let message),
                    .securityFailed(let message),
                    .softwareTokenMFANotFound(let message),
                    .tooManyFailedAttempts(let message),
                    .tooManyRequests(let message),
                    .unableToSignIn(let message),
                    .unexpectedLambda(let message),
                    .unknown(let message),
                    .userCancelledSignIn(let message),
                    .userLambdaValidation(let message),
                    .userNotFound(let message),
                    .userPoolNotConfigured(let message),
                    .usernameExists(let message):
                    mess = message
           default:
               NKToastHelper.sharedInstance.showErrorAlert(nil, message: "\(error)")
           }
           
           return mess

       }
    
    
    func removeStartingWithExtra(userName:String)->String {
        var user = ""
        user = userName
        if user.trimmingCharacters(in: .whitespaces).count == 0{
            return ""
        }
        let trimmedString = user.replacingOccurrences(of: "^@+", with: "", options: .regularExpression)
        user = trimmedString
        return user
    }

    
    func setLeftIconForTextField(_ textField:UITextField,leftIcon: UIImage){
        let leftImageView = UIImageView()
        leftImageView.image = leftIcon
        let imgFrame = textField.frame
        leftImageView.frame = CGRect(x: 5, y: 5, width: imgFrame.size.height-10, height:imgFrame.size.height-10)
        textField.leftView = leftImageView
        textField.leftViewMode = UITextField.ViewMode.always
    }

    class func dateWithString(_ dateString: String) -> String {

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale.autoupdatingCurrent
        dayTimePeriodFormatter.timeZone = TimeZone.autoupdatingCurrent

        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dfs = dateString.replacingOccurrences(of: "T", with: " ")
        let dArray  = dfs.components(separatedBy: ".")
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let myTimeZone = TimeZone.current

        if dArray.count>0{
            if let d = dayTimePeriodFormatter.date(from: dArray[0]) as Date?{
                dayTimePeriodFormatter.dateFormat = "hh:mm a, dd-MMM-YYYY"
                //let date = dayTimePeriodFormatter.string(from: d)
                let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: d)
                let destinationGMTOffset = myTimeZone.secondsFromGMT(for: d)
                let interval = destinationGMTOffset - sourceGMTOffset!
                let destinationDate = Date(timeInterval: TimeInterval(interval), since: d)
                dayTimePeriodFormatter.dateFormat = "EEE, MMM dd, h:mm a"
                dayTimePeriodFormatter.timeZone = myTimeZone
                let formattedDate = dayTimePeriodFormatter.string(from: destinationDate)
                return formattedDate//date
            }
        }
        return " "
    }

    class func scheduleTimeString(_ timeStamp: Int) -> String {

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale.autoupdatingCurrent
        dayTimePeriodFormatter.timeZone = TimeZone.autoupdatingCurrent
        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"

        let seconds = timeStamp/1000
        let date = Date(timeIntervalSince1970: Double(seconds))
        dayTimePeriodFormatter.dateFormat = "EEE, MMM dd, h:mm a"
        let formattedDate = dayTimePeriodFormatter.string(from: date)
        return formattedDate
    }
    
    class func validateMaxValue(_ textField: UITextField, maxValue: Double, range: NSRange, replacementString string: String) -> Bool{

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        //if delete all characteres from textfield
        if(newString.isEmpty) {
            return true
        }
        //check if the string is a valid number
        let numberValue = Double(newString)
        if(numberValue == nil) {
            return false
        }
        return numberValue! <= maxValue
    }

    class func validateMinValue(_ textField: UITextField, minValue: Double, range: NSRange, replacementString string: String) -> Bool{

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        //if delete all characteres from textfield
        if(newString.isEmpty) {
            return true
        }
        //check if the string is a valid number
        let numberValue = Double(newString)
        if(numberValue == nil) {
            return false
        }
        return numberValue! >= minValue
    }


    class func validateMaxLength(_ textField: UITextField, maxLength: Int, range: NSRange, replacementString string: String) -> Bool{
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }

    





    func showGotoLocationSettingAlert(in viewController: UIViewController,completionBlock:@escaping(_ isEnabling:Bool)->Void){
        let alert = UIAlertController(title: "Opps", message: "Location access seems disabled\r\nGo to settings to enabled", preferredStyle: UIAlertController.Style.alert)
        let okayAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            completionBlock(false)
            alert.dismiss(animated: true, completion: nil)
        }

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            completionBlock(true)
            let url = UIApplication.openSettingsURLString
                if UIApplication.shared.canOpenURL(URL(string: url)!){
                    UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                }
        }

        alert.addAction(okayAction)
        alert.addAction(settingsAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    let colors: [UIColor] = [
        UIColor.red,
        UIColor.green,
        UIColor.blue,
        UIColor.orange,
        UIColor.yellow
    ]


//    class func presentControllerWithShadow(_ viewController:UIViewController, overViewController presentingViewController: UIViewController,completion: (() -> Void)?){
//        imgV.alpha = 0.3
//        presentingViewController.modalPresentationStyle = .custom
//        presentingViewController.navigationController?.navigationBar.addSubview(imgV)
//        presentingViewController.present(viewController, animated: true, completion: completion)
//    }
//    class func dismissWithShadow(_ viewController:UIViewController,completion: (() -> Void)?){
//        imgV.removeFromSuperview()
//        viewController.dismiss(animated: true, completion: completion)
//    }

    class func makeViewCircular(_ view:UIView, borderColor:UIColor? = .clear, borderWidth:CGFloat? = 0)
    {
        view.layer.borderColor = (borderColor ?? .clear).cgColor
        view.layer.borderWidth = borderWidth ?? 0
        view.layer.cornerRadius = view.frame.size.width/2
        view.layer.masksToBounds = true
    }
    
    class func makeViewCircularWithRespectToHeight(_ view:UIView,borderColor:UIColor,borderWidth:CGFloat)
    {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = view.frame.size.height/2
        view.layer.masksToBounds = true
    }
    
    class func makeViewRound(_ view:UIView,cornerRadius:CGFloat,borderColor:UIColor,borderWidth:CGFloat)
       {
           view.layer.borderColor = borderColor.cgColor
           view.layer.borderWidth = borderWidth
           view.layer.cornerRadius = cornerRadius
           view.layer.masksToBounds = true
       }


    class func makeViewCircularWithCornerRadius(_ view:UIView,borderColor:UIColor,borderWidth:CGFloat, cornerRadius: CGFloat)
    {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    class func makeViewShadowCornerRadius(_ view:UIView,shadowColor:UIColor,shadowWidth:CGFloat, shadowRadius: CGFloat,shadowOpacity:Float) {
        
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
        view.layer.masksToBounds = false
    }




     func setPlaceHolder(_ textField: UITextField, placeHolderString placeHolder: String, withColor color: UIColor){
        let p = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : color])
        textField.attributedPlaceholder = p;
    }

    class var isRunningSimulator: Bool
        {
        get
        {
            return TARGET_OS_SIMULATOR != 0
        }
    }




    class func formattedDateWithString(_ dateString: String,format :String) -> String {
        //"dd-MMM-YYYY, hh:mm a"
        //"EEEE dd-MMM-YYYY h:mm a"
        //"hh:mm a, dd-MMM-YYYY"
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale.autoupdatingCurrent
        dayTimePeriodFormatter.timeZone = TimeZone.autoupdatingCurrent

        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dfs = dateString.replacingOccurrences(of: "T", with: " ")
        let dArray  = dfs.components(separatedBy: ".")
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let myTimeZone = TimeZone.current

        if dArray.count>0{
            if let d = dayTimePeriodFormatter.date(from: dArray[0]) as Date?{
                dayTimePeriodFormatter.dateFormat = "hh:mm a, dd-MMM-yyyy"
                let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: d)
                let destinationGMTOffset = myTimeZone.secondsFromGMT(for: d)
                let interval = destinationGMTOffset - sourceGMTOffset!
                let destinationDate = Date(timeInterval: TimeInterval(interval), since: d)
                dayTimePeriodFormatter.dateFormat = format
                dayTimePeriodFormatter.timeZone = myTimeZone
                let formattedDate = dayTimePeriodFormatter.string(from: destinationDate)
                return formattedDate//date
            }
        }
        return " "
    }


    class func formattedDateWithTimeStamp(_ timeStamp: Double,format:String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateStyle = .medium
        dayTimePeriodFormatter.locale = Locale.current
        dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.dateFormat = format
        let formattedDate = dayTimePeriodFormatter.string(from: date)
        return formattedDate
    }


//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    NSArray *arrayOfPathComponents = [NSArray arrayWithObjects: [imageCache defaultCachePathForKey:imageUrlString],[imageCache cachedFileNameForKey:imageUrlString],nil];
//    NSString* path = [NSString pathWithComponents: arrayOfPathComponents];
//    NSURL *urlOfTheLocalFile = [NSURL fileURLWithPath: path];

//    class func urlOfTheFileOnLocal(imageUrl:String)->URL{
//        let imagecache = SDImageCache.shared()
//        let jj = imagecache.cach
//        let arrayOfPathComponents = [imagecache?.defaultCachePath(forKey: imageUrl)]
//    }

    
    class func formattedCompletedTaskDateWithString(_ dateStr: String,timeStr:String) -> String {
        //"dd-MMM-YYYY, hh:mm a"
        //"EEEE dd-MMM-YYYY h:mm a"
        //"hh:mm a, dd-MMM-YYYY"

        let dateString = "\(dateStr)T\(timeStr):00.000Z"

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale.autoupdatingCurrent
        dayTimePeriodFormatter.timeZone = TimeZone.autoupdatingCurrent

        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dfs = dateString.replacingOccurrences(of: "T", with: " ")
        let dArray  = dfs.components(separatedBy: ".")
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let myTimeZone = TimeZone.current

        if dArray.count>0{
            if let d = dayTimePeriodFormatter.date(from: dArray[0]) as Date?{
                dayTimePeriodFormatter.dateFormat = "hh:mm a, dd-MMM-YYYY"
                //let date = dayTimePeriodFormatter.string(from: d)
                let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: d)
                let destinationGMTOffset = myTimeZone.secondsFromGMT(for: d)
                let interval = destinationGMTOffset - sourceGMTOffset!
                let destinationDate = Date(timeInterval: TimeInterval(interval), since: d)
                dayTimePeriodFormatter.dateFormat = "hh:mm a, dd MMM YYYY"
                dayTimePeriodFormatter.timeZone = myTimeZone
                let formattedDate = dayTimePeriodFormatter.string(from: destinationDate)
                return formattedDate//date
            }
        }
        return " "
    }


    class func shortSelectedDate(_ fromDate:Date, toDate: Date)->(fromDate: Date,toDate:Date){
        if fromDate.compare(toDate) == ComparisonResult.orderedDescending{
            return (toDate,fromDate)
        }else{
            return (fromDate,toDate)
        }
    }

    func formattedDateWith(_ date:Date,format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = format
        let da = dateFormatter.string(from: date)
        return da
    }



    class func formattedTimeFromDateWith(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.defaultDate = date
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let da = "\(dateFormatter.string(from: date)) UTC"
        return da
    }


    class func formattedDateForSubmittionFromDateWith(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.defaultDate = date
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let da = dateFormatter.string(from: date)
        return da
    }



    class func getModifiedDateFromDateString(_ dateString: String) -> String
    {

        let df  = DateFormatter()
        df.locale = Locale.autoupdatingCurrent
        df.timeZone = TimeZone.autoupdatingCurrent
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: dateString)!
        df.dateFormat = "dd-MM-YY"
        return df.string(from: date);
    }

    class func getDateFromDateString(_ dateString: String) -> Date{
        let df  = DateFormatter()
        df.locale = Locale.autoupdatingCurrent
        df.timeZone = TimeZone.autoupdatingCurrent
        df.dateFormat = "YYYY-MM-dd"
        if let date = df.date(from: dateString){
            return date
        }
        return Date()
    }

    class func getDateFromDateString(_ dateString: String, format:String) -> Date{
        let df  = DateFormatter()
        df.locale = Locale.autoupdatingCurrent
        df.timeZone = TimeZone.autoupdatingCurrent
        df.dateFormat = format
        if let date = df.date(from: dateString){
            return date
        }
        return Date()
    }

    //MARK:- Email Validation
    class func isValidEmailAddress(_ emailStr: String) -> Bool
    {
        if((emailStr.isEmpty) || emailStr.count == 0)
        {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        if(emailPredicate.evaluate(with: emailStr)){
            return true
        }
        return false
    }
    class func validateUserName(_ username: String) -> Bool {

        let MINIMUM_LENGTH_LIMIT_USERNAME = 1
        let MAXIMUM_LENGTH_LIMIT_USERNAME = 20

        let nameRegex = "[a-zA-Z _.@ ]+$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)

        if username.count == 0
        {
            return false
        }

        else if username.count < MINIMUM_LENGTH_LIMIT_USERNAME
        {
            return false
        }

        else if username.count > MAXIMUM_LENGTH_LIMIT_USERNAME
        {
            return false
        }

        else if !nameTest.evaluate(with: username)
        {
            return false
        }

        else
        {
            return true
        }
    }

    //Password Validation
    class func validatePassword(_ password: String) -> Bool {

        let MINIMUM_LENGTH_LIMIT_PASSWORD = 6
        let MAXIMUM_LENGTH_LIMIT_PASSWORD = 20

        if password.count == 0
        {
            return false
        }
        else if password.first == " "
        {
            return false
        }
        else if password.count < MINIMUM_LENGTH_LIMIT_PASSWORD
        {
            return false
        }

        else if password.count > MAXIMUM_LENGTH_LIMIT_PASSWORD
        {
            return false
        }

        else
        {
            return true
        }
    }
    //SSN validation

    class func validateSSN(_ ssn:String) -> Bool{
        let ssnRegex = "^\\d{3}[-]\\d{2}[-]\\d{4}$"
        let ssnTest = NSPredicate(format: "SELF MATCHES %@", ssnRegex)
        if (ssn.count != 9){
            return false
        }else if !ssnTest.evaluate(with: ssn){
            return false
        }else{
            return true
        }
    }

    //Email Validation
    class func validateEmail(_ email : String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if email.count == 0
        {
            return false
        }
        else if !emailTest.evaluate(with: email)
        {
            return false
        }
        else
        {
            return true
        }
    }


    class func matchConfirmPassword(_ password :String , confirmPassword : String)-> Bool{


        if password==confirmPassword {
            return true
        }
        else{
            return false
        }
    }

    class func validatePhoneNumber(_ phone : String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phone.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phone == filtered
    }

    class func validateUserInputForPay(_ phone : String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        let inputString = phone.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phone == filtered
    }

    class func classNameAsString(_ obj: Any) -> String {
        return String(describing: type(of: obj)).components(separatedBy:"__").last!
    }

    

    class func setupNoDataView(_ tableView:UITableView,message:String){
        let bgView = UIView()
        bgView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        let noReviewLabel = UILabel()
        noReviewLabel.sizeToFit()
        bgView.addSubview(noReviewLabel)
        noReviewLabel.center = CGPoint(x:tableView.center.x, y:tableView.frame.size.height*1/2)
        noReviewLabel.textAlignment = NSTextAlignment.center
        noReviewLabel.text = message
        tableView.backgroundView = noReviewLabel
    }
    
    
    
    class func makeCircularTopRadius(_ view:UIView,cornerRadius:CGFloat){
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    class func makeCircularBottomRadius(_ view:UIView,cornerRadius:CGFloat){
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners =  [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    class func makeCircularCornerNewMethodRadius(_ view:UIView,cornerRadius:CGFloat){
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners =  [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    class func makeCircularTopLeftAndbottomRightCorner(_ view:UIView,cornerRadius:CGFloat){
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners =  [.layerMinXMinYCorner]
    }
    func checkString(_ name: String) -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits

        let decimalRange = name.rangeOfCharacter(from: decimalCharacters)

        if decimalRange != nil {
            return false
        }
        return true
    }

    func checkAlphabets(_ name: String ) -> Bool {
        let letters = CharacterSet.letters
        let range = name.rangeOfCharacter(from: letters)

        // range will be nil if no letters is found
       if range != nil {
            return false
        }
        return true
    }
}
