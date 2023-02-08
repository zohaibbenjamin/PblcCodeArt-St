//
//  Events.swift
//  ArtStation
//
//  Created by Apple on 02/07/2021.
//

import Foundation

struct Event: Codable {

let id,artist_id,booking_id : Int?
let start_date, end_date: String?


enum CodingKeys: String, CodingKey {
   case id,artist_id,booking_id,start_date,end_date
}

}


struct Day: Codable {

    let id,artist_id,booking_id: Int?
let end_date,start_date,availability: String?


enum CodingKeys: String, CodingKey {
  
    case id,artist_id,booking_id
    case end_date,start_date,availability

}

}

