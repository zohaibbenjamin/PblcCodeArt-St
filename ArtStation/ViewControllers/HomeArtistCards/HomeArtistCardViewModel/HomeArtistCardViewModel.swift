//
//  HomeArtistCardViewModel.swift
//  ArtStation
//
//  Created by Apple on 15/06/2021.
//

import Foundation
import Alamofire

class HomeArtistCardViewModel{
    
    var dataObj:HomeArtistCardApiResponse?
    var favouriteArtistList:[FavouriteArtistModel]?
    var martistTalents:Artist_Talent?
    
    func getArtists(params:[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){
        
        do{
            let data = try JSONEncoder().encode(params as? [String:String])
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.artistProfileApi.getArtistCards(params: params, onSuccess: { response in
                let data = String.init(data: response!, encoding: .utf8)
                print(data)
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<HomeArtistCardApiResponse>.self, from: response!)
                    //Parse Api Response
                    if loginApiResponse.status == 401{
                        Utils.logOut()
                    }
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.dataObj=loginApiResponse.data
                            
                            self.favouriteArtistList = self.dataObj?.pin_artist_list ?? []
                            
                            onCompletionCallback(true,nil)
                        }
                    }
                }catch let decodingero as DecodingError{
                    debugPrint(decodingero)
                }
                catch DecodingError.keyNotFound(let key, let context) {
                    debugPrint("could not find key \(key) in JSON: \(context)")
                    onCompletionCallback(false,"Unknown Server Error")
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("could not find type \(type) in JSON: \(context.debugDescription)")
                    onCompletionCallback(false,"Unknown Server Error")
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                    onCompletionCallback(false,"Unknown Server Error")
                } catch DecodingError.dataCorrupted(let context) {
                    print("data found to be corrupted in JSON: \(context.debugDescription)")
                    onCompletionCallback(false,"Unknown Server Error")
                }
                catch let error{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,error.localizedDescription)
                        debugPrint(error)
                    }
                }
            }, onFailure: { error in
                DispatchQueue.main.async {
                    onCompletionCallback(false,error.localizedDescription)
                    debugPrint(error)
                }
            })
        }
        catch let error{
            onCompletionCallback(false,error.localizedDescription)
            debugPrint(error)
        }
    }
    
    func pinArtist(param :[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){
        
        do{
            print(param)
            //            let data = try JSONEncoder().encode(param)
            //            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.artistProfileApi.pinArtist(params: param) { response in
                let res = String(data:response! , encoding: .utf8)
                print(res)
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<FavouriteArtistModelResponse>.self, from: response!)
                    //Parse Api Response
                    if loginApiResponse.status == 401{
                        Utils.logOut()
                    }
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            //self.pinArtistsList?.append(loginApiResponse.data!)
                            onCompletionCallback(true,nil)
                        }
                    }
                }catch let decoderror as DecodingError{
                 debugPrint(decoderror)
                }
                catch DecodingError.keyNotFound(let key, let context) {
                    debugPrint("could not find key \(key) in JSON: \(context)")
                    onCompletionCallback(false,"Unknown Server Error")
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("could not find type \(type) in JSON: \(context.debugDescription)")
                    onCompletionCallback(false,"Unknown Server Error")
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                    onCompletionCallback(false,"Unknown Server Error")
                } catch DecodingError.dataCorrupted(let context) {
                    print("data found to be corrupted in JSON: \(context.debugDescription)")
                    onCompletionCallback(false,"Unknown Server Error")
                }
                catch let error{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,error.localizedDescription)
                    }
                }
            } onFailure: { er in
                onCompletionCallback(false, er.description)
            }
        }
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


