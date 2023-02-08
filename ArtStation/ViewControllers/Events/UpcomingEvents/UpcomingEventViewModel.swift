//
//  UpcomingEventViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/30/21.
//

import Foundation

class UpcomingEventViewModel{
    
    private(set) var bookings : [Booking] = []
    private(set) var pageCount : Int?
    
    
    func resetBookingsData(){
        bookings = []
        pageCount = 0
    }
    func getUpcomingEventList(pagingParams : PaginationParams,onCompletionHandler : @escaping (Bool,String?) -> Void){
        
        let bookingApi = APIManager.sharedInstance.bookingApi
        
        bookingApi.getUpcomingBookings(urlPagingParams: pagingParams, onSuccess: {
            responseData in
            debugPrint(String(data: responseData!, encoding: .utf8))
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
    
    
    
}
