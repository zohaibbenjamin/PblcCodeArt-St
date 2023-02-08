//
//  PastEventViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/30/21.
//

import Foundation

class PastEventViewModel{
    
    private(set) var bookings : [Booking] = []
    private(set) var pageCount : Int?
    func getPastEventList(urlPaginationParams : PaginationParams,onCompletionHandler : @escaping (Bool,String?) -> Void){
        
        let bookingApi = APIManager.sharedInstance.bookingApi
        
        bookingApi.getPastBookings(urlPagingParams: urlPaginationParams, onSuccess: {
            responseData in
            
            do{
                let apiResponse = try JSONDecoder().decode(ApiResponse<BookingData>.self, from: responseData!)
                if apiResponse.status == 401{
                    Utils.logOut()
                }
                if apiResponse.status != 200{
                    DispatchQueue.main.async {
                        onCompletionHandler(false,apiResponse.message)
                    }
                }
                else{
                    self.bookings.append(contentsOf: apiResponse.data?.booking ?? [])
                    self.pageCount = apiResponse.data?.pagination.pages
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
    
    
    
}
