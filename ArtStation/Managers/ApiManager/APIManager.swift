//
//  API.swift
//  TabibGroup_Swift
//
//  Created by Tahir Pasha on 30/11/2020.
//

import UIKit

typealias DefaultAPIFailureClosure = (NSError) -> Void
typealias DefaultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultBoolResultAPISuccesClosure = (Bool) -> Void
typealias DefaultArrayResultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias APISuccessClosureWithStatusCode = (Dictionary<String,AnyObject>, _ StatusCode:Int) -> Void

typealias ResultAPISuccessClosure = (Data?) -> Void


protocol APIErrorHandler
{
    func handleErrorFromResponse(response: Dictionary<String,AnyObject>)
    func handleErrorFromError(error:NSError)
}

class APIManager: NSObject
{
    static let sharedInstance = APIManager()
    
    
    var serverToken: String? {
        get{
            return ""
        }
    }
    
    let authenticationAPI = AuthenticationApi()
    let homePageAPI = HomePageApi()
    let artistProfileApi = ArtistProfileApi()
    let bookingApi = BookingApi()
    let reviewApi = ReviewApi()
    let bookArtistAPI = BookArtistApi()
    let contaactUsApi = ContactUsApi()
    let notificationApi = NotificationApi()
    let paymentApi = PaymentApi()
    let changeLanguageApi = ChangeLanguageApi()
   // let homeAPI = HomeAPI()
//    let notificationAPI = NotificationAPI()
//    let outletsAPI = OutletsAPI()
//    let subscriptionAPI = SubscriptionAPI()
//    let orderAPI = OrderAPI()

}
