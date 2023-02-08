//
//  ProfileViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 7/5/21.
//

import Foundation

class ProfileViewModel{
    
    private(set) var profileData : ProfileDataClass?
    var updatedCityId : Int?
    
    
    func getProfile(onCompletionHandler : @escaping (Bool,String?) -> Void){
        
        let api = APIManager.sharedInstance.authenticationAPI
        
        api.getUserProfile(onSuccess: { response in
            do{
                let apiResponse = try JSONDecoder().decode(ApiResponse<ProfileDataClass>.self, from: response!)
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
                        self.profileData = apiResponse.data!
                        onCompletionHandler(true,nil)
                    }
                }
            }
         
            catch let error{
                DispatchQueue.main.async {
                    onCompletionHandler(false,error.localizedDescription)
                    debugPrint(error)
                }
            }
        }, onFailure: {
            error in
            DispatchQueue.main.async {
                onCompletionHandler(false,error.localizedDescription)
                debugPrint(error)
            }
        })
        
    }
    
    func updateUserProfile(request : UpdateProfileApiRequest, onCompletionCallback : @escaping (Bool,String?) -> Void){
        
        let nameValidation = ValidationManager.CheckStringForLetters(string: request.name)
        if !nameValidation.success{
            onCompletionCallback(false,nameValidation.error)
            return
        }
        
        let emailValidation = ValidationManager.isValidEmailFormat(emailText: request.email)
        
        if !emailValidation.success{
            onCompletionCallback(false,emailValidation.error)
            return
        }
        
        
        if request.phone.count < 13{
            let errorResponse = "Please enter a valid mobile number"
          
            onCompletionCallback(false,errorResponse)
            return
        }
       
        let phonenum = request.phone.dropFirst(4)
        
        if !(phonenum.hasPrefix("5")){
            let errorResponse = "Please enter your phone number starting with 5"
          
            onCompletionCallback(false,Utils.localizedText(text: errorResponse))
            return
        }
        
      
        
        let api = APIManager.sharedInstance.authenticationAPI
        do{
            let data = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            api.updateUserProfile(bodyParams: params, onSuccess: {
                response in
              
                
                let res = String(data: response!, encoding: .utf8)
                do{
                    let apiResponse = try JSONDecoder().decode(ApiResponse<User>.self, from: response!)
                    if apiResponse.status == 401{
                        Utils.logOut()
                    }
                    if apiResponse.status != 200{
                        DispatchQueue.main.async {
                            
                            onCompletionCallback(false,apiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            
                            DataManager.setUserData = apiResponse.data
                            onCompletionCallback(true,apiResponse.message)
                        }
                    }
                 }
                catch let error{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,error.localizedDescription)
                    }

                    debugPrint(error)
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


struct UpdateProfileApiRequest : Encodable{
    var name, email, phone : String
      let city_id: Int
      //let DOB: String?
 }

struct UpdateProfileApiResponse : Decodable{
    
}

struct ProfileDataClass: Codable {
    let name, email: String
    var phone: String?
    let id: Int
    let categoryID, type: JSONAny?
    let band, solo: Bool
    var city : String?
    var dob: String?
    let deviceToken: DeviceToken?
    let rating: Double
    let status, verified: String
    let cityID: Int?
    let userType: String?

    enum CodingKeys: String, CodingKey {
        case name, phone, email, id
        case categoryID = "category_id"
        case type, band, solo, city
        case dob = "DOB"
        case deviceToken = "device_token"
        case rating, status, verified
        case cityID = "city_id"
        case userType
    }
}
