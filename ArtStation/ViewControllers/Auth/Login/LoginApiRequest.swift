//
//  LoginApiRequest.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import Foundation

struct LoginApiRequest : Encodable {

    let email : String
    let password : String?
    var socialID, socialPlatform: String?
    let loginType, userType: String
    var device_token : String
    let device_type : String
    
    enum CodingKeys: String, CodingKey {
            case email, password,device_token
            case socialID = "social_id"
            case socialPlatform = "social_platform"
            case loginType = "login_type"
            case userType = "user_type"
            case device_type
        }
    
    init(email : String,password : String? = nil,loginType : String,userType : String,device_token:String,device_type : String = "ios"){
        self.email = email
        self.password = password
        self.loginType = loginType
        self.userType = userType
        socialID = nil
        socialPlatform = nil
        self.device_token = device_token
        self.device_type = device_type
    }
}
