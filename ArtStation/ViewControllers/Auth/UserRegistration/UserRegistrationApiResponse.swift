//
//  UserRegistrationApiResponse.swift
//  ArtStation
//
//  Created by MamooN_ on 6/8/21.
//

import Foundation

// MARK: - DataClass
struct UserRegistrationApiDataClass: Codable {
    
    let authToken: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case user
    }
}


