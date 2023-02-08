//
//  EventConfirmationViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 7/6/21.
//

import Foundation


class EventConfirmationViewModel{
    
    
    
    func cancelBooking(withId id : Int,onCompletionHandler : @escaping (Bool,String?)->Void){
        
        let api = APIManager.sharedInstance.bookArtistAPI
        api.cancelBooking(bookingId: id, onSuccess: {
            response in
            do{
                let apiResponse = try JSONDecoder().decode(ApiResponse<JSONAny>.self, from: response!)
                
                if apiResponse.status == 401{
                    Utils.logOut()
                }else if apiResponse.status == 200{
                    DispatchQueue.main.async {
                        onCompletionHandler(true,apiResponse.message)
                    }
                }else{
                    DispatchQueue.main.async {
                        onCompletionHandler(false,apiResponse.message)
                    }
                }
                
            }
            catch let error{
                DispatchQueue.main.async {
                    onCompletionHandler(false,error.localizedDescription)
                }
            }
        },
        onFailure: {
            error in
            onCompletionHandler(false,error.localizedDescription)
        })
        
        
    }
    
    func getInvoice(urlType: String,withId id : Int,onCompletionCallback : @escaping (Bool,String?) -> Void){
        
        let api = APIManager.sharedInstance.bookingApi
        api.getInvoice(invoiceId: id, onSuccess: {
            response in
            do{
                
                let str = String.init(data: response!, encoding: .utf8)
                
                let apiResponse = try JSONDecoder().decode(ApiResponse<InvoiceApiResponse>.self, from: response!)
                
                if apiResponse.status == 401{
                    Utils.logOut()
                }else if apiResponse.status == 200{
                    DispatchQueue.main.async {
                        if urlType == "read"{
                        onCompletionCallback(true,apiResponse.data?.bucketurl ?? "")
                        }else{
                            onCompletionCallback(true,apiResponse.data?.bucketurl ?? "")
                       
                        }
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
    
    
    
    func expireBookingWithId(bookingId : Int){
        
        APIManager.sharedInstance.bookingApi.expireBooking(bookingId: bookingId, onSuccess: {
            response in
            debugPrint(response)
        }, onFailure: {
            error in
            debugPrint(error)
        })
        
    }
}


// MARK: - Welcome
struct InvoiceApiResponse: Codable {
    let readurl: String
    let bucketurl: String
}
