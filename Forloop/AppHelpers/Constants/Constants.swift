//
//  Constants.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//


import UIKit

//to set the environment
let isDebugEnabled = true
//to set logs
let isLogEnabled = true

let Rs = "$ "

struct mapZoomLevel{
    static let max:Float = 19.0
    static let min:Float = 5.0
}





enum CallStatus:String{
    case initiated = "initiated"
    case ringing = "ringing"
    case completed = "completed"
    case picked = "in-progress"
    case busy = "busy"
}

struct appColor{
    
    static let backgroundAppColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    static let appBlueColor = UIColor(red: 136.0/255.0, green: 121.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    static let appGreenColor = UIColor(red: 73.0/255.0, green: 228.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    static let tabbarBackgroundColor = UIColor(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)

    
   
    static let gradientRedStart = UIColor(red: 255.0/255.0, green: 88.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    static let gradientRedEnd = UIColor(red: 255.0/255.0, green: 88.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    static let redShadow = UIColor(red: 255.0/255.0, green: 89.0/255.0, blue: 138.0/255.0, alpha: 1.0)
    static let bgColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    static let green = UIColor.green
    static let white = UIColor.white
    static let inactiveWhite = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 0.8)
    static let brown = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    static let gradientStart = UIColor(red: 44.0/255.0, green: 190.0/255.0, blue: 167.0/255.0, alpha: 1.0)
    static let gradientEnd = UIColor(red: 54.0/255.0, green: 72.0/255.0, blue: 216.0/255.0, alpha: 1.0)
    static let blue = UIColor.color(r: 51, g: 74, b: 219)
    static let gray = UIColor.color(r: 169, g: 167, b: 168)
    static let boxGray = UIColor.color(r: 148, g: 148, b: 148)
    static let splash = UIColor.color(r: 42, g: 121, b: 195)
    static let payoutRed = UIColor.color(r: 248, g: 24, b: 73)
    static let payoutBlue = UIColor.color(r: 69, g: 111, b: 245)
    static let lightGray = UIColor.groupTableViewBackground
    static let red = UIColor.red//UIColor.color(r:221, g:18, b:123)
    static let black = UIColor.black//UIColor.color(r:221, g:18, b:123)

}


struct gradientTextColor{
    static let start = UIColor(red: 35.0/255.0, green: 97.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    static let middle = UIColor(red: 42.0/255.0, green: 65.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    static let end = UIColor(red: 55.0/255.0, green: 32.0/255.0, blue: 208.0/255.0, alpha: 1.0)
}


let warningMessageShowingDuration = 1.25

extension UIColor{
    class func color(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat? = nil) -> UIColor{
        if let alp = alpha{
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alp)
        }else{
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        }
    }
}


/*============== NOTIFICATIONS ==================*/
extension NSNotification.Name {
    public static let USER_DID_LOGGED_IN_NOTIFICATION = NSNotification.Name("UserDidLoggedInNotification")
    public static let SESSION_EXPIRED_NOTIFICATION = NSNotification.Name("SESSION_EXPIRED_NOTIFICATION")

    public static let USER_DID_UPDATE_PROFILE_NOTIFICATION = NSNotification.Name("UserDidUpdateProfileNotification")
    
    public static let MESSAGE_UPDATE_NOTIFICATION = NSNotification.Name("MESSAGE_UPDATE_NOTIFICATION")

    public static let SCROLLING_UPDATE_SCREEN = NSNotification.Name("scrollingUpdateScreen")
    public static let USER_UPDATE_HOMEPAGE_DATA_NOTIFICATION = NSNotification.Name("userUpdateHomepageDataNotification")
    public static let DELIVERED_ORDER_NOTIFICATION = NSNotification.Name("deliveredOrderNotification")
    public static let ORDER_ASIGN_BY_ADMIN_NOTIFICATION = NSNotification.Name("deliveredOrderNotification")
    public static let USER_DID_ADD_NEW_CARD_NOTIFICATION = NSNotification.Name("UserDidAddNewCardNotification")
    public static let CUSTOM_NOTIFICATION = NSNotification.Name("customNotification")
    public static let LOCAL_TABBAR_RELOAD_NOTIFICATION = NSNotification.Name("localTabbarReloadNotification")

}


let kNotificationType = "notification_type"
let kRideAcceptedNotification = "ride_accepted"
let kRideRequestNotification = "ride_request"
let kRideCancelledNotification = "cancel_ride"
let kRideStartedNotification = "ride_started"
let kRideEndedNotification = "ride_ended"
let kDriverReachedNotification = "driver_reached"
let kDriverCancelledNotification = "driver_cancelled"
let kAdminAsignOrderNotification = "order_assigend"



enum NotificationType:String{
    case bookingCreatedByCustomerNotification = "customer_create_booking"
    case bookingCreatedByBusinessNotification = "business_create_booking"
    case bookingCancelledByBusinessNotification = "booking_cancel_by_business"
    case bookingCancelledByCustomerNotification = "booking_cancel_by_customer"
    case bookingCompletedByNotification = "booking_complete_by_business"
}


let kUserDefaults = UserDefaults.standard
/*========== SOME GLOBAL VARIABLE FOR USERS ==============*/

let kDeviceToken = "DeviceToken"
let kFirstLaunchAfterReset = "firstLaunchAfterReset"

//let kSupportEmail = "nakulsharma.1296@gmail.com"
//let kReportUsEmail = "nakulsharma.1296@gmail.com"

//let tollFreeNumber = "1-888-202-3625"
let appID = "1369497153"
//let adminCommission = 0.04

let rountingNumberDigit = 9
let accountNumberDigit = 12
let ssnDigit = 9



enum AddressCategory:String{
    case home = "Home"
    case work = "Work"
    case other = ""
    init(rawValue:String) {
        if rawValue.lowercased() == "home"{
            self = .home
        }else if rawValue.lowercased() == "work"{
            self = .work
        }else{
            self = .other
        }
    }
    func getIcon() -> UIImage{
        if self == .home{
            return #imageLiteral(resourceName: "home")
        }else if self == .work{
            return #imageLiteral(resourceName: "work")
        }else{
            return #imageLiteral(resourceName: "favorite_sel")
        }
    }
}




enum TicketStatus:String{
    case open = "open"
    case closed = "closed"
    case resolved = "resolved"
    init(rawValue:String) {
        if rawValue.lowercased() == "open"{
            self = .open
        }else if rawValue.lowercased() == "closed"{
            self = .closed
        }else{
            self = .resolved
        }
    }

    func getColor() -> UIColor{
        if self == .open{
            return UIColor(red: 179.0/255.0, green: 0, blue: 27.0/255.0, alpha: 1.0)
        }else if self == .closed{
            return UIColor(red: 16.0/255.0, green: 122.0/255.0, blue: 196.0/255.0, alpha: 1.0)
        }else{
            return UIColor(red: 16.0/255.0, green: 122.0/255.0, blue: 196.0/255.0, alpha: 1.0)
        }
    }
}


enum ErrorCode:Int{
    case success
    case failure
    case forceUpdate
    case normalUpdate
    case sessionExpire
    case previousDues
    case falseCondition
    //case accountSuspended
    case accountDeactivate


    init(rawValue:Int) {
        if rawValue == 102{
            self = .forceUpdate
        }else if rawValue == 101{
            self = .normalUpdate
        }else if  (rawValue == 345){
            self = .sessionExpire
        }else if rawValue == 303{
            self = .previousDues
        }else if ((rawValue >= 200) && (rawValue < 300)){
            self = .success
        }else if rawValue == 400{
            self = .falseCondition
        }
       // else if rawValue == 403{
       //     self = .accountSuspended
       // }
        else if rawValue == 420{
            self = .accountDeactivate
        }else{
            self = .failure
        }
    }
}


enum PayoutStatus:String{
    case paid
    case pending

    func getColor() -> UIColor{
        if self == .paid{
            return appColor.green
        }else{
            return appColor.payoutRed
        }
    }
    
    init(rawValue:String) {
        if rawValue.lowercased() == "paid"{
            self = .paid
        }else{
            self = .pending
        }
    }
}


enum appAction {
    case forgotPassword,login,signUp,editProfile
}


enum SelectUserRole:String{
    case pro = "pro"
    case learner = "learner"

}



/*================== API URLs ====================================*/
let inviteLinkUrl = ""
let appLink = isDebugEnabled ? "" : ""
let WEBSITE_URL = isDebugEnabled ? "" : ""
let apiVersion = "api/v1/"
let BASE_URL = "https://ekye3h3x7g.execute-api.us-west-2.amazonaws.com/dev/"

enum api: String {
    case signUp = "signup"
    case login = "login"
    case logout = "logout"
    case todayOrders = "order"
    case completeOrders = "completed/order"
    case deliverOrder = "delivered"
    case updateDeviceToken = "update/device"
    case getCategories = "categories"
    case getSubCategories = "subcategories"
    case updateSubCategories = "update/subcategories"
    case proUserListBySubCategory = "dashboard/subcategory/pros"
    case registerToken = "register/token"
    case searchProUsers = "search/pros"
   // case makeTwilloCall = "seeker/place/call"
    case getTwilloAccessToken = "twilio/access/token"
    case placeCall = "seeker/place/call"
    case getCapibilityToken = "twilio/capability/token"
    case newAccessToken = "accessToken"
    case getCallHistory = "call/history"
    case callInitiated = "call/initiated"
    case callConnected = "call/connected"
    case callPicked = "call/picked"
    case callEnded = "call/ended"
    case checkTwilloVerifyContact = "check/contact"
    case updateTwilloVerifyContact = "update/contact"
    case proDetail = "pro/details"
    case callDetails = "call/details"
    case proDashboard = "dashboard/pro"
    case addFavourite = "favourites/add"
    case favouritesList = "favourites/list"
    case callRating = "call/rating"
    case proRatingPagination = "pro/ratings"
    case dashboardSeekerCatagory = "dashboard/seeker/categories"
    case dashboardSeekerSubCatagory = "dashboard/seeker/subcategories"
    case dashboardSeekerTop = "dashboard/seeker/top"
    case deactivateAccount = "account/deactivate"


    

    case updatePic = "update/pic"
    case updateDetail = "update/profile"
    case updatelinks = "update/links"
    case updateCertificate = "update/details"
    case userSesssionData = "session/details"
    case selectUserRole = "update/role"
    
    case getCards = "seeker/cards"
    case addCard = "seeker/add/card"
    case defaultCard = "common/default/card"
    case removeCard = "common/remove/card"
    case createPayment = "common/create/payment"
    

    func url() -> String {
        return "\(BASE_URL)\(apiVersion)\(self.rawValue)"
    }
}

/*======================== CONSTANT MESSAGES ==================================*/
enum warningMessage : String{
    case updateVersion = "You are using a version of Ride app that\'s no longer supported. Please upgrade your app to the newest app version to use Ride App. Thanks!"
    case title = "Important Message"
    case setUpPassword = "Your password has updated successfully"
    case invalidPassword = "Please enter a valid password"
    case invalidPhoneNumber = "Please enter a valid phone number"
    case invalidFirstName = "Please enter a valid first name"
    case invalidLastName = "Please enter a valid last name"
    case invalidEmailAddress = "Please enter a valid email address"

    case emailCanNotBeEmpty = "Email address cann't be empty."
    case restYourPassword = "An email was sent to you to rest your password"
    case changePassword = "Your password has been changed successfully"
    case logoutMsg = "You've been logged out successfully"
    case networkIsNotConnected = "Network is not connected"
    case functionalityPending = "Under Development. Please ignore it"
    case enterPassword = "Please enter your password"
    case validPassword = "Please enter a valid password. Passwords should be 6-20 characters long."

    case enterOldPassword = "Please enter your current password"
    case validOldPassword = "Please enter a valid current password. Passwords should be 6-20 characters long."
    case enterNewPassword = "Please enter your new password"
    case validNewPassword = "Please enter a valid new password. Passwords should be 6-20 characters long."
    case confirmPassword = "Please confirm your password"
    case passwordDidNotMatch = "Please enter matching passwords"
    case cardDeclined = "The card was declined. Please reenter the payment details"
    case enterCVV = "Please enter the CVV"
    case enterValidCVV = "Please enter a valid CVV"
    case cardHolderName = "Please enter the card holder's name"
    case expMonth = "Please enter the exp. month"
    case expYear = "Please enter the exp. year"
    case validExpMonth = "Please enter a valid exp. month"
    case validExpYear = "Please enter a valid exp. year"
    case validCardNumber = "Please enter a valid card number"
    case cardNumber = "Please enter the card number"
    case sessionExpired = "Your session has expired, Please login again"
}


/*============== SOCIAL MEDIA URL SCHEMES ==================*/

let FACEBOOK_URL_SCHEME = "fb519181925378459"
let SELF_URL_SCHEME = "com.Tecorb.Forloop"
let SELF_IDENTIFIER = "forloopApp"
let stripeKey =  isDebugEnabled ? "pk_test_IS3Nmd85YwpaKFdJs7AWxhTR" : "pk_live_0S0mwMPzTPoidmEDPoZ0pMqp"
let GOOGLE_URL_SCHEME = "com.googleusercontent.apps.412359744553-5shkr04t1s6nnshssh8820ul9vu02141"
//let GOOGLE_API_KEY = "AIzaSyCPgGAqhaoo1JMGzxjoEWjxxBsHkbhtQOg"
let kGoogleClientId = "412359744553-5shkr04t1s6nnshssh8820ul9vu02141.apps.googleusercontent.com"
//let firebaseDatabaseUrl = "https://viyb-application.firebaseio.com"



/*============== PRINTING IN DEBUG MODE ==================*/
func print_debug <T>(_ object : T){
    if isLogEnabled{
        print(object)
    }
}

func print_log <T>(_ object : T){
//    NSLog("\(object)")
}



enum fontSize : CGFloat {
    case small = 11.0
    case smallPlusOne = 12.0
    case smallMedium = 14.0
    case medium = 15.0
    case large = 17.0
    case xLarge = 18.0
    case xXLarge = 20.0
    case xxLarge = 23.0
    case xXXLarge = 26.0
    case xXXXLarge = 32.0
}

   // Helvetica-Bold
    enum fonts {
       // Helvetica-Bold
        enum Roboto : String {
            case regular = "Roboto-Regular"
            case bold = "Roboto-Bold"
            case light = "Roboto-Light"
            case medium = "Roboto-Medium"
            func font(_ size : fontSize) -> UIFont {
                return UIFont(name: self.rawValue, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
            }
        }
    }
    

//uses of fonts
//let fo = fonts.OpenSans.regular.font(.xXLarge)

/*================= Database Roots ==============*/

//struct dataRoots
//{
//    struct refs
//    {
//        static let databaseRoot = Database.database().reference()
//        static let databaseChats = databaseRoot.child("chats")
//    }
//}


/*===================UIColor===========*/

extension UIColor{
    
    class func rgba(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ alpha:CGFloat? = nil) -> UIColor{
        if let alp = alpha{
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alp)
        }else{
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        }
    }
}

/*==============================================*/

/*==============================================*/






