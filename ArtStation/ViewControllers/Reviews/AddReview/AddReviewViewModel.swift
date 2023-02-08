//
//  AddReviewViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 7/2/21.
//

import Foundation


class AddReviewViewModel{
    
    
    func addReview(apiRequest : AddReviewApiRequest,onCompletionCallback : @escaping (Bool,String?) -> Void){
        
        if apiRequest.comment.isEmpty{
            onCompletionCallback(false,"Review cannot be empty")
            return
        }
        
        do{
            let data = try JSONEncoder().encode(apiRequest)
            let bodyParams = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.reviewApi.postReview(params: bodyParams, onSuccess: { response in
                
                do{
                 
                    let  apiResponse = try JSONDecoder().decode(ApiResponse<AddReviewApiResponse>.self, from: response!)
                    if apiResponse.status == 401{
                        Utils.logOut()
                    }
                    if  apiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,apiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                           
                            onCompletionCallback(true,apiResponse.message)
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



struct AddReviewApiRequest : Encodable{
    
    let comment : String
    let rating : Double
    let packageId : Int
    
    enum CodingKeys : String, CodingKey{
        case packageId = "artist_id"
        case comment,rating
    }
    
}

struct AddReviewApiResponse: Codable {
    let id, packageID: Int
    let comment: String
    let rating, userID: Int
    let updatedAt, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case packageID = "artist_id"
        case comment, rating
        case userID = "user_id"
        case updatedAt, createdAt
    }
}
