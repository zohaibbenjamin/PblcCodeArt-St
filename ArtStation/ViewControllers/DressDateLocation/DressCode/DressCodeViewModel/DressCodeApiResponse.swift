//
//  DressCodeApiResponse.swift
//  ArtStation
//
//  Created by Apple on 02/07/2021.
//

import Foundation

struct DressCodeApiData: Decodable {
    var events: [Event]?
    var days: [Day]?

    enum CodingKeys: String, CodingKey {
        case events,days
    }
    
}

struct BookNewApiData: Decodable {
    
    
    var address/*,createdAt,dress_code,event_type,lat,lng,start_date,start_time,updatedAt,event_setup*/:String?
   // var package_id,id,user_id:Int
   // var amount:Double
    enum CodingKeys: String, CodingKey {
        
        case address/*,createdAt,dress_code,event_type,lat,lng,start_date,start_time,updatedAt,event_setup*/
      //  case amount,id,package_id,user_id,
    }
    
}

