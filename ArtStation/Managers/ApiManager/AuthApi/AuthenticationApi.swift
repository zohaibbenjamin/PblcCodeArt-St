//
//  AuthApi.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import Foundation
import Alamofire


struct AuthenticationApi{
    
    func loginUser(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
    
        
        APIManagerBase.sharedInstance.postRequestUserToken(route: URL(string: ApiEndpoint.loginEndpoint)!, parameters: params, success: onSuccess, failure: onFailure, header: ["lang":DataManager.getLanguage])
//        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.loginEndpoint)!, parameters: params, success: onSuccess, failure: onFailure, headers: nil)
        
    }
    
    
    
    func registerUser(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.signUpEndpoint)!, parameters: params, success: onSuccess, failure: onFailure, headers: ["lang":DataManager.getLanguage])
        
    }
    
    
    func loginUserSocial(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.loginEndpointSocial)!, parameters: params, success: onSuccess, failure: onFailure, headers: ["lang":DataManager.getLanguage])
        
    }
    
    
    
    func registerUserSocial(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.signUpEndpointSocial)!, parameters: params, success: onSuccess, failure: onFailure, headers: ["lang":DataManager.getLanguage])
        
    }
    
    
    func sendOtpCodeToEmail(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        APIManagerBase.sharedInstance.patchRequest(route: URL(string: ApiEndpoint.forgotPasswordEndpoint)!, parameters: params, success: onSuccess, failure: onFailure,headers: ["lang":DataManager.getLanguage])
        
    }

    func validateOtpCodeOrResetPasscode(endpoint : String,params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        APIManagerBase.sharedInstance.patchRequest(route: URL(string: endpoint)!, parameters: params, success: onSuccess, failure: onFailure,headers: ["lang":DataManager.getLanguage])
        
    }

   

    func getUserProfile(onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
      
        let httpHeaders = HTTPHeaders(["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
        let route = URL(string: ApiEndpoint.getProfileEndpoint)!
        
        APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route, headers:httpHeaders, success: onSuccess, failure: onFailure)
    }
    
 
    
   
    
    
    func updateUserProfile(bodyParams :Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
      
        let httpHeaders = HTTPHeaders(["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
        let route = URL(string: ApiEndpoint.updateUserProfile)!
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: route, parameters: bodyParams, success: onSuccess, failure: onFailure,headers : httpHeaders)
        
    }
    
    func getCities(onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
       
        var headers : HTTPHeaders?
        var route : URL?
        route = URL(string: ApiEndpoint.getCitiesEndpointGuest)!
        headers = HTTPHeaders(["Authorization": "ARTS!and$ANDP","lang":DataManager.getLanguage])
           
        
        APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route!, headers: headers, success: onSuccess, failure: onFailure)
        
    }
    
    
    func getCategories(param:Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let route = URL(string: ApiEndpoint.getDropDownCategories)!
        let headers = HTTPHeaders(["Authorization": "ARTS!and$ANDP","lang":DataManager.getLanguage])
           
        
        APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: route, parameters: param, headers: headers, success: onSuccess, failure: onFailure)
        
    }
    
}
