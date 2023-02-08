//
//  HomePageApiResponse.swift
//  ArtStation
//
//  Created by Apple on 14/06/2021.
//

import Foundation

struct HomePageApiResponse: Decodable {
    let pagination: Pagination
    let list: [MusicArtistCategory]

    enum CodingKeys: String, CodingKey {
        case list,pagination
    }
    
}


/*
{ "status": 200, "message": "data fetched successfully", "data": { "list": [ { "id": 7, "name": "Sufi Music", "description": "", "image": "1623411878444.png", "status": "1", "created_at": "2021-06-11T11:44:39.000Z", "updated_at": "2021-06-12T17:47:53.000Z" }, { "id": 6, "name": "Arab Music", "description": "", "image": "1623411095046.png", "status": "1", "created_at": "2021-06-11T11:31:37.000Z", "updated_at": "2021-06-12T17:47:39.000Z" }, { "id": 5, "name": "Classic", "description": "", "image": "1623410017411.png", "status": "1", "created_at": "2021-06-11T11:13:39.000Z", "updated_at": "2021-06-12T17:47:32.000Z" }, { "id": 4, "name": "DJ", "description": "", "image": "1623237090533.png", "status": "1", "created_at": "2021-06-09T11:11:31.000Z", "updated_at": "2021-06-12T17:47:25.000Z" }, { "id": 3, "name": "Eastern Music", "description": "", "image": "1623144576877_0.png", "status": "1", "created_at": "2021-06-08T09:29:36.000Z", "updated_at": "2021-06-12T17:47:18.000Z" }, { "id": 2, "name": "Western Music", "description": "", "image": "1623144422517_0.png", "status": "1", "created_at": "2021-06-08T09:27:02.000Z", "updated_at": "2021-06-12T17:46:46.000Z" } ], "pagination": { "page": 1, "pages": 1, "count": 6, "per_page": 20, "sort_by": "id", "sort_order": "DESC" } }}
*/


struct WeatherDataResponse: Codable {
    
    
    let LocalObservationDateTime,WeatherText,PrecipitationType,MobileLink,Link:String?
    let EpochTime,WeatherIcon:Int?
    let HasPrecipitation,IsDayTime:Bool?
    let Temperature:WeatherTemperatureData?
    
    enum CodingKeys: String, CodingKey {
        case LocalObservationDateTime,WeatherText,PrecipitationType,MobileLink,Link,EpochTime,WeatherIcon,HasPrecipitation,IsDayTime,Temperature
    }
    
}

struct WeatherTemperatureData: Codable {
    let Metric,Imperial:WeatherTemperature?

    enum CodingKeys: String, CodingKey {
        case Metric,Imperial
    }
    
}

struct WeatherTemperature: Codable {
    let Unit: String?
    let Value:Double?
    let UnitType:Int?

    enum CodingKeys: String, CodingKey {
        case Unit,Value,UnitType
    }
    
}

/*
{
           "LocalObservationDateTime": "2021-06-15T15:55:00+05:00",
           "EpochTime": 1623754500,
           "WeatherText": "Mostly cloudy",
           "WeatherIcon": 6,
           "HasPrecipitation": false,
           "PrecipitationType": null,
           "IsDayTime": true,
           "Temperature": {
               "Metric": {
                   "Value": 33.9,
                   "Unit": "C",
                   "UnitType": 17
               },
               "Imperial": {
                   "Value": 93,
                   "Unit": "F",
                   "UnitType": 18
               }
           },
           "MobileLink": "http://m.accuweather.com/en/pk/saddar/260796/current-weather/260796?lang=en-us",
           "Link": "http://www.accuweather.com/en/pk/saddar/260796/current-weather/260796?lang=en-us"
       }
*/
