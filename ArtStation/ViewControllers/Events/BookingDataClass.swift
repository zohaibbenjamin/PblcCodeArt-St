//
//  BookingDataClass.swift
//  ArtStation
//
//  Created by MamooN_ on 6/30/21.
//

import Foundation

struct BookingData: Decodable {
    let booking: [Booking]
    let pagination: Pagination
}
