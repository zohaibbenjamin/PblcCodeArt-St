//
//  ArtistGeneralModel.swift
//  ArtStation
//
//  Created by Andpercent on 26/01/2022.
//

import Foundation

//{\"id\":33,\"artist_id\":21,\"category_id\":1,\"user_id\":16,\"artists\":{\"stageName\":\"rock\",\"stageName_ar\":\"\",\"id\":21}}
struct FavouriteArtistModel:Codable{
    let id:Int
    let artist_id: Int
    let category_id:Int
    let user_id:Int
    var artists:favourit_artist_Info?
    
    enum CodingKeys:String,CodingKey {
        case id
        case artist_id
        case category_id
        case user_id
        case artists
    }
}

struct favourit_artist_Info: Codable{
    let id:Int
    let role_id:Int?
    let artist_info:[Pinedartist]?
    
    enum CodingKeys:String,CodingKey {
        case id
        case artist_info
        case role_id
    }
}

struct Pinedartist:Codable{
    let id: Int
    let stageName:String?
    let stageName_ar:String?
    
    enum CodingKeys: String,CodingKey {
        case id
        case stageName
        case stageName_ar
    }
}

//[{\"id\":33,\"artist_id\":21,\"category_id\":1,\"user_id\":16,\"artists\":{\"stageName\":\"rock\",\"stageName_ar\":\"\",\"id\":21}}


struct FavouriteArtistModelResponse: Codable {
    let artist_id: Int?
    let category_id: Int?
    let createdAt: String
    let id:Int
    let updatedAt: String
    let user_id :Int
    
    enum CodingKeys: String, CodingKey {
        case artist_id
        case category_id
        case createdAt
        case id
        case updatedAt
        case user_id
    }
}
//data =     {
//    "artist_id" = 19;
//    "category_id" = 1;
//    createdAt = "2022-01-28T11:03:43.377Z";
//    id = 67;
//    updatedAt = "2022-01-28T11:03:43.377Z";
//    "user_id" = 166;
//};

//"id\":14,\"user_id\":166,\"artist_id\":21,\"package_id\":8,\"updatedAt\":\"2022-02-03T10:09:39.397Z\",\"createdAt\":\"2022-02-03T10:09:39.397Z\"}}"

    struct claimBookingResponse:Codable {
    let id: Int
    let user_id:Int
    let artist_id:Int
    let package_id:Int
    let updatedAt:String
    let createdAt:String
    
        enum CodingKeys: String, CodingKey {
            case id,user_id,artist_id,package_id,updatedAt,createdAt
        }
}

struct forceUpdateResponseModel : Codable{
    let id: Int
    let ios_version : String
    let android_version: String
    let force_update: Bool
    let createdAt: String
    let updatedAt: String
   // let deletedAt : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ios_version,android_version
        case force_update
        case createdAt,updatedAt
        //,deletedAt
    }
}


