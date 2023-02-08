//
//  AppDelegate.swift
//  ArtStation
//
//  Created by MamooN_ on 5/20/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import LiveChat
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?
     let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LiveChat.delegate = self
        GMSServices.provideAPIKey("AIzaSyAIcQipXb_CEgi9mICqe7FGmg9vUR3KBs0")
        GMSPlacesClient.provideAPIKey("AIzaSyAIcQipXb_CEgi9mICqe7FGmg9vUR3KBs0")
        GMSServices.provideAPIKey("AIzaSyAIcQipXb_CEgi9mICqe7FGmg9vUR3KBs0")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
          // [END set_messaging_delegate]
          // Register for remote notifications. This shows a permission dialog on first run, to
          // show the dialog at a more appropriate time move this registration accordingly.
          // [START register_for_notifications]
          if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: {_, _ in })
          } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
          }

          application.registerForRemoteNotifications()

        
        
        return true
    }
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
        bgTask = application.beginBackgroundTask(expirationHandler: { application.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskIdentifier.invalid
        })
    }


}

//implimnetion fcm push notificaiton
extension AppDelegate
{
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
       // If you are receiving a notification message while your app is in the background,
       // this callback will not be fired till the user taps on the notification launching the application.
       // TODO: Handle data of notification
       // With swizzling disabled you must let Messaging know about the message, for Analytics
       // Messaging.messaging().appDidReceiveMessage(userInfo)
       // Print message ID.
       if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
       }

       // Print full message.
       print(userInfo)
    
     }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       // If you are receiving a notification message while your app is in the background,
       // this callback will not be fired till the user taps on the notification launching the application.
       // TODO: Handle data of notification
       // With swizzling disabled you must let Messaging know about the message, for Analytics
       // Messaging.messaging().appDidReceiveMessage(userInfo)
       // Print message ID.
       if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
       }

       // Print full message.
       print(userInfo)
       completionHandler(UIBackgroundFetchResult.newData)
     }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print("Unable to register for remote notifications: \(error.localizedDescription)")
     }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            print("DeviceToken::::::: \(tokenString)")
        DataManager.setDeviceToken = tokenString
      
     }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // Print full message.
    print(userInfo)
    
    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
 
    let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
    let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window

   
    if userInfo["navigation_type"] as! String == "event"{
        if DataManager.getLanguage == Language.english.rawValue{
        homepageViewController.openWithIndex = 1
        }else{
            homepageViewController.openWithIndex = 2
        }
    }
    else{
        if DataManager.getLanguage == Language.english.rawValue{
   
        homepageViewController.openWithIndex = 3
        homepageViewController.openNotificationsPage = true
            
        }
        else{
            homepageViewController.openWithIndex = 0
            homepageViewController.openNotificationsPage = true
        }
    }
        
        
    window?.rootViewController = homepageViewController
    window?.makeKeyAndVisible()
      
    
    completionHandler()
  }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate  {
  // [START refresh_token]
 
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    DataManager.setFCMToken = fcmToken!
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
      
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  // [END refresh_token]
}

extension AppDelegate : LiveChatDelegate{
    
    func received(message: LiveChatMessage) {
        
        
        debugPrint(message.rawMessage, "LiveChat")
        if UIApplication.shared.applicationState == .background{
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "ArtStation"
            notificationContent.subtitle = "Message from agent"
            notificationContent.body = message.rawMessage.description
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(0), repeats: false)
            
            scheduleNotification(notificationContent: notificationContent, trigger: trigger, identifier: "LiveChatNotification")
        }
    }
    
    func chatDismissed() {
        //LiveChat.clearSession()
    }
 
    func scheduleNotification(notificationContent : UNMutableNotificationContent,trigger : UNTimeIntervalNotificationTrigger,identifier : String){
      
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
