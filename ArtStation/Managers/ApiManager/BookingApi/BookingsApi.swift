//
//  BookingsApi.swift
//  ArtStation
//
//  Created by MamooN_ on 6/30/21.
//

import Foundation
import Alamofire
struct BookingApi{
    
    
    func getUpcomingBookings(urlPagingParams : PaginationParams,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        let httpHeaders = HTTPHeaders(["Authorization" : UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
      
        
        let route = APIManagerBase.sharedInstance.GetURLwithParams(route:  ApiEndpoint.getUpcomingBookings,parameters: urlPagingParams.dictionary)
        APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route: route!, headers:httpHeaders, success: onSuccess, failure: onFailure)
    }
    
    func getPastBookings(urlPagingParams : PaginationParams,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        let httpHeaders = HTTPHeaders(["Authorization" : UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
      
        let route = APIManagerBase.sharedInstance.GetURLwithParams(route:  ApiEndpoint.getPastBookings,parameters: urlPagingParams.dictionary)
        APIManagerBase.sharedInstance.getRequestWithUserTokenNoParams(route:route!, headers:httpHeaders, success: onSuccess, failure: onFailure)
    }
    
    func getInvoice(invoiceId : Int,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let route = URL(string: ApiEndpoint.getInvoiceEndpoint + "/" + String(invoiceId))!
        let httpHeaders = HTTPHeaders(["Authorization" : UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
        APIManagerBase.sharedInstance.getRequestWithUserTokenHeaderParam(route: route, parameters: ["lang":DataManager.getLanguage], headers: httpHeaders, success: onSuccess, failure: onFailure)
    }
    
    
    
    func expireBooking(bookingId : Int,onSuccess : @escaping ResultAPISuccessClosure, onFailure : @escaping DefaultAPIFailureClosure){
        
        let route = URL(string: ApiEndpoint.getExpireBookingEndpoint + "/" + String(bookingId))!
        let httpHeaders = HTTPHeaders(["Authorization" : UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? "","lang":DataManager.getLanguage])
        APIManagerBase.sharedInstance.postRequestDefaultTokenWith(route: route, parameters: [:], success: onSuccess, failure: onFailure, headers: httpHeaders)
    }
}
