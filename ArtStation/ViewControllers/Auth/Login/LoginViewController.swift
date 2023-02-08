//
//  LoginViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 5/31/21.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var termsAndConditionsCheckBox: Checkbox!
    //MARK:- IB Refrences
    @IBOutlet weak var appleSignInView: UIView!
    @IBOutlet weak var artistRegistrationButton: UIButton!
    @IBOutlet weak var userRegistrationButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userEmailField: FormTextInput!
    @IBOutlet weak var userPasswordField: FormTextInput!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //MARK:- Data
    let viewModel = LoginViewModel()
    
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpSignInAppleButton()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    //MARK:- Sets up initial UI
    func setupUI(){
        
        
        userPasswordField.textInputFeild.maxLength = 20
        signInButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor.systemPink, borderRadius: signInButton.frame.height/2, borderColor: nil)
        userRegistrationButton.configureButtonUI(backgroundColor:UIColor(named: "register_user_color")!, fontColor: UIColor.white, borderRadius: userRegistrationButton.frame.height/2, borderColor:UIColor.white,borderWidth: 1)
        artistRegistrationButton.configureButtonUI(backgroundColor: UIColor(named: "register_artist_color")!, fontColor: UIColor.white, borderRadius: artistRegistrationButton.frame.height/2, borderColor: nil)
        backButton.configureButtonUI(backgroundColor: nil, borderRadius: backButton.frame.height/2, borderColor: .white, borderWidth: 2)
        
    }
    
    
    
    //MARK:- OnLoginButtonTapped
    @IBAction func onSignInButtonTapped(_ sender: Any) {
       
        UIManager.showCustomActivityIndicator(controller: self, withMessage:   nil)
        viewModel.SignInUser(userName: userEmailField.textInputFeild.text ?? "", password: userPasswordField.textInputFeild.text ?? ""){
                success,errorString,statusCode in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                    DataManager.setUserLog = "true"
                DataManager.setLoginType = "normal"
                    DataManager.setUserData = self.viewModel.userData
                    DataManager.setCityForHomeData = self.viewModel.userData?.city_id
                    DataManager.setNotificationFlag = self.viewModel.userData?.allowPush
                    let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
                
                if let keyWindow = UIWindow.key {
                    keyWindow.rootViewController = homepageViewController
                }
      
            
            }else{
                self.showAlert(title: "", message: errorString ?? "")
            }
        }
 
    }

    
    //MARK:- ForgotPassButtonTapped
    @IBAction func onForgotPasswordButtonTapped(_ sender: Any) {
        let forgotPassVC = Utils.getViewController(storyboard: StoryboardId.authStoryBoardId, identifier: StoryboardId.forgotPasswordControllerId, viewController: ForgotPasswordViewController.self)
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    //MARK:- UserRegistrationButtonTapped
    @IBAction func registerAsUserTapped(_ sender: Any) {
  
        let vc = Utils.getViewController(storyboard: StoryboardId.authStoryBoardId, identifier: StoryboardId.userRegistrationControllerId, viewController: UserRegistrationViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTermsAndConditionsTapped(_ sender: Any) {
        guard let url = URL(string: ApiEndpoint.termsAndConditionsUrl.removingPercentEncoding ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func onCheckboxChanged(_ sender: Any) {
        termsAndConditionsCheckBox.isChecked = !termsAndConditionsCheckBox.isChecked
    }
    
    //MARK:- Artist Registration Button Tapped
    @IBAction func artistRegistrationButtonTapped(_ sender: Any) {
        let vc = Utils.getViewController(storyboard: StoryboardId.authStoryBoardId, identifier: StoryboardId.artistRegistrationControllerId, viewController: UserRegistrationArtistViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSkipButtonTapped(_ sender: Any) {
        
        DataManager.setUserLog = "guest"
        DataManager.setUserData = User.init(name: "Guest", phone: "", email: "", nationality: "", id: 0, role_id: nil, city: "", dob: "", status: "", deviceToken: DeviceToken.int(0), allowPush: false,city_id: 1, user_type: "guest")
        DataManager.setUserAuth="ARTS!and$ANDP"
        let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
    
    if let keyWindow = UIWindow.key {
        keyWindow.rootViewController = homepageViewController
    }

        
        
    }
    
}
