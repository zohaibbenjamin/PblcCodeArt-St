//
//  UIManager.swift
//  ArtStation
//
//  Created by Apple on 14/06/2021.
//

import Foundation
import MBProgressHUD
struct UIManager {
    
    static func ifArabiclanguage()->String
    {
        print(DataManager.getLanguage)
        if DataManager.getLanguage == "ar"
        {
            return "_ar"
        }
        else
        {
            return ""
        }
    }
    
    
    static func makeShadow(view:UIView){
               view.layer.shadowColor = UIColor.gray.cgColor
               view.layer.shadowOpacity = 0.5
               view.layer.shadowOffset = CGSize.zero
               view.layer.shadowRadius = 5
    }
    
    static func makeShadow2(view:UIView){
         view.layer.shadowColor = UIColor.gray.cgColor
         view.layer.shadowOpacity = 0.2
         view.layer.shadowOffset = CGSize.zero
         view.layer.shadowRadius = 5
      }
      
    
    static func showCustomActivityIndicator(controller: UIViewController?, withMessage: String?){
         if let controller = controller{
             let hud = MBProgressHUD.showAdded(to: controller.view, animated: true)
            // hud.customView = UIImageView(image: <#T##UIImage?#>)
           //  hud.mode = MBProgressHUDMode
             hud.animationType = MBProgressHUDAnimation.fade
             
             let animation = CABasicAnimation(keyPath: "transform.rotation")
                       animation.fromValue = 0.0
                       animation.toValue = 2.0 * Double.pi
                       animation.duration = 1
                       animation.repeatCount = HUGE
                       animation.isRemovedOnCompletion = false
             hud.customView?.layer.add(animation, forKey: "rotationAnimation")
         }
     }
     
    
    static func hideCustomActivityIndicator(controller : UIViewController?){
         
         DispatchQueue.main.async() { () -> Void in
             if controller != nil{
                 MBProgressHUD.hide(for: controller!.view, animated: true)
             }
         }
     }
     
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
  
    
    var maxNumberOfLines: Int {
            let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
            let text = (self.text ?? "") as NSString
            let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
            let lineHeight = font.lineHeight
            return Int(ceil(textHeight / lineHeight))
        }
}

extension UIColor
{
   static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
