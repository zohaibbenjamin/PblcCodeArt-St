//
//  PaymentApi.swift
//  ArtStation
//
//  Created by Apple on 12/07/2021.
//

import Foundation
import Alamofire

struct PaymentApi {
    
    func paymentSuccessFul(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
      
      //  let routeWithParams = APIManagerBase.sharedInstance.GetURLwithParams(route: ApiEndpoint.paymentSuccessUrl, parameters:params)
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
        
            APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.paymentSuccessUrl)!, parameters: params, success: onSuccess, failure: onFailure, headers: httpHeaders)

    }
    
    func PostPromo(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.promoCode)!, parameters: params, success: onSuccess, failure: onFailure, headers: httpHeaders)
        
    }
    
    
    func getTokenConfiguration(paymentType : String,udid : String,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let endPoint = ApiEndpoint.PayfortSDKToken + udid
        let url = APIManagerBase.sharedInstance.GetURLwithParams(route: endPoint, parameters: ["payment_type":paymentType])!
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        debugPrint(url)
        APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: url, headers: httpHeaders, success: onSuccess, failure: onFailure)
    }
}
