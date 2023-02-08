//
//  Utils.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import UIKit
import SDWebImage
import LiveChat
import AVKit


struct Utils{
    static func getViewController<T:UIViewController>(storyboard:String,identifier:String,viewController:T.Type) -> T{
        debugPrint(storyboard,viewController)
     
        let vc = UIStoryboard.init(name: storyboard+UIManager.ifArabiclanguage(), bundle: Bundle.main).instantiateViewController(withIdentifier: identifier) as! T
            
          return vc
       
       
    }
    
    
    
    static func changeDateFormatTo(from : String,to format : String,date : String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = from
        let showDate = inputFormatter.date(from: date)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = format
        let resultString = outputFormatter.string(from: showDate!)
        return resultString
    }
    static func changeVisibilityOf(views : [UIView],isHidden : Bool){
        for view in views{
            view.isHidden = isHidden
        }
    }
    
    
 
    static func setImageTo(imageView : UIImageView,imageName : String,placeholderImage:String){
       let baseImageUrl = ConfigurationManager.shared.getBaseURLImage().absoluteString
        let url = URL(string: baseImageUrl + imageName)
        imageView.sd_setImage(with: url,placeholderImage: UIImage.init(named: placeholderImage))
    }
    
    static func setImageDirect(imageView : UIImageView,imageName : String,placeholderImage:String){
     
        let url = URL(string:imageName)
        imageView.sd_setImage(with: url,placeholderImage: UIImage.init(named: placeholderImage))
        
    }
    
    static let bookingStatusString = [BookingStatus.waitingForApproval : "Waiting for approval",.approved : "Approved",.paid : "Paid",.rejected : "Rejected",.reschedule : "Reschedule",.cancelled : "Cancelled"]
   
    static func logOut(){
        LiveChat.clearSession()
        let initialViewController = Utils.getViewController(storyboard: StoryboardId.authStoryBoardId, identifier: StoryboardId.authNavControllerId, viewController: UINavigationController.self)
        
        if let keyWindow = UIWindow.key {
            DataManager.setUserLog = "false"
            keyWindow.rootViewController = initialViewController
            keyWindow.rootViewController?.showAlert(title: "Alert", message: "Your session has expired")
        }
        DataManager.setCityForHomeData = nil
        DataManager.setUserData = nil
        DataManager.setLoginType = nil
    }
    
    
     static func localizedText(text:String)->String{
        
      if DataManager.getLanguage == "ar"
      {
        return   NSLocalizedString(text, tableName: UserDefaults.standard.string(forKey:DataManager.languagesKey), bundle: Bundle.main, value: text, comment: "")
      }
      else
      {
          return text
      }
     
    }
  
   static func localizedArabicNumber(stringV:String)
      ->String{
          return stringV
    /*
      if DataManager.getLanguage == "ar"
          {
          var text: String
          let someNumber = Float(stringV)
          let formatter = NumberFormatter()
          let gbLocale = NSLocale(localeIdentifier: "ar")
          formatter.numberStyle = NumberFormatter.Style.decimal
          formatter.locale = gbLocale as Locale
            text = formatter.string(from: someNumber as NSNumber? ?? 0) ?? ""
            return String(text.reversed())
          }
          else
          {
            return  stringV
          }
 */
          
  }
    
    static func showAlertWithIntroNavigation(title:String,info:String, viewController: UIViewController ,throughNavController: UINavigationController? )
     {
         DispatchQueue.main.async
         {
             var titleString: NSAttributedString = NSAttributedString(string: Utils.localizedText(text: title))
             var messageString: NSAttributedString = NSAttributedString(string: Utils.localizedText(text: info))
             if DataManager.getLanguage == Language.arabic.rawValue{
                 let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Almarai", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.black]
                 titleString = NSAttributedString(string: Utils.localizedText(text: title), attributes: titleAttributes)
                 let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "Almarai", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.black]
                 messageString = NSAttributedString(string: Utils.localizedText(text: info), attributes: messageAttributes)
               
             }else{
                 let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.black]
                 titleString = NSAttributedString(string: Utils.localizedText(text: title), attributes: titleAttributes)
                 let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.black]
                 messageString = NSAttributedString(string: Utils.localizedText(text: info), attributes: messageAttributes)
             }
             
         
            let popUp = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
          
          
             popUp.setValue(titleString, forKey: "attributedTitle")
             popUp.setValue(messageString, forKey: "attributedMessage")
                popUp.addAction(UIAlertAction(title: Utils.localizedText(text: "Cancel"), style: UIAlertAction.Style.default, handler: {alertAction in popUp.dismiss(animated: true, completion: nil)}))
                popUp.addAction(UIAlertAction(title: Utils.localizedText(text: "Continue"), style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
                    
                    DataManager.setUserLog="false"
                    DataManager.setUserAuth=""
                    DataManager.setUserData=nil
                    let vc = Utils.getViewController(storyboard: StoryboardId.authStoryBoardId, identifier: StoryboardId.authNavControllerId, viewController: UINavigationController.self)
                    if let keyWindow = UIWindow.key {
                        DataManager.setUserLog = "false"
                        keyWindow.rootViewController = vc
                    }
                                                
                            return
                    
                }))
                
            
           
         
         viewController.present(popUp, animated: true, completion: nil)
        
          }
     }
    
    static func playVideo(playerView : VideoPlayerView,videoURL : String){
       
            debugPrint("VideoPlaying",videoURL)
            var queuePlayer: AVQueuePlayer!
            let url = URL(string: videoURL)
            let httpHeaders = ["Authorization" :DataManager.getUserAuth ?? "","Range":"bytes=0-"]
            let asset = AVURLAsset(url: url!, options: ["AVURLAssetHTTPHeaderFieldsKey":httpHeaders])
            let playerItem = AVPlayerItem(asset: asset)
            queuePlayer = AVQueuePlayer(playerItem: playerItem)
            queuePlayer.isMuted = false
            playerView.playerLayer.player = queuePlayer
            playerView.playerLayer.videoGravity = .resizeAspectFill
            playerView.setLooper(item: playerItem)
            playerView.player?.play()
            playerView.isHidden = false
    }
    
    static func containsArabic(text: String) -> Bool{
        return NSPredicate(format: "SELF MATCHES %@", "'\\\\p{Arabic}'").evaluate(with: text)
    }

}


extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension String{
    var clean:String{
        return String(format: "%.0f", self)
    }
}
