//
//  TabbarContainerViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/16/21.
//

import Foundation

class TabbarContainerViewModel{
    func getWeatherData(params:[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){
   
        do{
            let data = try JSONEncoder().encode(params as? [String:String])
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.homePageAPI.getWeatherData(params: params, onSuccess: { response in
                
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<[WeatherDataResponse]>.self, from: response!)
                    //Parse Api Response
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            DataManager.WeatherData=loginApiResponse.data?[0]
                            onCompletionCallback(true,nil)
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
    
    
    func checkForceUpdates(onCompletionCallback : @escaping (Bool,String?,forceUpdateResponseModel?) -> Void) {
        
        APIManager.sharedInstance.homePageAPI.getDetailsForceUpdate { response in
            
            let res = String(data: response!, encoding: .utf8)
            debugPrint(res)
            do{
                let loginApiResponse = try JSONDecoder().decode(ApiResponse<forceUpdateResponseModel>.self, from: response!)
                //Parse Api Response
                if loginApiResponse.status != 200{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,loginApiResponse.message,nil)
                    }
                }else{
                    DispatchQueue.main.async {
                        onCompletionCallback(true,nil,loginApiResponse.data)
                    }
                }
             }catch let error{
                DispatchQueue.main.async {
                    debugPrint(error)
                    onCompletionCallback(false,error.localizedDescription,nil)
                }
            }
        } onFailure: { error in
            debugPrint(error)
            onCompletionCallback(false,error.localizedDescription,nil)
        }
    }
}
