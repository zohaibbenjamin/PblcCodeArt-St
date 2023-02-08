//
//  MoreViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/30/21.
//

import UIKit
import LiveChat


class MoreViewController: UIViewController {

    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var languageSwitch: UISwitch!
    @IBOutlet weak var signOutButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    let viewModel = AppSettingsViewModel()
    @IBOutlet weak var singOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLanguageChanged(_ sender: Any) {
      
        var selectedLanguage: String?
        if let languageSwitch = sender as? UISwitch{
            if languageSwitch.isOn{
                selectedLanguage = Language.arabic.rawValue
            }
            else{
                selectedLanguage = Language.english.rawValue
            }
            
            if DataManager.getUserLog == "guest"{
                DataManager.setLanguage = selectedLanguage
                onLanguageChangedSuccess()
            }
            else{
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            viewModel.changeAppLanguage(selectedLanguage: selectedLanguage!, onCompletionCallback: {
                success,errorString in
                UIManager.hideCustomActivityIndicator(controller: self)
                if success{
                    self.onLanguageChangedSuccess()
                }else{
                    self.showAlert(title: "Alert", message: errorString ?? "")
                }
            })
            }
        }
    }
    
    func onLanguageChangedSuccess(){
        let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
    
    if let keyWindow = UIWindow.key {
        keyWindow.rootViewController = homepageViewController
    }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func termsAndConditions(_ sender: Any) {
      
//        if DataManager.getUserLog == "guest"
//        {
//            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
//            return
//        }
//
        let vc = Utils.getViewController(storyboard: StoryboardId.moreStoryboard, identifier: StoryboardId.termsPolicyControllerId, viewController: TermsPolicyViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func setupUI(){
        if DataManager.getLanguage == Language.arabic.rawValue{
            languageSwitch.isOn = true
        
        }else{
            languageSwitch.isOn = false
        }
        singOutButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor(named: "sign_out_color")!, borderRadius: 17, borderColor:  UIColor(named: "sign_out_color")!, borderWidth: 2)
        notificationSwitch.isOn = DataManager.getNotificationFlag
        if DataManager.getUserLog == "guest"{
            notificationButton.isEnabled = false
            notificationSwitch.isEnabled = false
            notificationSwitch.isOn = false
        }
        if singOutButton.frame.maxY < scrollView.frame.maxY{
            signOutButtonBottomConstraint.constant = 0
            signOutButtonBottomConstraint.constant += (scrollView.frame.maxY - singOutButton.frame.maxY) - 20
        }
    }
    
    @IBAction func RegisterArtistClick(_ sender: Any) {
        let vc = Utils.getViewController(storyboard:StoryboardId.authStoryBoardId, identifier: StoryboardId.artistRegistrationControllerId, viewController: UserRegistrationArtistViewController.self)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onNotificationsTapped(_ sender: Any) {
        
//        if DataManager.getUserLog == "guest"
//        {
//            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
//            return
//        }
//
        let viewController = Utils.getViewController(storyboard: StoryboardId.moreStoryboard, identifier: StoryboardId.notificationViewControllerId, viewController: NotificationViewController.self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func onContactUsTapped(_ sender: Any) {
        
//        if DataManager.getUserLog == "guest"
//        {
//            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
//            return
//        }
//
        let viewController = Utils.getViewController(storyboard: StoryboardId.moreStoryboard, identifier: StoryboardId.contactUsViewControllerId, viewController: ContactUsViewController.self)
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    @IBAction func onNotificationSwitchChanged(_ sender: Any) {
        
        if DataManager.getUserLog == "guest"
        {
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
            return
        }
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil    )
        viewModel.updateNotificationSettings(onCompletionCallback: {
            
            success,message in
            UIManager.hideCustomActivityIndicator(controller:self)
            if success{
                DataManager.setNotificationFlag = !DataManager.getNotificationFlag
                self.showAlert(title: "Success", message: message ?? "",alertType: .alert)
            }else{
                self.showAlert(title: "Error", message: message ?? "")
                self.notificationSwitch.isOn = !self.notificationSwitch.isOn
            }
        
        })
        
    }
    
    @IBAction func onShareAppTapped(_ sender: Any) {
     
        var textToShare = ""
       
            textToShare = "Hey! Download the ArtStation App now.Where artists wait for your call! https://apps.apple.com/us/app/art-station/id1585352837"
       
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
            self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    @IBAction func btnSignOutClick(_ sender: Any) {
        LiveChat.clearSession()
        DataManager.setUserLog="false"
        DataManager.setUserAuth=""
        DataManager.setUserData=nil
        let mainStoryboard = UIStoryboard(name: "Onboarding"+UIManager.ifArabiclanguage(), bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "navReg") as! UINavigationController
        if let keyWindow = UIWindow.key {
            DataManager.setUserLog = "false"
            keyWindow.rootViewController = initialViewController
        }
    }

    @IBAction func onChatWithUsButtonTapped(_ sender: Any) {
//        if DataManager.getUserLog == "guest"
//        {
//            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
//            return
////        }
//
//        debugPrint("HERE")
//
//        if DataManager.getUserLog == "true"{
//
//        LiveChat.licenseId = "12948735"
//        LiveChat.email = DataManager.getUserData?.email
//        LiveChat.name = DataManager.getUserData?.name
//            LiveChat.presentChat()
//        }
//        else{
//            self.showAlert(title: "Alert", message: "Please log in to use this feature")
//        }
        
        let whatsappURL = URL(string:"https://wa.me/+966537746799")!
        debugPrint(whatsappURL)
              if UIApplication.shared.canOpenURL(whatsappURL){

                  UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
              }
    }
}

