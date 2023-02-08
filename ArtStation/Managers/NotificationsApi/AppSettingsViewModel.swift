//
//  AppSettingsViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 7/8/21.
//

import UIKit

class AppSettingsViewModel {

    func changeAppLanguage(selectedLanguage: String,onCompletionCallback: @escaping (Bool,String?) -> Void){
        
        
        let api = APIManager.sharedInstance.changeLanguageApi
        let languageParam = ["language":selectedLanguage]
        api.changeLanguage(params: languageParam, onSuccess: {
            response in
            
            do{
                let apiResponseJson = try JSONDecoder().decode(ApiResponse<[JSONAny]>.self, from: response!)
                if apiResponseJson.status == 401{
                    Utils.logOut()
                }else if apiResponseJson.status == 200{
                    DataManager.setLanguage = selectedLanguage
                    DispatchQueue.main.async {
                        onCompletionCallback(true,nil)
                    }
                }
                else{
                   DispatchQueue.main.async {
                        onCompletionCallback(false,apiResponseJson.message)
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

