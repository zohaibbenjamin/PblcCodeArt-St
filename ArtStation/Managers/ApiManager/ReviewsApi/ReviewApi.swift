//
//  ReviewApi.swift
//  ArtStation
//
//  Created by MamooN_ on 7/2/21.
//

import Foundation
import Alamofire

struct ReviewApi {
    
    func getAllReviewsForPackage(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        print(params)
        if DataManager.getUserLog=="guest"
        {
            let route = APIManagerBase.sharedInstance.GetURLwithParams(route:  ApiEndpoint.getAllReviewsGuest,parameters: params)
            
         APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route!, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage], success: onSuccess, failure: onFailure)
            
            let httpHeaders = HTTPHeaders(["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
                
            let routeWithParams = APIManagerBase.sharedInstance.GetURLwithParams(route: ApiEndpoint.getAllReviewsGuest, parameters:params)
                APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route:routeWithParams!, headers:httpHeaders, success: onSuccess, failure: onFailure)
        }else{
        
        let httpHeaders = HTTPHeaders(["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
            
        let routeWithParams = APIManagerBase.sharedInstance.GetURLwithParams(route: ApiEndpoint.getAllReviews, parameters:params)
            APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route:routeWithParams!, headers:httpHeaders, success: onSuccess, failure: onFailure)
            
        }
    }
    
    
    func postReview(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
     
        let httpHeaders = HTTPHeaders(["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
       
        APIManagerBase.sharedInstance.postRequestUserToken(route: URL(string: ApiEndpoint.postReview)!, parameters: params, success: onSuccess, failure: onFailure, header: httpHeaders)
    
    }
}
