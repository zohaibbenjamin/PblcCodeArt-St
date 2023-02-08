//
//  SetNewPasswordViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/14/21.
//

import Foundation




class SetNewPasswordViewModel{

    enum CallFor{
        case verifyOtp
        case updatePasscode
    }
    
    func validateOtp<Request : Encodable>(provideUrlFor : CallFor,request : Request,onCompletionHandler : @escaping (Bool,String?) -> Void){
        
        
       
        // Call Api to send OTP Code
        do{
            let data = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            let url = provideUrlFor == .verifyOtp ? ApiEndpoint.verifyOtpCodeEndpoint : ApiEndpoint.resetPasswordEndpoint
            APIManager.sharedInstance.authenticationAPI.validateOtpCodeOrResetPasscode(endpoint: url,params: params, onSuccess: {
                response in
                do{
                    let apiResponse = try JSONDecoder().decode(ApiResponse<JSONNull>.self, from: response!)
                    //Parse Api Response
                    if apiResponse.status != 200{
                        DispatchQueue.main.async{
                            onCompletionHandler(false,apiResponse.message)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            onCompletionHandler(true,apiResponse.message)
                        }
                    }
                }
                catch DecodingError.keyNotFound(let key, let context) {
                   debugPrint("could not find key \(key) in JSON: \(context)")
                    onCompletionHandler(false,"Unknown Server Error")
               } catch DecodingError.valueNotFound(let type, let context) {
                  print("could not find type \(type) in JSON: \(context.debugDescription)")
                onCompletionHandler(false,"Unknown Server Error")
               } catch DecodingError.typeMismatch(let type, let context) {
                   print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                onCompletionHandler(false,"Unknown Server Error")
               } catch DecodingError.dataCorrupted(let context) {
                   print("data found to be corrupted in JSON: \(context.debugDescription)")
                onCompletionHandler(false,"Unknown Server Error")
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
    
}



// MARK: - ForgotPasswordApiRequest
struct ValidateOtpApiRequest: Encodable {
    
    let emailAddress : String
    let otpCode : String
    let type : String
    
    enum CodingKeys : String, CodingKey {
        case emailAddress = "email"
        case otpCode = "code"
        case type = "type"
    
    }
}

//MARK:- UpdatePasswordRequest

struct UpdatePasswordApiRequest: Encodable {
    
    let emailAddress : String
    let password : String
    
    enum CodingKeys : String, CodingKey {
        case emailAddress = "email"
        case password
    }
}
