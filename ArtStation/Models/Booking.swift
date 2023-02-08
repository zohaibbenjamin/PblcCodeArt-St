//
//  Booking.swift
//  ArtStation
//
//  Created by MamooN_ on 7/1/21.
//

import Foundation

// MARK: - Booking
    
struct Booking: Decodable {
    let id, userID: Int
    let packageID: Int?
    let amount: Double
    let status: String
   // let paid: Bool
    let startDate, startTime, dressCode, eventType:String
    let paid_till,paid_time: String?
    let eventSetup : String?
    let address: String
    let lat, lng: Double?
    let createdAt, updatedAt: String
    let users: User
    let package: Package
    let artist_info : [ArtistInfo]?
    let requested_place : String?
    let paid : String?
    let hours_selected:Int?
    let userType:String?


    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case packageID = "package_id"
        case amount, status
        case startDate = "start_date"
        case startTime = "start_time"
        case dressCode = "dress_code"
        case eventType = "event_type"
        case eventSetup = "event_setup"
        case address, lat, lng, createdAt, updatedAt, users, package,paid_time,paid_till
        case requested_place
        case paid
        case artist_info
        case hours_selected
        case userType
    }
    
    func getArtistInfo()->ArtistInfo
    {
        if artist_info?.count ?? 0 > 0
        {
            return artist_info![0]
        }
        else
        {
            return ArtistInfo.init(stageName: "", officialEmail: "", contactPhone: "", otherPhone: "", stageName_ar: "", city: "", biography: "", biography_ar: "", geners_ar: "", id: 0, userID: 0, geners: "")
        }
    }
}

struct customBookingV2: Encodable{
    var artist_id:Int
    var userType: String
    var goToSing: String
    var bandMembersCount: Int
    var addInfo: String
    var addInfo_ar: String
    var audienceCount: Int
    var playTime: Int
    var dress_code: String
    var instrumentType: String
   // var eventPlace: String
    var event_setup: String
    var event_type: String
    var start_date: String
    var start_time: String
    var requested_place: String
    var address: String
    var eventPrice: Double
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case artist_id
        case userType,goToSing
        case bandMembersCount
        case addInfo
        case addInfo_ar
        case audienceCount
        case playTime
        case dress_code
        case instrumentType
        //case eventPlace
        case event_setup
        case event_type
        case start_date
        case start_time
        case requested_place
        case address
        case eventPrice
        case description
    }
    
    static var sharedInstance = customBookingV2(artist_id: 0, userType: "", goToSing: "", bandMembersCount: 0, addInfo: "", addInfo_ar: "", audienceCount: 0, playTime: 0, dress_code: "", instrumentType: "", event_setup: "", event_type: "", start_date: "", start_time: "", requested_place: "", address: "", eventPrice: 0,description: "")
}




struct BookingNow: Encodable {

    var id,artist_id,package_id: Int
    var amount: Double
    var start_date, start_time, dress_code, event_type,lat,lng,address,event_setup,requested_place: String
    var hours_selected:Int
    var userType:String
    
enum CodingKeys: String, CodingKey {
    case id,artist_id,package_id, amount,address
    case start_date, start_time, dress_code, event_type,lat,lng,event_setup,requested_place
    case hours_selected
    case userType
}

    static var sharedInstance = BookingNow.init(id: 0, artist_id: 0, package_id: 0, amount: 0, start_date: "", start_time: "", dress_code: "", event_type: "", lat: "", lng: "",address: "",event_setup: "",requested_place:"",hours_selected:0, userType: "")

}


struct customBooking: Codable{
    var userType:String
    var goToSing:String
    var musiciansCount:Int
    var bandMembersCount:Int
    var instrumentCount:Int
    var playTime:Int
    var dress_code:String
    var instrumentType:String
    var eventPlace:String
    var dress_setup:String
    var event_type:String
    var eventInfo:String
    var eventAddress:String
    var eventDate:String
    var eventTime:String
    var preferredAudienceCount:Int
    var price:Double
    
    enum CodingKeys: String, CodingKey {
        case userType
        case goToSing
        case musiciansCount
        case bandMembersCount
        case instrumentCount
        case playTime
        case dress_code
        case instrumentType
        case eventPlace
        case dress_setup
        case event_type
        case eventInfo
        case eventAddress
        case eventDate
        case eventTime
        case preferredAudienceCount
        case price
    }
    
    static var sharedInstance = customBooking( userType: "", goToSing: "", musiciansCount: 0, bandMembersCount: 0, instrumentCount: 0, playTime: 0, dress_code: "", instrumentType: "", eventPlace: "", dress_setup: "", event_type: "", eventInfo: "", eventAddress: "", eventDate: "", eventTime: "", preferredAudienceCount: 0,price: 0.0)
    
    
}

