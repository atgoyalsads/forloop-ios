//
//  AppDelegate.swift
//  Forloop
//
//  Created by Tecorb on 03/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import AWSCore
import AWSCognitoIdentityProvider
import TwilioVoice
import AWSFacebookSignIn
import AWSGoogleSignIn
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import AWSMobileClient
import Fabric

let userPoolID = "us-west-2_7BKdwAKgn"

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var user = User()
    var cognitoConfig:CognitoConfig?
    let notificationCenter = UNUserNotificationCenter.current()

    class func defaultUserPool() -> AWSCognitoIdentityUserPool {
        return AWSCognitoIdentityUserPool(forKey: userPoolID)!
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NSLog("Twilio Voice Version: %@", TwilioVoice.sdkVersion())
        Fabric.sharedSDK().debug = true
        IQKeyboardManager.shared.enable = true
        self.launchApplicaton(userInfo: nil)
        self.cognitoConfig = CognitoConfig()
        
        // setup cognito
        setupCognitoUserPool()
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        self.registerForRemoteNotification()
        self.checkRecordPermission { (done) in
            
        }

        
        return true
    }
    
    
    func registerForRemoteNotification() {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil{
                DispatchQueue.main.async {
//                    Messaging.messaging().delegate = self
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func setupCognitoUserPool() {
        let clientId:String = self.cognitoConfig!.getClientId()
        let poolId:String = self.cognitoConfig!.getPoolId()
        let clientSecret:String = self.cognitoConfig!.getClientSecret()
        let region:AWSRegionType = self.cognitoConfig!.getRegion()
        
        let serviceConfiguration:AWSServiceConfiguration = AWSServiceConfiguration(region: region, credentialsProvider: nil)
        let cognitoConfiguration:AWSCognitoIdentityUserPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: clientId, clientSecret: clientSecret, poolId: poolId)
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: cognitoConfiguration, forKey: userPoolID)
//        let pool:AWSCognitoIdentityUserPool = AppDelegate.defaultUserPool()
//        pool.delegate = self
    }
    
    func launchApplicaton(userInfo:Dictionary<String,AnyObject>?){
        self.user = User.loadSavedUser()
         if AppSettings.shared.isLoggedIn{
            if self.user.selectedRole == "" {
                //AppSettings.shared.proceedToLoginModule()
                 self.checkTwilloVerifyContact()

            }else{
                //AppSettings.shared.proceedToDashboard()
                self.checkTwilloVerifyContact()
            }
            
         }else{
             AppSettings.shared.proceedToLoginModule()
            //self.checkTwilloVerifyContact()


         }
     }

    
     func checkTwilloVerifyContact(){
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(nil, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }

        AppSettings.shared.showLoader(withStatus: "Loading..")
        CallTwilloService.sharedInstance.checkContactForTwillo { (code, otp, message) in
            AppSettings.shared.hideLoader()
            if code == 200{
                if self.user.selectedRole == ""{
                    self.navigateToUSerSelectOption()
                }else{
                    AppSettings.shared.proceedToDashboard()
                }

            }else if code == 404{
                guard let navigationController = self.getWindowNavigation() else{return}
                let twilloContact = AppStoryboard.Contact.viewController(AddContactVerifyViewController.self)
                navigationController.pushViewController(twilloContact, animated: true)

                
            }else if code == 100{
                if let temp = otp{
                    guard let navigationController = self.getWindowNavigation() else{return}
                    let twilloContact = AppStoryboard.Contact.viewController(ContactVerifyDetailViewController.self)
                    twilloContact.otp = temp
                    navigationController.pushViewController(twilloContact, animated: true)
                    
                }

            }else{
                
            }
        }
    }
    
     func navigateToUSerSelectOption() {
        guard let navigationController = self.getWindowNavigation() else{return}
         let userRoleVC = AppStoryboard.Main.viewController(SelectUserRoleViewController.self)
         userRoleVC.isFromSignUp = true
         navigationController.pushViewController(userRoleVC, animated: true)
     }
    

    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Forloop")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate{

func getWindowNavigation()-> UINavigationController?{
     guard let window = self.window else {
         return nil
     }
     guard let nav = window.rootViewController as? UINavigationController else {
         return nil
     }
     return nav
 }

}

extension AppDelegate{
class func getAppDelegate() -> AppDelegate{
    
    return UIApplication.shared.delegate as! AppDelegate
}
}


extension AppDelegate{
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
         NotificationCenter.default.post(name: .CUSTOM_NOTIFICATION, object: nil, userInfo: nil)

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

extension AppDelegate{
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var result = false
        if url.scheme == GOOGLE_URL_SCHEME{
            result = GIDSignIn.sharedInstance().handle(url)
        }else if url.scheme == FACEBOOK_URL_SCHEME{
            result = ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return result
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var result = false
        if url.scheme == GOOGLE_URL_SCHEME{
            result = GIDSignIn.sharedInstance().handle(url)
        }else if url.scheme == FACEBOOK_URL_SCHEME{
            result = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }

        
        return result
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        
        completionHandler()
    }
    
    func scheduleNotification(code: String) {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let categoryIdentifire = "Delete Notification Type"
        
        content.title = "Verification Code"
        content.body = "Your verification code is " + code
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "Local Notification"
        //        let rwquss = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    
    func checkRecordPermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
        let permissionStatus: AVAudioSession.RecordPermission = AVAudioSession.sharedInstance().recordPermission
        
        switch permissionStatus {
        case AVAudioSessionRecordPermission.granted:
            // Record permission already granted.
            completion(true)
            break
        case AVAudioSessionRecordPermission.denied:
            // Record permission denied.
            completion(false)
            break
        case AVAudioSessionRecordPermission.undetermined:
            // Requesting record permission.
            // Optional: pop up app dialog to let the users know if they want to request.
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                completion(granted)
            })
            break
        default:
            completion(false)
            break
        }
    }
    

}

