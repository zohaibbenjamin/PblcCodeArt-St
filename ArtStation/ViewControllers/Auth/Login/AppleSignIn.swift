//
//  AppleSignIn.swift
//  ArtStation
//
//  Created by MamooN_ on 6/28/21.
//

import Foundation
import AuthenticationServices

extension LoginViewController : ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    func setUpSignInAppleButton() {
    
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle:.white)
        appleSignInView.addSubview(authorizationButton)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        authorizationButton.centerXAnchor.constraint(equalTo: appleSignInView.centerXAnchor).isActive = true
        authorizationButton.widthAnchor.constraint(equalToConstant: appleSignInView.frame.width/2).isActive = true
        authorizationButton.heightAnchor.constraint(equalTo: appleSignInView.heightAnchor, multiplier: 1).isActive = true
        authorizationButton.widthAnchor.constraint(equalTo: appleSignInView.widthAnchor, multiplier: 1).isActive = true
        authorizationButton.cornerRadius = appleSignInView.frame.height/2
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
    }
    
    //Handles Request
    @objc func handleAppleIdRequest() {
        
        if !termsAndConditionsCheckBox.isChecked{
            self.showAlert(title: "Alert", message: "Please agree to terms and conditions before continuing",alertType: .alert)
            return
        }
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
    }
    
    //MARK:- Authorization Failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
   
        self.showAlert(title: "Alert", message: "Apple sign in failed")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor{
        return view.window!
    }
    
    
    //MARK:- Authorization Success
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
        let userIdentifier = appleIDCredential.user
            
            let fullName = (appleIDCredential.fullName?.givenName ?? "") + (appleIDCredential.fullName?.familyName ?? "")
            let email = appleIDCredential.email
//
//        if email == nil{
//             //Get Data from user defaults
//            email = DataManager.getAppleIdEmail
//            fullName = DataManager.getAppleIdName ?? ""
//        }else{
//            DataManager.setAppleIdName = fullName
//            DataManager.setAppleIdEmail = email
//        }
//
//            debugPrint("AppleCreds",appleIDCredential)
//            debugPrint("Apple Creds",(email  ?? "Email") + "   " + fullName)
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            viewModel.singInSocial(userIdentifier: userIdentifier, userName: email ?? "", onCompletionCallback: {
                success, error,statusCode in
            UIManager.hideCustomActivityIndicator(controller: self)
          
            if success{
                    DataManager.setUserLog = "true"
                    DataManager.setUserData = self.viewModel.userData
                    let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
                    DataManager.setCityForHomeData = self.viewModel.userData?.city_id
                let userDetails = DataManager.getUserData!
                if (userDetails.city == "0" || userDetails.phone == "0"){
                    if DataManager.getLanguage == Language.arabic.rawValue{
                        homepageViewController.openWithIndex = 1
                    }else{
                        homepageViewController.openWithIndex = 3
                    }
                }
                DataManager.setLoginType = "social"
                
                if let keyWindow = UIWindow.key {
                    
                    keyWindow.rootViewController = homepageViewController
                }
      
                }else{
                    if statusCode == 404{
                    let signUpViewModel = UserRegistrationViewModel()
                        let request = UserRegistrationApiRequest(email: email ?? "", password: "", socialID: userIdentifier, socialPlatform: "Apple", signupType: LoginType.social.rawValue, user_type: UserType.user.rawValue, name: fullName , city: "", category:nil, deviceToken: DataManager.getFCMToken ?? "", phone: "",city_id: "1", device_type: "ios")
                    signUpViewModel.registerUserSocial(request: request, onCompletionHandler: {
                        success,errorMessage in
                        if success{
                           
                            self.viewModel.singInSocial(userIdentifier: userIdentifier, userName: email ?? "", onCompletionCallback: {
                                success,errorMessage,status in
                                UIManager.hideCustomActivityIndicator(controller: self)
                              
                                if success{
                                   
                                    
                                    self.showAlert(title: "Alert", message: "Please update your profile information.",onOkTapped: {
                                        DataManager.setUserLog = "true"
                                        DataManager.setUserData = self.viewModel.userData
                                        DataManager.setCityForHomeData = self.viewModel.userData?.city_id
                                        DataManager.setLoginType = "social"
                                        let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
                                    
                                        if DataManager.getLanguage == Language.arabic.rawValue{
                                            homepageViewController.openWithIndex = 1
                                        }else{
                                            homepageViewController.openWithIndex = 3
                                        }
                                        
                                        
                                    if let keyWindow = UIWindow.key {
                                        keyWindow.rootViewController = homepageViewController
                                    }
                                    })
                                    
                                }else{
                                    self.showAlert(title: "Alert", message: errorMessage ?? "")
                                }
                            })
                        
                        }else{
                            UIManager.hideCustomActivityIndicator(controller: self)
                          
                            self.showAlert(title: "Alert", message: errorMessage ?? "")
                        }
                        
                    })
                    }
                    else{
                        UIManager.hideCustomActivityIndicator(controller: self)
                      
                        self.showAlert(title: "Alert", message: error ?? "")
                    }
                }
          
            })
   
            
        }
    
    }
}
