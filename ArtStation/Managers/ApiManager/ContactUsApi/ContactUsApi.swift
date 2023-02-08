//
//  ContactUsApi.swift
//  ArtStation
//
//  Created by MamooN_ on 7/6/21.
//

import Foundation
import Alamofire

struct ContactUsApi{
   
    func getContactUsDetails(onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
      
    
        let httpHeaders = HTTPHeaders(["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
    debugPrint(httpHeaders)
        let route = URL(string: ApiEndpoint.contactUsEndpoint)!
        APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route, headers:httpHeaders, success: onSuccess, failure: onFailure)
    }
    
    func subscribe(bodyParams : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
      
        let httpHeaders = HTTPHeaders(["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
        let route = URL(string: ApiEndpoint.subscribeEndpoint)!
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: route, parameters: bodyParams, success: onSuccess, failure: onFailure, headers: httpHeaders)
    }
}
