//
//  HomePage.swift
//  ArtStation
//
//  Created by Apple on 14/06/2021.
//

import Foundation
import Alamofire


struct HomePageApi{
    
    func getHomePageArtistCategory(cityId : Int,paginationParams:PaginationParams,params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        var pageParams = Dictionary<String, Any>()
        pageParams["city_id"] = cityId
        pageParams["sort_by"] = "sort_id"
        pageParams["sort_order"] = "ASC"
        
        if DataManager.getUserLog=="guest"
        {
        let route = APIManagerBase.sharedInstance.GetURLwithParams(route:  ApiEndpoint.getHomeCatogoriesGuest,parameters: pageParams)
            
         APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route!, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage], success: onSuccess, failure: onFailure)
        }
        else
        {
        let route = APIManagerBase.sharedInstance.GetURLwithParams(route:  ApiEndpoint.getHomeCatogories,parameters: pageParams)
        debugPrint(route)
         APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route!, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage], success: onSuccess, failure: onFailure)
        }
        
    }
    
    func getVat(onSuccess : @escaping ResultAPISuccessClosure,onFailure : @escaping DefaultAPIFailureClosure){
        
        if DataManager.getUserLog == "guest"{
            
        }else{
            let route = URL(string: ApiEndpoint.getVatEndpoint)!
            APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? ""], success: onSuccess, failure: onFailure)
        }
        
    }
    
    func getWeatherData(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        if DataManager.getUserLog=="guest"
        {
        APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: URL(string: ApiEndpoint.getWeatherApiGuest)!, parameters: params, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? ""], success: onSuccess, failure: onFailure)
        }else
        {
            APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: URL(string: ApiEndpoint.getWeatherApi)!, parameters: params, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? ""], success: onSuccess, failure: onFailure)
        }
        
    }
    
    
    func getDetailsForceUpdate(onSuccess : @escaping ResultAPISuccessClosure,onFailure : @escaping DefaultAPIFailureClosure){
        
        if DataManager.getUserLog == "guest"{
            
        }else{
            let route = URL(string: ApiEndpoint.getDetailsForceUpdateEndpoint)!
            debugPrint(route)
            APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? ""], success: onSuccess, failure: onFailure)
        }
    }
}
