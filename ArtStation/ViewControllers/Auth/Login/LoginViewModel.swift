//
//  LoginViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import Foundation

class LoginViewModel{
    
    var userData : User?
    
    
    //MARK:- Logs In User
    func SignInUser(userName : String,password : String,onCompletionCallback : @escaping (Bool,String?,Int) -> Void){
        
        // Validate Input
        let userNameValidationResponse = ValidationManager.isValidEmailFormat(emailText: userName)
        if !userNameValidationResponse.success{
            onCompletionCallback(false,userNameValidationResponse.error,-1)
            return
        }
        let passwordValidationResponse = ValidationManager.isValidPassword(password)
        if !passwordValidationResponse.success{
            onCompletionCallback(false,passwordValidationResponse.error,-1)
            return
        }
        do{
           
            let loginApiRequest = LoginApiRequest(email: userName, password: password,loginType: LoginType.normal.rawValue, userType:UserType.user.rawValue,device_token: DataManager.getFCMToken ?? "",device_type: "ios")
            print("DeviceTest",DataManager.getFCMToken ?? "",loginApiRequest)
            let data = try JSONEncoder().encode(loginApiRequest)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.authenticationAPI.loginUser(params: params, onSuccess: { response in
                let res = String(data:response!, encoding: .utf8)
                debugPrint(res)
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<LoginResponseData>.self, from: response!)
                    self.userData = loginApiResponse.data?.user
                    DataManager.setUserAuth = loginApiResponse.data?.authToken
                    //Parse Api Response
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message,loginApiResponse.status)
                        }
                    }else{
                        DispatchQueue.main.async {
                            onCompletionCallback(true,nil,loginApiResponse.status)
                        }
                    }
                 }
                catch let error{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,error.localizedDescription,-1)
                        debugPrint(error)
                    }
                }
            }, onFailure: { error in
            DispatchQueue.main.async {
                onCompletionCallback(false,error.localizedDescription,-1)
                debugPrint(error)
            }
        })
        }
        catch let error{
            onCompletionCallback(false,error.localizedDescription,-1)
            debugPrint(error)
        }
       }
    
    
    func singInSocial(userIdentifier : String,userName : String,onCompletionCallback : @escaping (Bool,String?,Int) -> Void){
        
        // Validate Input
      
        do{
            var loginRequest = LoginApiRequest(email:userName , loginType: LoginType.social.rawValue, userType: UserType.user.rawValue, device_token: DataManager.getFCMToken ?? "")
            loginRequest.socialID = userIdentifier
            loginRequest.socialPlatform = "Apple"
            debugPrint("Apple Request",loginRequest)
            let data = try JSONEncoder().encode(loginRequest)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.authenticationAPI.loginUserSocial(params: params, onSuccess: { response in
                
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<LoginResponseData>.self, from: response!)
                    self.userData = loginApiResponse.data?.user
                    DataManager.setUserAuth = loginApiResponse.data?.authToken
                    //Parse Api Response
                    if loginApiResponse.status != 200{
//                        DataManager.setAppleIdName = loginApiResponse.data?.user.name
//                        DataManager.setAppleIdEmail = loginApiResponse.data?.user.email
                      DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message,loginApiResponse.status)
                        }
                    }else{
                        DispatchQueue.main.async {
                           
                            onCompletionCallback(true,nil,loginApiResponse.status)
                        }
                    }
                 }
                catch let error{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,error.localizedDescription,-1)
                    }
                }
            }, onFailure: { error in
            DispatchQueue.main.async {
                onCompletionCallback(false,error.localizedDescription,-1)
            }
        })
        }
        catch let error{
            onCompletionCallback(false,error.localizedDescription,-1)
        }
       }
}



