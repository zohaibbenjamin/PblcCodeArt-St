//
//  ApplePayPaymentViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 10/14/21.
//

import Foundation


class ApplePayPaymentViewModel{
    
    var paymentAmount: Double?
    var paidTo: String?
    var orderId: String?
    var artistName: String?
    var paymentParam : PaymentSuccess?
 
    func PaymentSuccess(param :PaymentSuccess,onCompletionCallback : @escaping (Bool,String?) -> Void){

        do{

            let data = try JSONEncoder().encode(param)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.paymentApi.paymentSuccessFul(params: params, onSuccess: { response in
                
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<JSONAny>.self, from: response!)
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                           // self.dataObj = loginApiResponse.data
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
        
    
    
    
}
