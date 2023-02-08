//
//  HomePageApiRequest.swift
//  ArtStation
//
//  Created by Apple on 14/06/2021.
//

import Foundation

struct HomeApiRequest : Encodable {

    let name,description,image,status,created_at,updated_at:String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
            case name,description,image,status,created_at,updated_at,id
        }
}


/*
{ "status": 200, "message": "data fetched successfully", "data": { "list": [ { "id": 7, "name": "Sufi Music", "description": "", "image": "1623411878444.png", "status": "1", "created_at": "2021-06-11T11:44:39.000Z", "updated_at": "2021-06-12T17:47:53.000Z" }, { "id": 6, "name": "Arab Music", "description": "", "image": "1623411095046.png", "status": "1", "created_at": "2021-06-11T11:31:37.000Z", "updated_at": "2021-06-12T17:47:39.000Z" }, { "id": 5, "name": "Classic", "description": "", "image": "1623410017411.png", "status": "1", "created_at": "2021-06-11T11:13:39.000Z", "updated_at": "2021-06-12T17:47:32.000Z" }, { "id": 4, "name": "DJ", "description": "", "image": "1623237090533.png", "status": "1", "created_at": "2021-06-09T11:11:31.000Z", "updated_at": "2021-06-12T17:47:25.000Z" }, { "id": 3, "name": "Eastern Music", "description": "", "image": "1623144576877_0.png", "status": "1", "created_at": "2021-06-08T09:29:36.000Z", "updated_at": "2021-06-12T17:47:18.000Z" }, { "id": 2, "name": "Western Music", "description": "", "image": "1623144422517_0.png", "status": "1", "created_at": "2021-06-08T09:27:02.000Z", "updated_at": "2021-06-12T17:46:46.000Z" } ], "pagination": { "page": 1, "pages": 1, "count": 6, "per_page": 20, "sort_by": "id", "sort_order": "DESC" } }}
*/
