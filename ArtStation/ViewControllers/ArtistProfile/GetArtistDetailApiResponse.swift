//
//  GetArtistDetailApiResponse.swift
//  ArtStation
//
//  Created by MamooN_ on 6/15/21.
//

import Foundation

struct GetArtistDetailApiResponse : Codable{
    
        let name, phone, email,type,city, DOB, deviceToken,device_type, status,lang,verified,userType: String?
        let role_id: Int?
        let id,category_id,city_id,packageCount:Int?
        let startingFrom: Double?
        let packages: [Package]
        let artist_info: [ArtistInfo]
        let artist_images: [ArtistImage]
        let artist_talent:[Artist_Talent]?
        let artist_intro :[Artist_Intro]?
       
      
        let band,solo,allowPush:Bool?
        let rating:Double?

    
        enum CodingKeys: String, CodingKey {
            case name, phone, email,type,city, DOB, deviceToken,device_type, status,lang,verified,userType
            case id,category_id,city_id,packageCount, startingFrom
            case packages
            case artist_info
            case artist_images
            case band,solo,allowPush
            case rating,artist_talent
            case artist_intro
            case role_id
        }
    
    func getArtistImageOrReturnDefault()->ArtistImage
    {
        if artist_images.count>0
        {
            return artist_images[0]
        }
        else
        {
            return ArtistImage.init(profileImage: "", coverImage: "", id: 0, userID: 0, videoLinks: "")
        }
    }
    
    func getArtistInfo()->ArtistInfo
    {
        if artist_info.count>0
        {
            return artist_info[0]
        }
        else
        {
            return ArtistInfo.init(stageName: "", officialEmail: "", contactPhone: "", otherPhone: "", stageName_ar: "", city: "", biography: "", biography_ar: "", geners_ar: "", id: 0, userID: 0, geners: "")
        }
    }
   
    func getArtistTalent()->Artist_Talent
    {
        if artist_talent?.count ?? 0>0
        {
            return artist_talent?[0] ?? Artist_Talent.init(geners: "", geners_ar: "", id: 0, user_id: 0,speciality: "",speciality_ar: "")
        }
        else
        {
            return Artist_Talent.init(geners: "", geners_ar: "", id: 0, user_id: 0,speciality: "", speciality_ar: "")
            
        }
    }
    
    func getArtistTalentSpecialities()->[String]{
        let artistTalent:Artist_Talent = getArtistTalent()
        var artistSpecialities: [String]? = []
        
        if DataManager.getLanguage == Language.arabic.rawValue{
                artistSpecialities = artistTalent.speciality_ar?.components(separatedBy: ",") ?? []
            artistSpecialities?.reverse()
            }else{
                artistSpecialities = artistTalent.speciality?.components(separatedBy: ",") ?? []
        }
        
        return artistSpecialities ?? []
    }
    
    func getRange() -> String {
        let rate = packages.get(index: 0)?.isRange ?? ""
        
        return packages.get(index: 0)?.isRange ?? ""
    }
}

    // MARK: - ArtistImage
    struct ArtistImage: Codable {
        let profileImage, coverImage: String
        let id, userID: Int
        let videoLinks : String?

        enum CodingKeys: String, CodingKey {
            case profileImage, coverImage, id
            case userID = "user_id"
            case videoLinks
        }
    }

    // MARK: - ArtistInfo
    struct ArtistInfo: Codable {
        let stageName, officialEmail, contactPhone, otherPhone: String?
        let stageName_ar : String?
        let city, biography: String?
        let biography_ar : String?
        let geners_ar : String?
        let id, userID: Int?
        let geners : String?

        enum CodingKeys: String, CodingKey {
            case stageName, officialEmail, contactPhone, otherPhone, city, biography, id
            case userID = "user_id"
            case geners
            case geners_ar
            case biography_ar
            case stageName_ar
        }
    }

    // MARK: - Package
    struct Package: Codable {
        let instrumentType:String?
        let events: String
        let instrumentType_ar : String?
        let addInfo_ar : String?
        let id, userID,audienceCountFrom,audienceCountTo,playTimeFrom,playTimeTo: Int?
        let timeType:String?
        let isRange: String?
        let goToSing: String?
        let musiciansCount, bandMembersCount, instrumentCount, audienceCount: Int?
        let addInfo: String?
        let playTime: Double?
        let eventPrice: Double?
        let perHour:Int? //range for playtime dropdown
        let artist : Artist?
        let offer:String?
        let offer_ar:String?
        
        
        enum CodingKeys: String, CodingKey {
            case instrumentType_ar = "instrumentType_ar"
            case addInfo_ar = "addInfo_ar"
            case instrumentType, events, id,audienceCountFrom,audienceCountTo,playTimeFrom,playTimeTo
            case userID = "user_id"
            case isRange = "isRange"
            case timeType = "timeType"
            case perHour
            case goToSing, musiciansCount, bandMembersCount, instrumentCount, audienceCount, addInfo, playTime, eventPrice,artist
            case offer,offer_ar
        }
        
    }

// MARK: - Artist
struct Artist: Codable {
    let name, email: String
    let id: Int
    let role_id: Int?
    let categories: Categories?
    let artistImages: [ArtistImage]?
    let artistInfo : [ArtistInfo]?

    enum CodingKeys: String, CodingKey {
        case name, email, id, categories
        case artistImages = "artist_images"
        case artistInfo = "artist_info"
        case role_id
    }
}


// MARK: - Categories
struct Categories: Codable {
    let id: Int
    let name_ar : String?
    let name, image, categoriesDescription: String

    enum CodingKeys: String, CodingKey {
        case id, name, image,name_ar
        case categoriesDescription = "description"
    }
}


struct Artist_Talent: Codable {
    let geners:String?
    let geners_ar : String?
    let id:Int?
    let user_id:Int?
    let speciality: String?
    let speciality_ar: String?
   

    enum CodingKeys: String, CodingKey {
        case geners
        case geners_ar
        case id
        case user_id
        case speciality
        case speciality_ar
   
    }
}

struct Artist_Intro:Codable{
    let video: String
    let thumbnail: String
    let id: Int
    let artist_id: Int
    
    enum CodingKeys: String, CodingKey {
        case video
        case thumbnail
        case id
        case artist_id
    }
}
