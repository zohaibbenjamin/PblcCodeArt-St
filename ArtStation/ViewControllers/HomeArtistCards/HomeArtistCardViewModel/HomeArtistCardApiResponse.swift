//
//  HomeArtistCardApiResponse.swift
//  ArtStation
//
//  Created by Apple on 15/06/2021.
//

import Foundation


struct HomeArtistCardApiResponse: Codable {
    let count: Int?
    let list: [GetArtistDetailApiResponse]?
    let pin_artist_list:[FavouriteArtistModel]?

    enum CodingKeys: String, CodingKey {
        case count,list
        case pin_artist_list
    }
    
}

/*
{
        "count": 2,
        "list": [
        ]
    }
*/

