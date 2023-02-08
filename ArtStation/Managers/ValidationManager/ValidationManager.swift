//
//  ValidationManager.swift
//  pennyworth
//
//  Created by MamooN_ on 1/19/21.
//

import Foundation

struct ValidationManager {
    
    static func CheckStringForLetters(string:String) -> ValidationResponse{
        
       
        if string.isEmpty{
            return ValidationResponse(error: "Username field cannot be empty", success: false)
        }
        do{
               let regex = try NSRegularExpression(pattern: "^[a-zA-Z \\s\\p{Arabic} '-]*$", options: [])
               if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return ValidationResponse(error: nil, success: true)
            }
            else{
                return ValidationResponse(error:  "Username must contain only alphabets", success: false)
            }
        }
        catch let error{
            debugPrint(error.localizedDescription)
            return ValidationResponse(error: "", success: false)
   
        }
    }
    
    static func isValidEmailFormat(emailText:String)->ValidationResponse{
        
        let errorResponse =  "Please enter a valid email address"
       
        
        if emailText.isEmpty{
            return ValidationResponse(error: errorResponse, success: false)
            }
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: emailText) ? ValidationResponse(error: nil, success: true) : ValidationResponse(error: errorResponse, success: false)
    }
    
    static func isValidPassword(_ password : String) -> ValidationResponse{
        
      
        var errorResponse = "Password cannot be less than 6 characters"
       
        if password.isEmpty{
           return ValidationResponse(error: errorResponse, success: false)
        }else if password.count < 6{
            return ValidationResponse(error:errorResponse, success: false)
        
        }
        else if password.count > 20{
            errorResponse = "Password should not be more than 20 characters"
            return ValidationResponse(error: errorResponse, success: false)
        }
        else{
            return ValidationResponse(error: nil, success: true)
        }
    }
    
}
