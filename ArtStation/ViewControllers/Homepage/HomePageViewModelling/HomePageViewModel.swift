//
//  HomePageViewModel.swift
//  ArtStation
//
//  Created by Apple on 14/06/2021.
//

import Foundation


class HomePageViewModel{
    
    var dataObj:[MusicArtistCategory] = []
    private(set) var pageCount : Int?
    
    func resetData(){
        pageCount = 0
        dataObj = []
    }
    func getHomeData(cityId : Int,paginationParams: PaginationParams,params:[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){
   
        do{
        
            let data = try JSONEncoder().encode(params as? [String:String])
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.homePageAPI.getHomePageArtistCategory(cityId: cityId, paginationParams: paginationParams, params: params, onSuccess:
            { response in
                let res = String(data: response!, encoding: .utf8)
                debugPrint(res)
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<HomePageApiResponse>.self, from: response!)
                    self.dataObj = (loginApiResponse.data?.list ?? [])
                    debugPrint(self.dataObj)
                    self.pageCount = loginApiResponse.data?.pagination.pages ?? 0
                        //Parse Api Response
                        if loginApiResponse.status != 200{
                            if loginApiResponse.status == 401
                            {
                                Utils.logOut()
                            }
                        DispatchQueue.main.async {
                
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                        
                        }
                        else{
                        DispatchQueue.main.async {
                            onCompletionCallback(true,nil)
                        }
                    }
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
    
    
    func getVat(){
        
        let homeApi = APIManager.sharedInstance.homePageAPI
        
        homeApi.getVat(onSuccess: {
            response in
            do{
                let apiResponse = try JSONDecoder().decode(ApiResponse<GetVatDataClass>.self, from: response!)
                DataManager.setVAT = String(apiResponse.data?.vatPercent ?? 0)
        }
            catch  _{
                DataManager.setVAT = "NotFound"
            }
            
        }, onFailure: {
            _ in
            DataManager.setVAT = "NotFound"
    
        })
        
    }
  
}

struct GetVatDataClass: Decodable {
    let vatPercent: Int?
 
}
