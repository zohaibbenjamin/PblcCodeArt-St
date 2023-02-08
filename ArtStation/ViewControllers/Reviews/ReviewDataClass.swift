//
//  ReviewDataClass.swift
//  ArtStation
//
//  Created by MamooN_ on 7/2/21.
//

import Foundation
struct ReviewDataClass: Decodable {
    let review: [Review]
    let pagination: Pagination
}


// MARK: - Review
struct Review: Decodable {
    let id, userID, packageID: Int
    let comment, rating, createdAt, updatedAt: String
    let users: User

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case packageID = "artist_id"
        case comment, rating, createdAt, updatedAt, users
    }
}
