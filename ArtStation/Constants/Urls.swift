//
//  Urls.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import Foundation


struct ApiEndpoint{
    
 //Payfort
    static let PayfortSDKToken = ConfigurationManager.shared.getBaseURLV().absoluteString + "paymentToken/"
    static let getPayFortEnvirement = ConfigurationManager.shared.getPayfortEnviroment()
    
    //Auth
    static let loginEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "login"
    static let signUpEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "signup"
    
    static let loginEndpointSocial = ConfigurationManager.shared.getBaseURLV().absoluteString + "sociallogin"
    static let signUpEndpointSocial = ConfigurationManager.shared.getBaseURLV().absoluteString + "socialsignup"
   
    static let signOutEndpoint = ""
    static let forgotPasswordEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "forgot"
    static let verifyOtpCodeEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "verifyCode"
    static let resetPasswordEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "resetPassword"
    static let getProfileEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "getProfile"
    static let updateUserProfile = ConfigurationManager.shared.getBaseURLV().absoluteString + "updateUserProfile"
    static let getCitiesEndpointGuest = ConfigurationManager.shared.getGuestUrl().absoluteString + "getCities"
    static let getCitiesEndpointUser = ConfigurationManager.shared.getBaseURLV().absoluteString + "getCities"
    static let getDropDownCategories = ConfigurationManager.shared.getGuestUrl().absoluteString + "categoriesDropdown"
    
    
    //Home
    static let getHomeCatogories = ConfigurationManager.shared.getBaseURLV().absoluteString + "categoryList"
    
    static let getWeatherApi = ConfigurationManager.shared.getBaseURLV().absoluteString + "getWether"
    static let getArtistPackagesEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "getPackagesByArtist"
    static let getArtistCards = ConfigurationManager.shared.getBaseURLV().absoluteString + "getArtist"
    static let getVatEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "getVat"
    
    static let getDetailsForceUpdateEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "getDetail"
    
    static let pinArtist = ConfigurationManager.shared.getBaseURLV().absoluteString + "pinArtist"
    
  
    //Booking
    
    static let getUpcomingBookings = ConfigurationManager.shared.getBaseURLV().absoluteString + "upcomingBookings"
    static let getPastBookings = ConfigurationManager.shared.getBaseURLV().absoluteString + "previousBookings"
    static let cancelBooking = ConfigurationManager.shared.getBaseURLV().absoluteString + "cancelBooking"
    static let rescheduleBooking =  ConfigurationManager.shared.getBaseURLV().absoluteString + "rescheduleBooking"
    static let getInvoiceEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "invoicePdf"
    static let getExpireBookingEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "expireBooking"
    
    //Guest
    
    static let getHomeCatogoriesGuest = ConfigurationManager.shared.getGuestUrl().absoluteString + "categoryList"
    static let getWeatherApiGuest = ConfigurationManager.shared.getGuestUrl().absoluteString + "getWether"
    static let getArtistPackagesEndpointGuest = ConfigurationManager.shared.getGuestUrl().absoluteString + "getPackagesByArtist"
    static let getArtistCardsGuest = ConfigurationManager.shared.getGuestUrl().absoluteString + "getArtist"
    static let getAllReviewsGuest = ConfigurationManager.shared.getGuestUrl().absoluteString + "reviewList"
    
    //MARK:- Reviews
    static let getAllReviews = ConfigurationManager.shared.getBaseURLV().absoluteString + "reviewList"
   
    static let postReview = ConfigurationManager.shared.getBaseURLV().absoluteString + "addReview"
    
    static let getArtistCalendar = ConfigurationManager.shared.getBaseURLV().absoluteString + "artistCalender"
    
    static let BookNew = ConfigurationManager.shared.getBaseURLV().absoluteString + "bookPackage"
    static let BookNewV2 = ConfigurationManager.shared.getBaseURLV().absoluteString + "customRequestV2"
    
    //MARK: - claimBooking called before continuing for artist booking request
    static let ClaimBookingRequest = ConfigurationManager.shared.getBaseURLV().absoluteString + "claimBooking"
    
    
    //MARK: -  submit custom Package request
    /*Task: need to create new section of package request(custom)
    1: Custom package request on mobile side
    API: {{server}}arts/api/v1/mobile/customRequest
    Method:POST , Body:   artist_id, description
     */
    static let submitCustomRequest = ConfigurationManager.shared.getBaseURLV().absoluteString + "customRequest"
    
    //Contact US
    
    static let contactUsEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "contactus"
    static let subscribeEndpoint = ConfigurationManager.shared.getBaseURLV().absoluteString + "stayInTouch"
    
    //Notifications
    static let getNotificationList = ConfigurationManager.shared.getBaseURLV().absoluteString + "notificationList"
    static let updateNotificationSettings = ConfigurationManager.shared.getBaseURLV().absoluteString + "allowPush"

    
    //TermsAndConditions
    static var termsAndConditionsUrl: String{
        if ConfigurationManager.shared.activeConfiguration == .production{
            return "https://cms-staging.art-station.org/#/termsCondition"
           // return "https://cms.art-station.org/#/termsCondition"
        }else{
            return "https://cms-staging.art-station.org/#/termsCondition"
        }
    }//Payment
    static let paymentSuccessUrl = ConfigurationManager.shared.getBaseURLV().absoluteString + "paymentRecived"
    static let promoCode = ConfigurationManager.shared.getBaseURLV().absoluteString + "redeemPromo"


    //GetArtistGallery
    
    static let getArtistImages = ConfigurationManager.shared.getBaseURLV().absoluteString + "getArtistGalary"
    static let getArtistImagesGuest = ConfigurationManager.shared.getGuestUrl().absoluteString + "getArtistGalary"

    //ChangeLanguage
    static let changeLanguageApi = ConfigurationManager.shared.getBaseURLV().absoluteString + "changeLanguage"

}
