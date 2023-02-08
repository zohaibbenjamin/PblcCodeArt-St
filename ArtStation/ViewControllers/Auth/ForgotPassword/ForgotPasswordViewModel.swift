//
//  ForgotPasswordViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/14/21.
//

import Foundation


class ForgotPasswordViewModel{
    
    
    
    func sendOtpCodeTo(request : ForgotPasswordApiRequest, onCompletionHandler : @escaping (Bool,String?)->Void){
        
        let emailValidationResponse = ValidationManager.isValidEmailFormat(emailText: request.emailAddress)
        if !emailValidationResponse.success{
            onCompletionHandler(false,emailValidationResponse.error)
            return
        }
        // Call Api to send OTP Code
        do{
            let data = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.authenticationAPI.sendOtpCodeToEmail(params: params, onSuccess: {
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
                            onCompletionHandler(true,nil)
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
struct ForgotPasswordApiRequest: Encodable {
    
    let emailAddress : String
    
    enum CodingKeys : String, CodingKey {
        case emailAddress = "email"
    }
}

//MARK:- Update Password Request
