//
//  ArtStationTabViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/2/21.
//

import UIKit

protocol ArtStationTabBarDelegate{
    func onItemChanged(itemName : String)
}
class ArtStationTabViewController: UITabBarController,UITabBarControllerDelegate {
    
    
    let tabBarTitlesEnglish = ["Home","My events","Design Package","My profile","More"]
    var tabBarTitlesArabic = ["المزيد","ملفي الشخصي","صمم باقتك","مناسباتي","الصفحه الرئيسيه"]
    var kBarHeight : CGFloat = 60
    var tabBarDelegate: ArtStationTabBarDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        let tabbar = self.tabBar as! CustomTabBar
        tabbar.prominentButtonCallback = prominentTabTaped
        
        tabbar.clipsToBounds = false
        
        delegate = self
        
        let tabBarTintColor = UIColor(named: "tabbar_item_tint")
        tabBar.unselectedItemTintColor = tabBarTintColor?.withAlphaComponent(0.5)
        tabBar.tintColor = tabBarTintColor
        
        if DataManager.getLanguage == Language.arabic.rawValue
        {
            self.selectedIndex = 4
        }
        else
        {
            self.selectedIndex = 0
        }
    }
    
    func prominentTabTaped() {
        if DataManager.getUserLog == "guest"{
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
        }else{
            self.selectedIndex = 2
        }
    }
    
    func updateSelection() {
        let normalFont = UIFont(name: "Almarai-Bold", size: 12)!
        let selectedFont = UIFont(name: "Almarai-Bold", size: 12)!
        viewControllers?.forEach {
            let selected = $0 == self.selectedViewController
            $0.tabBarItem.setTitleTextAttributes([.font: selected ? selectedFont : normalFont], for: .normal)
        }
        debugPrint("FontUpdated")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarViews()
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        self.tabBarDelegate?.onItemChanged(itemName: item.title ?? "")
        updateSelection()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if DataManager.getUserLog == "guest"
            && (viewController == self.viewControllers![1]
                || viewController == self.viewControllers![2] || viewController == self.viewControllers![3]){
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
            return false
        }
        else{
            let userDetails = DataManager.getUserData!
            if DataManager.getLoginType == "social" && (userDetails.city == "0" || userDetails.phone == "0") {
                showAlert(title: "Alert", message: "Please enter your phone number to complete your registration", completionHandler: nil, onOkTapped: nil)
                return false
            }
            
            else{
                if viewController != self.selectedViewController{
                    setupTabBarViews()
                    
                    return true
                }
                else{
                    return true
                }
            }
        }
<<<<<<< HEAD
        
        
=======
>>>>>>> MR_freature_updates-temp
    }
    
    func setupTabBarViews(){
        
        if DataManager.getLanguage == Language.arabic.rawValue
        {
            for i in 0..<tabBar.items!.count{
                debugPrint("TabbarFontSet")
                
                tabBar.items![i].title = tabBarTitlesArabic[i]
            }
            
            return
        }
        
        for i in 0..<tabBar.items!.count{
            //            if tabBar.items![i] != tabBar.selectedItem{
            //               // tabBar.items![i].title = ""
            //            }else{
            tabBar.items![i].title = tabBarTitlesEnglish[i]
            //   }
        }
    }
}
