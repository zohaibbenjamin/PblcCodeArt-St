//
//  ChangeLanguageApi.swift
//  ArtStation
//
//  Created by MamooN_ on 10/22/21.
//

import Foundation
import Alamofire



struct ChangeLanguageApi {
    
    
    func changeLanguage(params: Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
            
            let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
        
            let url = ApiEndpoint.changeLanguageApi
            APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: URL(string: url)!, parameters: params, headers: httpHeaders, success: onSuccess, failure: onFailure)
    }
}
