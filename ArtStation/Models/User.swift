//
//  User.swift
//  ArtStation
//
//  Created by MamooN_ on 6/8/21.
//

import Foundation

// MARK: - User

//"user": {"type": null,"band": false,"solo": false,"subscriptionEmail": null,"DOB": null,"device_type": null,"rating":0,"lang": "en","allowPush": true,"verified": "0","status": "0","id": 215,"name": "baseer  ahmed","email": "entertainer90@gmail.com","phone": "923452299412","city": "isb","category_id": 54,"device_token": "u6345tSfZ7vc","role_id": "3"
//
//      }
struct User: Codable {
    let name, phone, email,nationality: String?
    let id : Int?
    let role_id:Int?
    let city, dob, status: String?
    let deviceToken : DeviceToken?
    let allowPush : Bool?
    let city_id:Int?
    let user_type: String?
    
    enum CodingKeys: String, CodingKey {
        case name, phone, email, id, city,nationality
        case role_id
        case dob = "DOB"
        case deviceToken = "device_token"
        case status
        case allowPush
        case city_id
        case user_type
    }
}

enum DeviceToken: Codable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        throw DecodingError.typeMismatch(DeviceToken.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .int(let x):
            try container.encode(x)
        }
    }
}


