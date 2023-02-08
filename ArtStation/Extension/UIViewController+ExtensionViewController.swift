//
//  UIViewController+ExtensionViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import UIKit
import EasyTipView

extension UIViewController{

    
    func showArtStationAlert(message: String,onOkTapped: (() -> Void)? = nil,alertType: ArtStationAlert.AlertType){
        let alertView = ArtStationAlert(frame: view.frame)
        alertView.message = message
        alertView.onOkButtonTapped = onOkTapped
        alertView.alpha = 0
        alertView.alertType = alertType
        view.addSubview(alertView)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCurlUp, animations: {
            alertView.alpha = 1
        }, completion: nil)
        
    }
    
    func showArtStationForceupdateAlert(okbtnTitle:String,canclebtnTitle:String,message: String,onOkTapped: (() -> Void)? = nil,alertType: ArtStationForceUpdateAlertView.ForceupdateAlertType){
        let alertView = ArtStationForceUpdateAlertView(frame: view.frame)
        alertView.message = message
        alertView.onOkButtonTapped = onOkTapped
        alertView.alpha = 0
        alertView.alertType = alertType
        alertView.oKButton.setTitle(okbtnTitle, for: .normal)
        alertView.noThnks.setTitle(canclebtnTitle, for: .normal)
        view.addSubview(alertView)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCurlUp, animations: {
            alertView.alpha = 1
        }, completion: nil)
    }
    
    func showAlert(title :String,message:String,completionHandler : (() -> Void)? = nil,onOkTapped : (() -> Void)? = nil,alertType: ArtStationAlert.AlertType = .error){
        showArtStationAlert(message: message, onOkTapped: onOkTapped,alertType: alertType)
    }
    
    func showForceUpdateAlert(okbtnTitle:String,cancelbtnTitle:String,title :String,message:String,completionHandler : (() -> Void)? = nil,onOkTapped : (() -> Void)? = nil,alertType: ArtStationForceUpdateAlertView.ForceupdateAlertType = .Forceupdate){
        showArtStationForceupdateAlert(okbtnTitle:okbtnTitle, canclebtnTitle: cancelbtnTitle,message: message, onOkTapped: onOkTapped,alertType: alertType)
    }
    
    
    func showSysmtemAlert(title :String,message:String,completionHandler : (() -> Void)? = nil,onOkTapped : (() -> Void)? = nil){
        
        var titleString: NSAttributedString = NSAttributedString(string: Utils.localizedText(text: title))
        var messageString: NSAttributedString = NSAttributedString(string: Utils.localizedText(text: message))
        if DataManager.getLanguage == Language.arabic.rawValue{
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Almarai", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            titleString = NSAttributedString(string: Utils.localizedText(text: title), attributes: titleAttributes)
            let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "Almarai", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            messageString = NSAttributedString(string: Utils.localizedText(text: message), attributes: messageAttributes)
          
        }else{
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            titleString = NSAttributedString(string: Utils.localizedText(text: title), attributes: titleAttributes)
            let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            messageString = NSAttributedString(string: Utils.localizedText(text: message), attributes: messageAttributes)
        }
        
        let alert = UIAlertController(title:"", message:"", preferredStyle: .alert)
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")
    
        alert.addAction(UIAlertAction(title: Utils.localizedText(text: "OK"), style: .default, handler: { action in
              switch action.style{
              case .default:
                onOkTapped?()
                break

              case .cancel:
                break

              case .destructive:
                break

              @unknown default:
                break
              }}))
        self.present(alert, animated: true, completion: completionHandler)
    }
    
    
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }

    func hideKeyboardWhenTappedAround() {
       let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
   }
   
   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
    

}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
