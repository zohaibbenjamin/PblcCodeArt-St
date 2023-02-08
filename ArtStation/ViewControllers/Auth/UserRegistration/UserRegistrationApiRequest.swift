//
//  UserRegistrationApiRequest.swift
//  ArtStation
//
//  Created by MamooN_ on 6/8/21.
//

import Foundation


import Foundation

// MARK: - UserRegistrationApiRequest
struct UserRegistrationApiRequest: Codable {
    let email, password : String
    let socialID, socialPlatform, signupType: String?
    let  user_type:String
    let name, city: String
    let category : String?
    var deviceToken, phone: String
   // let DOB : String?
    let city_id:String?
    let device_type : String
    enum CodingKeys: String, CodingKey {
        case email, password
        case socialID = "social_id"
        case socialPlatform = "social_platform"
        case signupType = "signup_type"
        case user_type
        case name, city
        case deviceToken = "device_token"
        case phone ,category = "category_id",city_id
        case device_type
    }
}
