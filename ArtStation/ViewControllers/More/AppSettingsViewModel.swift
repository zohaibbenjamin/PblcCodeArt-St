//
//  AppSettingsViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 7/8/21.
//

import UIKit

class AppSettingsViewModel {

    
    
    func updateNotificationSettings(onCompletionCallback : @escaping (Bool,String?) -> Void){
        
        let api = APIManager.sharedInstance.notificationApi
        
        api.changeNotificationSettings( onSuccess: {
            response in
            
            do{
                
                let apiResponse = try JSONDecoder().decode(ApiResponse<[JSONAny]>.self, from: response!)
                if apiResponse.status == 401{
                    Utils.logOut()
                }else if apiResponse.status == 200{
                    DispatchQueue.main.async {
                        onCompletionCallback(true,apiResponse.message)
                    }
                }else{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,apiResponse.message)
                    }
                }
                
            }
            catch let error{
                DispatchQueue.main.async {
                    onCompletionCallback(false,error.localizedDescription)
                }
            }
            
        }, onFailure: {
            error in
            DispatchQueue.main.async {
                onCompletionCallback(false,error.localizedDescription)
            }
        })
        
    }

}

