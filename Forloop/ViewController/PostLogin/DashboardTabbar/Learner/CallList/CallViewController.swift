//
//  CallViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import PushKit
import CallKit
import TwilioVoice
import AVFoundation
import SDWebImage


class CallViewController: UIViewController {

    @IBOutlet weak var callerImage: UIImageView!
    @IBOutlet weak var callerName: UILabel!
    @IBOutlet weak var callDuration: UILabel!
    @IBOutlet weak var muteImage: UIImageView!
    @IBOutlet weak var muteLabel: UILabel!
    @IBOutlet weak var keypadImage: UIImageView!
    @IBOutlet weak var keypadLabel: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var addCallImage: UIImageView!
    @IBOutlet weak var addCallLabel: UILabel!
    @IBOutlet weak var videoCallImage: UIImageView!
    @IBOutlet weak var videoCallLabel: UILabel!
    @IBOutlet weak var callDisconnectButton: UIButton!
    
    var deviceTokenString: String?
    
    var voipRegistry: PKPushRegistry
    var incomingPushCompletionCallback: (()->Swift.Void?)? = nil

    var isSpinning: Bool = false
    var incomingAlertController: UIAlertController?

    var callKitCompletionCallback: ((Bool)->Swift.Void?)? = nil
    var audioDevice: TVODefaultAudioDevice = TVODefaultAudioDevice()
    var activeCallInvites: [String: TVOCallInvite]! = [:]
    var activeCalls: [String: TVOCall]! = [:]

    // activeCall represents the last connected call
    var activeCall: TVOCall? = nil

    let callKitProvider :  CXProvider
    let callKitCallController:   CXCallController
    var userInitiatedDisconnect: Bool = false
    

    let baseURLString = "https://ekye3h3x7g.execute-api.us-west-2.amazonaws.com/dev/api/v1"
    // If your token server is written in PHP, accessTokenEndpoint needs .php extension at the end. For example : /accessToken.php
    var accessTokenEndpoint = "/accessToken"
    var identity = "alice"
    let twimlParamTo = "To"
    var outgoingValue = "918527077987"
    
    var playCustomRingback: Bool = false
    var ringtonePlayer: AVAudioPlayer? = nil
    var call = CallHistoryModel()
    
    var refreshTime : Int = 0
    weak var refreshTimer: Timer?
    var user = User()
    var isVolumeShow:Bool = false
    
    var callTime:Int = 0
   weak var callTimer:Timer?
    
    
    required init?(coder aDecoder: NSCoder) {
        isSpinning = false
        voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)

        let configuration = CXProviderConfiguration(localizedName: "Quickstart")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
//        if let callKitIcon = UIImage(named: "iconMask80") {
//            configuration.iconTemplateImageData = callKitIcon.pngData()
//        }

        callKitProvider = CXProvider(configuration: configuration)
        callKitCallController = CXCallController()

        super.init(coder: aDecoder)

        callKitProvider.setDelegate(self, queue: nil)

        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
    }
    
    deinit {
        // CallKit has an odd API contract where the developer must call invalidate or the CXProvider is leaked.
        callKitProvider.invalidate()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.navigationItem.setHidesBackButton(true, animated:true)
        self.callerName.text = self.user.displayName//self.user.fname + " " + self.user.lname
        self.callerImage.sd_setImage(with: URL(string:self.user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "user_placeholder"))
          /*
           * The important thing to remember when providing a TVOAudioDevice is that the device must be set
           * before performing any other actions with the SDK (such as connecting a Call, or accepting an incoming Call).
           * In this case we've already initialized our own `TVODefaultAudioDevice` instance which we will now set.
           */
          TwilioVoice.audioDevice = audioDevice
          self.callAddProcceed()

       self.invalidateTimerAndSetItAgain()


    }
    
    override func viewDidLayoutSubviews() {
        CommonClass.makeCircularCornerNewMethodRadius(self.callerImage, cornerRadius: self.callerImage.frame.width/2)
                self.view.backgroundColor = appColor.appBlueColor

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deleteCallTimer()
        self.deleteTimer()
    }
    

    func invalidateTimerAndSetItAgain(){
        if callTimer != nil{
            self.callTimer?.invalidate()
            self.callTimer = nil
        }
        self.callTimer = Timer.scheduledTimer(timeInterval:3, target:self, selector:#selector(getCurrentCallDetails), userInfo: nil, repeats: true)

    }
    
    
    @objc func refreshCounter(){
        refreshTime += 1
        self.callDuration.text = "\(refreshTime)"


    }
    
    @IBAction func muteTapped(_ sender: Any) {
        print("mute")
//        let nextVC = AppStoryboard.Learner.viewController(CallExperienceViewController.self)
//            nextVC.call = self.call
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func keypadTapped(_ sender: Any) {
        print("keypad")
    }
    
    @IBAction func speakerTapped(_ sender: Any) {
        if self.isVolumeShow{
            self.toggleAudioRoute(toSpeaker: true)
        }else{
            self.toggleAudioRoute(toSpeaker: false)

        }
        print("Speaker")
        
    }
    
    @IBAction func addCallTapped(_ sender: Any) {
        //self.makeCallApi()

        print("Add Call")
    }
    
    @IBAction func videoCallTapped(_ sender: Any) {
        print("Video Call")
    }
    
    @IBAction func callDisconnectTapped(_ sender: Any) {

        if let call = self.activeCall {
            self.userInitiatedDisconnect = true
            performEndCallAction(uuid: call.uuid)
            print("Call Disconnect")

        }
        self.deleteTimer()
        self.navigateToCallExprienceScreen()
    }
//
//    func makeCallApi(){
//        if !AppSettings.isConnectedToNetwork{
//             NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
//             return
//         }
//
//        CallTwilloService.sharedInstance.placeCall(contactNumber: "+918527077987") { (value) in
//
//        }
//
//    }
    
    

    
    
    
    func callAddProcceed(){
            if let call = self.activeCall {
                self.userInitiatedDisconnect = true
                performEndCallAction(uuid: call.uuid)
            } else {
                let uuid = UUID()
                let handle = "Voice Bot"
                
                self.checkRecordPermission { (permissionGranted) in
                    if (!permissionGranted) {
                        let alertController: UIAlertController = UIAlertController(title: "Voice Quick Start",
                                                                                   message: "Microphone permission not granted",
                                                                                   preferredStyle: .alert)
                        
                        let continueWithMic: UIAlertAction = UIAlertAction(title: "Continue without microphone",
                                                                           style: .default,
                                                                           handler: { (action) in
                            self.performStartCallAction(uuid: uuid, handle: handle)
                        })
                        alertController.addAction(continueWithMic)
                        
                        let goToSettings: UIAlertAction = UIAlertAction(title: "Settings",
                                                                        style: .default,
                                                                        handler: { (action) in
                                                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                                                      options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false],
                                                      completionHandler: nil)
                        })
                        alertController.addAction(goToSettings)
                        
                        let cancel: UIAlertAction = UIAlertAction(title: "Cancel",
                                                                  style: .cancel,
                                                                  handler: { (action) in
                        })
                        alertController.addAction(cancel)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.performStartCallAction(uuid: uuid, handle: handle)
                    }
                }
            }
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

extension CallViewController:PKPushRegistryDelegate, TVONotificationDelegate, TVOCallDelegate, CXProviderDelegate, UITextFieldDelegate, AVAudioPlayerDelegate{
   
    func fetchAccessToken() -> String? {
       // return AppSettings.shared.twilloToken//self.accessTokenEndpoint
        
        let endpointWithIdentity = String(format: "%@?identity=%@", accessTokenEndpoint, identity)
        guard let accessTokenURL = URL(string: baseURLString + endpointWithIdentity) else {
            return nil
        }
        print("accessTokenURL >>>>>\(accessTokenURL)")

        let temp = try? String.init(contentsOf: accessTokenURL, encoding: .utf8)
        print("kjh >>>>>\(temp)")
        return temp//try? String.init(contentsOf: accessTokenURL, encoding: .utf8)
    }
    
    
    // MARK: PKPushRegistryDelegate
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        NSLog("pushRegistry:didUpdatePushCredentials:forType:")
        
        if (type != .voIP) {
            return
        }

        guard let accessToken = fetchAccessToken() else {
            return
        }
        
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()

        TwilioVoice.register(withAccessToken: accessToken, deviceToken: deviceToken) { (error) in
            print("AccessToken>>>\(accessToken)")
            print("DeviceToken>>>\(deviceToken)")

            if let error = error {
                NSLog("An error occurred while registering: \(error.localizedDescription)")
            }
            else {
                NSLog("Successfully registered for VoIP push notifications.")
            }
        }

        self.deviceTokenString = deviceToken
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        NSLog("pushRegistry:didInvalidatePushTokenForType:")
        
        if (type != .voIP) {
            return
        }
        
        guard let deviceToken = deviceTokenString, let accessToken = fetchAccessToken() else {
            return
        }
        
        TwilioVoice.unregister(withAccessToken: accessToken, deviceToken: deviceToken) { (error) in
            if let error = error {
                NSLog("An error occurred while unregistering: \(error.localizedDescription)")
            }
            else {
                NSLog("Successfully unregistered from VoIP push notifications.")
            }
        }
        
        self.deviceTokenString = nil
    }

    /**
     * Try using the `pushRegistry:didReceiveIncomingPushWithPayload:forType:withCompletionHandler:` method if
     * your application is targeting iOS 11. According to the docs, this delegate method is deprecated by Apple.
     */
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:")

        if (type == PKPushType.voIP) {
            // The Voice SDK will use main queue to invoke `cancelledCallInviteReceived:error:` when delegate queue is not passed
            TwilioVoice.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
        }
    }

    /**
     * This delegate method is available on iOS 11 and above. Call the completion handler once the
     * notification payload is passed to the `TwilioVoice.handleNotification()` method.
     */
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:completion:")

        if (type == PKPushType.voIP) {
            // The Voice SDK will use main queue to invoke `cancelledCallInviteReceived:error:` when delegate queue is not passed
            TwilioVoice.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
        }
        
        if let version = Float(UIDevice.current.systemVersion), version < 13.0 {
            // Save for later when the notification is properly handled.
            self.incomingPushCompletionCallback = completion
        } else {
            /**
            * The Voice SDK processes the call notification and returns the call invite synchronously. Report the incoming call to
            * CallKit and fulfill the completion before exiting this callback method.
            */
            completion()
        }
    }

    func incomingPushHandled() {
        if let completion = self.incomingPushCompletionCallback {
            completion()
            self.incomingPushCompletionCallback = nil
        }
    }

    // MARK: TVONotificaitonDelegate
    func callInviteReceived(_ callInvite: TVOCallInvite) {
        NSLog("callInviteReceived:")
        
        var from:String = callInvite.from ?? "Voice Bot"
        from = from.replacingOccurrences(of: "client:", with: "")

        // Always report to CallKit
        reportIncomingCall(from: from, uuid: callInvite.uuid)
        self.activeCallInvites[callInvite.uuid.uuidString] = callInvite
    }
    
    func cancelledCallInviteReceived(_ cancelledCallInvite: TVOCancelledCallInvite, error: Error) {
        NSLog("cancelledCallInviteCanceled:error:, error: \(error.localizedDescription)")
        
        if (self.activeCallInvites!.isEmpty) {
            NSLog("No pending call invite")
            return
        }
        
        var callInvite: TVOCallInvite?
        for (_, invite) in self.activeCallInvites {
            if (invite.callSid == cancelledCallInvite.callSid) {
                callInvite = invite
                break
            }
        }
        
        if let callInvite = callInvite {
            performEndCallAction(uuid: callInvite.uuid)
        }
    }

    // MARK: TVOCallDelegate
    func callDidStartRinging(_ call: TVOCall) {
        NSLog("callDidStartRinging:")
        
        
        /*
         When [answerOnBridge](https://www.twilio.com/docs/voice/twiml/dial#answeronbridge) is enabled in the
         <Dial> TwiML verb, the caller will not hear the ringback while the call is ringing and awaiting to be
         accepted on the callee's side. The application can use the `AVAudioPlayer` to play custom audio files
         between the `[TVOCallDelegate callDidStartRinging:]` and the `[TVOCallDelegate callDidConnect:]` callbacks.
        */
        if (self.playCustomRingback) {
            self.playRingback()
        }
    }
    
    func callDidConnect(_ call: TVOCall) {
        NSLog("callDidConnect:")
        
        if (self.playCustomRingback) {
            self.stopRingback()
        }
        self.callKitCompletionCallback!(true)
        toggleAudioRoute(toSpeaker: true)
//        self.callStatusWithServer(callID: self.call.id, status: CallStatus.picked.rawValue)
        self.refreshTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(refreshCounter), userInfo: nil, repeats: true)

        
    }
    
    func call(_ call: TVOCall, isReconnectingWithError error: Error) {
        NSLog("call:isReconnectingWithError:")

    }
    
    func callDidReconnect(_ call: TVOCall) {
        NSLog("callDidReconnect:")

    }
    
    func call(_ call: TVOCall, didFailToConnectWithError error: Error) {
        NSLog("Call failed to connect: \(error.localizedDescription)")
        
        if let completion = self.callKitCompletionCallback {
            completion(false)
        }

        performEndCallAction(uuid: call.uuid)
        callDisconnected(call)
    }
    
    func call(_ call: TVOCall, didDisconnectWithError error: Error?) {
        if let error = error {
            NSLog("Call failed: \(error.localizedDescription)")
        } else {
            NSLog("Call disconnected")
        }
        
        if !self.userInitiatedDisconnect {
            var reason = CXCallEndedReason.remoteEnded
            
            if error != nil {
                reason = .failed
            }
            
            self.callKitProvider.reportCall(with: call.uuid, endedAt: Date(), reason: reason)
        }

        callDisconnected(call)
    }
    
    func callDisconnected(_ call: TVOCall) {
        if (call == self.activeCall) {
            self.activeCall = nil
        }
        self.activeCalls.removeValue(forKey: call.uuid.uuidString)
        
        self.userInitiatedDisconnect = false
        
        if (self.playCustomRingback) {
            self.stopRingback()
        }
        self.navigateToCallExprienceScreen()
//        self.callStatusWithServer(callID: self.call.id, status: CallStatus.ended.rawValue)


    }
    
    
    // MARK: AVAudioSession
    func toggleAudioRoute(toSpeaker: Bool) {
        // The mode set by the Voice SDK is "VoiceChat" so the default audio route is the built-in receiver. Use port override to switch the route.
        audioDevice.block = {
            kTVODefaultAVAudioSessionConfigurationBlock()
            do {
                if (toSpeaker) {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                    self.speakerImage.image = UIImage(named: "speaker_mute")
                    self.isVolumeShow = false

                } else {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
                    self.speakerImage.image = UIImage(named: "speaker_icon")
                    self.isVolumeShow = true

                }
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        audioDevice.block()
    }



    // MARK: CXProviderDelegate
    func providerDidReset(_ provider: CXProvider) {
        NSLog("providerDidReset:")
        audioDevice.isEnabled = true
    }

    func providerDidBegin(_ provider: CXProvider) {
        NSLog("providerDidBegin")
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        NSLog("provider:didActivateAudioSession:")
        audioDevice.isEnabled = true
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        NSLog("provider:didDeactivateAudioSession:")
    }

    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        NSLog("provider:timedOutPerformingAction:")
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        NSLog("provider:performStartCallAction:")
        
//        self.callStatusWithServer(callID: self.call.id, status: CallStatus.connected.rawValue)
        audioDevice.isEnabled = false
        audioDevice.block();
        
        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
        
        self.performVoiceCall(uuid: action.callUUID, client: "") { (success) in
            if (success) {
                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
                action.fulfill()
            } else {
                action.fail()
            }
        }
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        NSLog("provider:performAnswerCallAction:")
        
        audioDevice.isEnabled = false
        audioDevice.block();
        
        self.performAnswerVoiceCall(uuid: action.callUUID) { (success) in
            if (success) {
                action.fulfill()
            } else {
                action.fail()
            }
        }
        
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        NSLog("provider:performEndCallAction:")
        
        if let invite = self.activeCallInvites[action.callUUID.uuidString] {
            invite.reject()
            self.activeCallInvites.removeValue(forKey: action.callUUID.uuidString)
        } else if let call = self.activeCalls[action.callUUID.uuidString] {
            call.disconnect()
        } else {
            NSLog("Unknown UUID to perform end-call action with")
        }

        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        NSLog("provider:performSetHeldAction:")
        
        if let call = self.activeCalls[action.callUUID.uuidString] {
            call.isOnHold = action.isOnHold
            action.fulfill()
        } else {
            action.fail()
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        NSLog("provider:performSetMutedAction:")

        if let call = self.activeCalls[action.callUUID.uuidString] {
            call.isMuted = action.isMuted
            action.fulfill()
        } else {
            action.fail()
        }
    }

    // MARK: Call Kit Actions
    func performStartCallAction(uuid: UUID, handle: String) {
        let callHandle = CXHandle(type: .generic, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
        let transaction = CXTransaction(action: startCallAction)

        callKitCallController.request(transaction)  { error in
            if let error = error {
                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
                return
            }

            NSLog("StartCallAction transaction request successful")

            let callUpdate = CXCallUpdate()
            callUpdate.remoteHandle = callHandle
            callUpdate.supportsDTMF = true
            callUpdate.supportsHolding = true
            callUpdate.supportsGrouping = false
            callUpdate.supportsUngrouping = false
            callUpdate.hasVideo = false

            self.callKitProvider.reportCall(with: uuid, updated: callUpdate)
        }
    }

    func reportIncomingCall(from: String, uuid: UUID) {
        let callHandle = CXHandle(type: .generic, value: from)

        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = callHandle
        callUpdate.supportsDTMF = true
        callUpdate.supportsHolding = true
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.hasVideo = false

        callKitProvider.reportNewIncomingCall(with: uuid, update: callUpdate, completion: { error in
            if let error = error {
                NSLog("Failed to report incoming call successfully: \(error.localizedDescription).")
            } else {
                NSLog("Incoming call successfully reported.")
            }
        })
 
    }

    func performEndCallAction(uuid: UUID) {

        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)

        callKitCallController.request(transaction) { error in
            if let error = error {
                NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
            } else {
                NSLog("EndCallAction transaction request successful")
            }
        }
    }
    
    func performVoiceCall(uuid: UUID, client: String?, completionHandler: @escaping (Bool) -> Swift.Void) {
        guard let accessToken = fetchAccessToken() else {
            completionHandler(false)
            return
        }
        

        let connectOptions: TVOConnectOptions = TVOConnectOptions(accessToken: accessToken) { (builder) in
            
            builder.params = [self.twimlParamTo : self.outgoingValue]

            builder.uuid = uuid
        }
        let call = TwilioVoice.connect(with: connectOptions, delegate: self)
        self.activeCall = call
        self.activeCalls[call.uuid.uuidString] = call
        self.callKitCompletionCallback = completionHandler
        
    }
    
    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Swift.Void) {
        if let callInvite = self.activeCallInvites[uuid.uuidString] {
            let acceptOptions: TVOAcceptOptions = TVOAcceptOptions(callInvite: callInvite) { (builder) in
                builder.uuid = callInvite.uuid
            }
            let call = callInvite.accept(with: acceptOptions, delegate: self)
            self.activeCall = call
            self.activeCalls[call.uuid.uuidString] = call
            self.callKitCompletionCallback = completionHandler
            
            self.activeCallInvites.removeValue(forKey: uuid.uuidString)
            
            guard #available(iOS 13, *) else {
                self.incomingPushHandled()
                return
            }
        } else {
            NSLog("No CallInvite matches the UUID")
        }
    }
    
    // MARK: Ringtone
    func playRingback() {
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "ringtone", ofType: "wav")!)
        do {
            self.ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            self.ringtonePlayer?.delegate = self
            self.ringtonePlayer?.numberOfLoops = -1

            self.ringtonePlayer?.volume = 1.0
            self.ringtonePlayer?.play()
        } catch {
            NSLog("Failed to initialize audio player")
        }
    }
    
    func stopRingback() {
        if (self.ringtonePlayer?.isPlaying == false) {
            return
        }

        self.ringtonePlayer?.stop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (flag) {
            NSLog("Audio player finished playing successfully");
        } else {
            NSLog("Audio player finished playing with some error");
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        NSLog("Decode error occurred: \(error?.localizedDescription)");
    }
    
}

extension CallViewController{

//func callStatusWithServer(callID:String,status:String){
//    if self.call.callStatus == CallStatus.ended.rawValue{
//        let nextVC = AppStoryboard.Learner.viewController(CallExperienceViewController.self)
//            nextVC.call = self.call
//        self.navigationController?.pushViewController(nextVC, animated: true)
//        return
//    }
////
//    CallListService.sharedInstance.getCallStatus(callID: callID, status: status) { (success, resCall, message) in
//           AppSettings.shared.hideLoader()
//           if success{
//               if let someCall = resCall{
//                   self.call = someCall
//                if self.call.callStatus == CallStatus.ended.rawValue{
//                    self.deleteTimer()

//
//                }
//
//               }
//           }else{
//           }
//       }
//
//   }
    
    @objc func getCurrentCallDetails(){
        self.loadCallDetailApi(callID: self.call.id)
    }
    
    func loadCallDetailApi(callID:String){
        CallListService.sharedInstance.getCallDetails(callID: callID) { (success, resCall, message) in
            if success{
                if let someCall = resCall{
                    if (someCall.callStatus == CallStatus.busy.rawValue) || (someCall.callStatus == CallStatus.completed.rawValue){
                        self.call = someCall
                        self.deleteCallTimer()
                        self.toggleAudioRoute(toSpeaker: false)
                        self.navigateToCallExprienceScreen()
                    }
                }
                
            }
        }
    }
    
    
    
    func navigateToCallExprienceScreen(){
        if (UIApplication.shared.windows.first?.rootViewController?.topViewController is CallExperienceViewController) {
        return
       }
        let nextVC = AppStoryboard.Learner.viewController(CallExperienceViewController.self)
        nextVC.call = self.call
        nextVC.receriverUser = self.user
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func deleteTimer(){
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
    }
    
    func deleteCallTimer(){
        self.callTimer?.invalidate()
        self.callTimer = nil
    }
}
