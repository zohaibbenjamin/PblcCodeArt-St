//
//  ArtistProfileApi.swift
//  ArtStation
//
//  Created by MamooN_ on 6/15/21.
//

import Foundation
import Alamofire


struct ArtistProfileApi{
    
    
    func getArtistProfile(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        let httpHeaders = HTTPHeaders(["Authorization" : UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
        
       
        if DataManager.getUserLog=="guest"
        {
           
            let route = URL(string: ApiEndpoint.getArtistPackagesEndpointGuest)!
            let urlWithParams : URL = APIManagerBase.sharedInstance.GetURLwithParams(route: route.absoluteString, parameters: params)!
             APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: urlWithParams, headers:httpHeaders, success: onSuccess, failure: onFailure)
        }
        else
        {
            let route = URL(string: ApiEndpoint.getArtistPackagesEndpoint)!
            let urlWithParams : URL = APIManagerBase.sharedInstance.GetURLwithParams(route: route.absoluteString, parameters: params)!
           
            APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: urlWithParams, headers:httpHeaders, success: onSuccess, failure: onFailure)
        }
       
       
    }
    
    func getArtistCards(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        if DataManager.getUserLog=="guest"
        {
            APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: URL(string: ApiEndpoint.getArtistCardsGuest)!, parameters: params, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage], success: onSuccess, failure: onFailure)
            return
        }
        APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: URL(string: ApiEndpoint.getArtistCards)!, parameters: params, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage], success: onSuccess, failure: onFailure)
        
    }
    
    func pinArtist(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.pinArtist)!, parameters: params, success: onSuccess, failure: onFailure, headers: httpHeaders)
        
    }
    
    
    func getArtistGalary(artistId : Int,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        
        if DataManager.getUserLog=="guest"
        {
            let route = ApiEndpoint.getArtistImagesGuest + "/" + String(artistId)
          
            APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: URL(string: route)!, parameters: [:], headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage], success: onSuccess, failure: onFailure)
        }
        else{
            let route = ApiEndpoint.getArtistImages + "/" + String(artistId)
          
            APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: URL(string: route)!, parameters: [:], headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage], success: onSuccess, failure: onFailure)
            
        }
        
    }
    
    
}
