//
//  LoginApiResponse.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import Foundation


struct LoginResponseData: Codable {
    let authToken: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case user
    }
}





