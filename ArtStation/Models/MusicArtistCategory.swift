//
//  MusicArtistCategory.swift
//  ArtStation
//
//  Created by Apple on 14/06/2021.
//

import Foundation

struct MusicArtistCategory : Codable {

    let id: Int
    let name_ar : String?
    let name, listDescription, image, status: String
    let createdAt, updatedAt: String
    // let users: [User]
    let artistType: String?
    let type:String?
    let video:String?
    let thumbnail: String?
    let role_id:Int?
        
       enum CodingKeys: String, CodingKey {
           case id, name
           case name_ar
           case listDescription = "description"
           case image, status
           case createdAt = "created_at"
           case updatedAt = "updated_at"
           case  artistType
           case type
           case video
           case thumbnail
           case role_id
       }
   
}
