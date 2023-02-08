//
//  ArtistProfileViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/15/21.
//

import Foundation
import UIKit


class ArtistProfileViewModel{
    
    
    var artistData : GetArtistDetailApiResponse?

    func getDataForArtistProfile(request : GetArtistDetailApiRequest , onCompletionHandler : @escaping (Bool,String?) -> Void){
        
        
        do{
            let data = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.artistProfileApi.getArtistProfile(params: params, onSuccess: {
                response in
                do{
                    let data = String.init(data: response!, encoding: .utf8)
                    print(data)
                   
                    let apiResponse = try JSONDecoder().decode(ApiResponse<[GetArtistDetailApiResponse]>.self, from: response!)
                    //Parse Api Response
                    if apiResponse.status == 401{
                        Utils.logOut()
                    }
                    if apiResponse.status != 200{
                        DispatchQueue.main.async{
                            
                            onCompletionHandler(false,apiResponse.message)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.artistData = apiResponse.data![0]
                            debugPrint("GENRE",self.artistData?.artist_talent)
                            onCompletionHandler(true,nil)
                        }
                    }
                }
            
                catch let error{
                    debugPrint(error)
                    DispatchQueue.main.async {
                        onCompletionHandler(false,error.localizedDescription)
                    }
                }
            }, onFailure: {
                error in
                DispatchQueue.main.async {
                    onCompletionHandler(false,error.localizedDescription)
                }
                debugPrint(error)
            })
        }
        catch let error{
            onCompletionHandler(false,error.localizedDescription)
        }
        
    }
    
    func getArtistImages(artistId : Int,onCompletionHandler : @escaping (Bool,String?,[ArtistGalleryImage]?) -> Void){
        
        let api = APIManager.sharedInstance.artistProfileApi
        api.getArtistGalary(artistId: artistId, onSuccess: {
            response in
            
            let data = String.init(data: response! , encoding: .utf8)
            
            do{
                let apiResponse = try JSONDecoder().decode(ApiResponse<GetArtistImagesApiResponse>.self, from: response!)
                
                if apiResponse.status == 401{
                    Utils.logOut()
                }else if apiResponse.status == 200{
                    DispatchQueue.main.async {
                        onCompletionHandler(true,nil,apiResponse.data?.list)
                    }
                }
                
            }catch let error{
                DispatchQueue.main.async {
                    onCompletionHandler(false,error.localizedDescription,nil)
                }
            }
            
        }, onFailure: {
            error in
            DispatchQueue.main.async {
                onCompletionHandler(false,error.localizedDescription,nil)
            }
        })
    }
    
    func cliamBooking(param :[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){

        do{
            print(param)

            APIManager.sharedInstance.bookArtistAPI.cliamBookingRequest(params: param, onSuccess: { response in
                
                let res = String(data: response!, encoding: .utf8)
            debugPrint(res)
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<claimBookingResponse>.self, from: response!)
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            onCompletionCallback(true,"")
                        }
                    }
                 }
                catch let error{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,error.localizedDescription)
                    }
                }
            }, onFailure: { error in
            DispatchQueue.main.async {
                onCompletionCallback(false,error.localizedDescription)
            }
        })
        }
        catch let error{
            onCompletionCallback(false,error.localizedDescription)
        }
       }
}


struct GetArtistDetailApiRequest : Encodable{
    let artistId : String
    let type: String
    enum CodingKeys : String,CodingKey{
        case artistId = "artist_id"
        case type
    }
}



// MARK: - DataClass
struct GetArtistImagesApiResponse: Codable {
    let list: [ArtistGalleryImage]
    let pagination: Pagination
}

// MARK: - List
struct ArtistGalleryImage: Codable {
    let file, fileURL: String
    let id, artistID: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case file
        case fileURL = "file_url"
        case id
        case artistID = "artist_id"
        case type
    }
}
