//
//  PaymentViewModel.swift
//  ArtStation
//
//  Created by Apple on 13/07/2021.
//

import Foundation



class PaymentViewModel{
    
    var dataObj:PaymentSuccessApiData?
    var promoData:PromoApiData?
    var artistName: String?
    var PayFortToken=NSDictionary()
    var payfortResponse=NSDictionary()
    var delegateCallBack:ProtocolPayfortCallBacks?
    var orderID : String?
    var orderPrice : Double?
    var emailUser : String?
    var paymentOption : String?
   
    var paymentParam : PaymentSuccess?
 
    func PaymentSuccessPromo(param :PaymentSuccessPromo,onCompletionCallback : @escaping (Bool,String?) -> Void){

        do{

            let data = try JSONEncoder().encode(param)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.paymentApi.paymentSuccessFul(params: params, onSuccess: { response in
                
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<PaymentSuccessApiData>.self, from: response!)
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.dataObj = loginApiResponse.data
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
    
    func applyPromo(param :[String:String],onCompletionCallback : @escaping (Bool,String?) -> Void){

        do{

            let data = try JSONEncoder().encode(param)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.paymentApi.PostPromo(params: params, onSuccess: { response in
                
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<PromoApiData>.self, from: response!)
                    
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.promoData = loginApiResponse.data
                            onCompletionCallback(true,loginApiResponse.message)
                        }
                    }
                 }
                catch DecodingError.keyNotFound(let key, let context) {
                   debugPrint("could not find key \(key) in JSON: \(context)")
                    DispatchQueue.main.async {
                        onCompletionCallback(false,"Invalid Promo Code")
                    }} catch DecodingError.valueNotFound(let type, let context) {
                  print("could not find type \(type) in JSON: \(context.debugDescription)")
                DispatchQueue.main.async {
                    onCompletionCallback(false,"Invalid Promo Code")
                }} catch DecodingError.typeMismatch(let type, let context) {
                   print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                DispatchQueue.main.async {
                    onCompletionCallback(false,"Invalid Promo Code")
                } } catch DecodingError.dataCorrupted(let context) {
                   print("data found to be corrupted in JSON: \(context.debugDescription)")
                DispatchQueue.main.async {
                    onCompletionCallback(false,"Invalid Promo Code")
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


struct PaymentSuccessApiData: Decodable {
    let id,booking_id,user_id,package_id,artist_id,vatPercent:Int?
    let amount,discount,vatAmount,netAmount:Double?
    let payment_id:Int?

    enum CodingKeys: String, CodingKey {
       
        case id,booking_id,user_id,package_id,artist_id,vatPercent
        case amount,discount,vatAmount,netAmount
            case payment_id
        
    }
    
}


struct PromoApiData: Decodable {
    let id:Int
        //,redemptions,redeemed,per_user:Int?
    
    let discount_value:Double?
    
    let created_at,updated_at,name,name_ar,discount_type,image,description,description_ar,exclusion_status,availability_type,availability_duration,to_time,promo_code,calculation_type,status,renew:String?

    enum CodingKeys: String, CodingKey {
       
        case id
             //,redemptions,redeemed,per_user
        
        case discount_value
        
        case created_at,updated_at,name,name_ar,discount_type,image,description,description_ar,exclusion_status,availability_type,availability_duration,to_time,promo_code,calculation_type,status,renew

        
    }
    
}
