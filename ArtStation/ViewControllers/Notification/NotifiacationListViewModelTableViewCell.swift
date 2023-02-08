//
//  NotifiacationListViewModelTableViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 7/7/21.
//

import Foundation

class NotifiacationListViewModel{
    
    private(set) var notificationList : [PushNotificationArtStation] = []
     private(set) var pageCount : Int?
        
    
    func resetViewModelData(){
        notificationList = []
        pageCount = 0
    }
        func getAllNotifications(paginationParams : PaginationParams,onCompletionHandler : @escaping (Bool,String?) -> Void){
            let notificationApi = APIManager.sharedInstance.notificationApi
           
            //
            notificationApi.getNotifications(urlPagingParams:paginationParams,onSuccess: {
                responseData in
                
                do{
                    let apiResponse = try JSONDecoder().decode(ApiResponse<NotificationApiDataClass>.self, from: responseData!)
                    if apiResponse.status == 401{
                        Utils.logOut()
                    }
                    if apiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionHandler(false,apiResponse.message)
                        }
                    }
                    else{
                        self.notificationList.append(contentsOf:apiResponse.data?.list ?? [])
                        debugPrint(self.notificationList.count,"CountOfNotifications")
                        self.pageCount = apiResponse.data?.pagination.pages
                    
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
        
}


struct NotificationApiDataClass: Codable {
    let list: [PushNotificationArtStation]
    let pagination: Pagination
}

// MARK: - List
struct PushNotificationArtStation: Codable {
    let id: Int?
//    let adminID: JSONNull?
//    let userID: Int?
//    let generateID: JSONNull?
//    let bookingID: Int?
    let title, message, status, createdAt: String?
    let updatedAt: String?
    let title_ar,message_ar: String?

    enum CodingKeys: String, CodingKey {
        case id
//        case adminID = "admin_id"
//        case userID = "user_id"
//        case generateID = "generate_id"
//        case bookingID = "booking_id"
        case title, message, status,title_ar,message_ar
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

