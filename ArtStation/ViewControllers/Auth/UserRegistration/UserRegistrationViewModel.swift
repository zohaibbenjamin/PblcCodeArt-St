//
//  UserRegistrationViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/8/21.
//

import Foundation


class UserRegistrationViewModel{
    
    
    var categories : [String]?
    var categoriesList : [MusicCategory]?
    var cities : [String] = []
    
    var cityList : [City]?
    var userData : User?
   
    func getCityStringOfID(cityID:Int)->String
    {
        for item in cityList ?? [City]() {
            if item.id==cityID
            {
                return item.name
            }
        }
        return ""
    }
    
    
    func registerUser(request : UserRegistrationApiRequest,onCompletionHandler : @escaping (Bool,String?) -> Void){
        
        let userNameValidationResponse = ValidationManager.CheckStringForLetters(string: request.name)
        if !userNameValidationResponse.success{
            onCompletionHandler(false,userNameValidationResponse.error)
            return
        }
        let userEmailValidationResponse = ValidationManager.isValidEmailFormat(emailText: request.email)
        if !userEmailValidationResponse.success{
            onCompletionHandler(false,userEmailValidationResponse.error)
            return
        }
        if request.phone.isEmpty{
            let errorResponse = ""
            if DataManager.getLanguage == Language.arabic.rawValue{
                
            }
            onCompletionHandler(false,errorResponse)
            return
        }
        
        if request.phone.count < 13{
            let errorResponse = "Please enter a valid mobile number"
           
            onCompletionHandler(false,errorResponse)
            return
        }
    
        if request.city.isEmpty{
          //  let errorResponse = ""
            if DataManager.getLanguage == Language.arabic.rawValue{
                
            }
            onCompletionHandler(false,"City field cannot be empty")
            return
        }
        /*
        if request.userType == UserType.user.rawValue{
           // let errorResponse = ""
            if DataManager.getLanguage == Language.arabic.rawValue{
                
            }
        if request.DOB?.isEmpty ?? true{
            onCompletionHandler(false,"Dob field cannot be empty")
            return
        }
        }*/
        if request.user_type == UserType.artist.rawValue{
          //  var errorResponse = ""
            if DataManager.getLanguage == Language.arabic.rawValue{
                
            }
            if request.category == "-1"{
                onCompletionHandler(false,Utils.localizedText(text: "Category field cannot be empty"))
                return
            }
        }
        
        if request.user_type == UserType.user.rawValue{
        let userPasswordValidationResponse = ValidationManager.isValidPassword(request.password)
        if !userPasswordValidationResponse.success{
            onCompletionHandler(false,userPasswordValidationResponse.error)
            return
        }
        
//        if request.password != confirmPasswordText{
//            let errorResponse = Utils.localizedText(text: "Password and Confirm Password do not match")
//
//            onCompletionHandler(false,errorResponse)
//            return
//        }
        }
    
        do{
            let data = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.authenticationAPI.registerUser(params: params, onSuccess: {
                response in
                do{
                    
                    let res = String(data: response!,encoding: .utf8)
                    debugPrint(res)
                    let signUpApiResponse = try JSONDecoder().decode(ApiResponse<UserRegistrationApiDataClass>.self, from: response!)
                    //Parse Api Response
                    if signUpApiResponse.status != 200{
                        DispatchQueue.main.async{
                            onCompletionHandler(false,signUpApiResponse.message)
                        }
                    }
                    else{
                        
                        if request.user_type == UserType.user.rawValue{
                        self.userData = signUpApiResponse.data?.user
                        DataManager.setUserAuth = signUpApiResponse.data?.authToken
                         
                        }
                        
                        DispatchQueue.main.async {
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
                }
            })
        }
        catch let error{
            onCompletionHandler(false,error.localizedDescription)
        }
        
        
    }
    
    func getCities(onCompletionCallback : @escaping (Bool,String?) -> Void ){
        
        let authApi = APIManager.sharedInstance.authenticationAPI
        
        authApi.getCities(onSuccess: {
            response in
            do{ let apiResponse = try JSONDecoder().decode(ApiResponse<GetCitiesApiResponseDataClass>.self, from: response!)
            if apiResponse.status == 200{
                self.cityList = apiResponse.data?.list
                DispatchQueue.main.async {
                    DataManager.setCachedCityData = self.cityList
                    self.cities = []
                    for index in 0..<(apiResponse.data?.list.count ?? 0){
                        
                        if DataManager.getLanguage == Language.arabic.rawValue{
                            self.cities.append(apiResponse.data?.list[index].name_ar ?? "")
                        }else{
                            self.cities.append(apiResponse.data?.list[index].name ?? "")
                        }
                    }
                    onCompletionCallback(true,nil)
                    
                }
            }else{
                DispatchQueue.main.async {
                    onCompletionCallback(false,apiResponse.message)
                }
           
            }}
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
    
    
    
    func getCategories(rolltype:Int?,onCompletionCallback : @escaping (Bool,String?) -> Void ){
        
        let authApi = APIManager.sharedInstance.authenticationAPI
        
        authApi.getCategories(param:["role_id":rolltype!], onSuccess: {
            response in
            do{ let apiResponse = try JSONDecoder().decode(ApiResponse<GetCategoriesDataClass>.self, from: response!)
            if apiResponse.status == 200{
                self.categoriesList = apiResponse.data?.list
                DispatchQueue.main.async {
                    
                    self.categories = []
                    for index in 0..<(apiResponse.data?.list.count ?? 0){
                        self.categories?.append(apiResponse.data?.list[index].name ?? "")
                    }
                    onCompletionCallback(true,nil)
                    
                }
            }else{
                DispatchQueue.main.async {
                    onCompletionCallback(false,apiResponse.message)
                }
           
            }}
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
    
    
    func registerUserSocial(request : UserRegistrationApiRequest,onCompletionHandler : @escaping (Bool,String?) -> Void){
       
    
        do{
            let data = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.authenticationAPI.registerUserSocial(params: params, onSuccess: {
                response in
                do{
                    let signUpApiResponse = try JSONDecoder().decode(ApiResponse<JSONAny>.self, from: response!)
                    //Parse Api Response
                    if signUpApiResponse.status != 200{
                        DispatchQueue.main.async{
                            onCompletionHandler(false,signUpApiResponse.message)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            onCompletionHandler(true,nil)
                        }
                    }
                }
             
                catch let error{
                    DispatchQueue.main.async {
                        onCompletionHandler(false,error.localizedDescription)
                    }
                }
            }, onFailure: {
                error in
                DispatchQueue.main.async {
                    onCompletionHandler(false,error.localizedDescription)
                }
            })
        }
        catch let error{
            onCompletionHandler(false,error.localizedDescription)
        }
        
        
    }
    
    func loadCachedCitiesData(){
        
        
        let cityList = DataManager.getCachedCityData ?? []
        self.cityList = cityList
        self.cities = []
        for index in 0..<(cityList.count){
            
            if DataManager.getLanguage == Language.arabic.rawValue{
                self.cities.append(cityList[index].name_ar)
            }else{
                self.cities.append(cityList[index].name)
            }
        }
        
    }
    
}


struct GetCitiesApiResponseDataClass : Decodable{
    let list: [City]
}

// MARK: - List
struct City: Codable{
    let name: String
    let name_ar : String
    let id: Int
    let lat, lng: Double
    let status: String
    
}


// MARK: - DataClass
struct GetCategoriesDataClass: Decodable {
    let list: [MusicCategory]
}

// MARK: - List
struct MusicCategory: Decodable {
    let id: Int
    let name, listDescription, image, status: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case listDescription = "description"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}



