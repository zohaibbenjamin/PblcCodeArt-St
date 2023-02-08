//
//  ContactUsViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 7/6/21.
//

import Foundation

class ContactUsViewModel{
    
    private(set) var contactUsDetails : ContactUsDataClass?
    func getContactDetails(onCompletionCallback : @escaping (Bool,String?)->Void){
        
        let contactUsApi = APIManager.sharedInstance.contaactUsApi
        
        contactUsApi.getContactUsDetails(onSuccess: {
            response in
            
            do{
                let apiResponse = try JSONDecoder().decode(ApiResponse<[ContactUsDataClass]>.self, from: response!)
                if apiResponse.status == 401{
                    Utils.logOut()
                    
                }
                else if apiResponse.status == 200{
                    DispatchQueue.main.async {
                        self.contactUsDetails = apiResponse.data?[0]
                        onCompletionCallback(true,nil)
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
            
        }, onFailure:{ error in
            DispatchQueue.main.async {
                onCompletionCallback(false,error.localizedDescription)
            }
        }
        )
        
    }
    
    
    func subscribe(email : String,onCompletionCallback : @escaping (Bool,String?) -> Void){
        
        let emailValidationResponse = ValidationManager.isValidEmailFormat(emailText: email)
        if !emailValidationResponse.success{
            onCompletionCallback(false,emailValidationResponse.error)
            return
        }
        
        let api = APIManager.sharedInstance.contaactUsApi
        api.subscribe(bodyParams: ["subscriptionEmail":email], onSuccess: {
            response in
            do{
                let apiResponse = try JSONDecoder().decode(ApiResponse<JSONAny>.self, from: response!)
                if apiResponse.status == 401{
                    Utils.logOut()
                }
                if apiResponse.status == 200{
                    DispatchQueue.main.async {
                        onCompletionCallback(true,apiResponse.message)
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

// MARK: - Datum
struct ContactUsDataClass: Codable {
    let id: Int
    let email, number, website, createdAt: String
    let updatedAt: String
    let instagram : String
}
