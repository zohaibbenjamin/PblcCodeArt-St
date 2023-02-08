//
//  NotificationApi.swift
//  ArtStation
//
//  Created by MamooN_ on 7/7/21.
//

import Foundation
import Alamofire


struct NotificationApi {
    
    func getNotifications(urlPagingParams : PaginationParams,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        let httpHeaders = HTTPHeaders(["Authorization" : UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
      
        let route = APIManagerBase.sharedInstance.GetURLwithParams(route:  ApiEndpoint.getNotificationList,parameters: urlPagingParams.dictionary)
       
        APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route:route!, headers:httpHeaders, success: onSuccess, failure: onFailure)
    }
    
    
    func changeNotificationSettings(onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        let url = ApiEndpoint.updateNotificationSettings
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: url)!, parameters: [:], success: onSuccess, failure: onFailure, headers: httpHeaders)
    }
}
