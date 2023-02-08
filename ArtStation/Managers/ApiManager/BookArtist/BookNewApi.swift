//
//  BookNewApi.swift
//  ArtStation
//
//  Created by Apple on 02/07/2021.
//

import Foundation
import Alamofire

struct BookArtistApi {
    
    func getArtistCalendar(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
      
        let routeWithParams = APIManagerBase.sharedInstance.GetURLwithParams(route: ApiEndpoint.getArtistCalendar, parameters:params)
        
        APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: routeWithParams!, headers: ["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage], success: onSuccess, failure: onFailure)

    }
    
    func BookNew(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.BookNew)!, parameters: params, success: onSuccess, failure: onFailure, headers: httpHeaders)
        
    }
    
    func BookNewV2(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.BookNewV2)!, parameters: params, success: onSuccess, failure: onFailure, headers: httpHeaders)
        
    }
    //MARK: - Claim Booking : api called before continue for booking
    func cliamBookingRequest(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.ClaimBookingRequest)!, parameters: params, success: onSuccess, failure: onFailure, headers: httpHeaders)
    }
    
    //MARK: - MRafi added Custom package request
    
    func submitCustomPackageRequest(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.submitCustomRequest)!, parameters: params, success: onSuccess, failure: onFailure, headers: httpHeaders)
    }
    
    func submitCustomPackageRequest2(params : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: ApiEndpoint.submitCustomRequest)!, parameters: params, success: onSuccess, failure: onFailure, headers: httpHeaders)
    }
    
    func cancelBooking(bookingId: Int,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
    let httpHeaders = HTTPHeaders(["Authorization":UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
        let routeWithParams = URL(string: (ApiEndpoint.cancelBooking + "/" + String(bookingId)))
        
                                  
        APIManagerBase.sharedInstance.postRequestUserToken(route: routeWithParams!, parameters: [:], success: onSuccess, failure: onFailure, header: httpHeaders)
    }
    
    func rescheduleEvent(bookingId : Int,bodyParams : Parameters,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let httpHeaders = HTTPHeaders(["Authorization" :DataManager.getUserAuth ?? "","lang":DataManager.getLanguage])
    
        let url = ApiEndpoint.rescheduleBooking + "/\(bookingId)"
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: URL(string: url)!, parameters: bodyParams, success: onSuccess, failure: onFailure, headers: httpHeaders)
        
    }
    
        
    }
