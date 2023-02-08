//
//  AllReviewsViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 7/2/21.
//

import Foundation

class AllReviewsViewModel{
    
    private(set) var allReviewsList : [Review] = []
    private(set) var pageCount : Int?
    
    func resetData(){
        allReviewsList = []
        pageCount = 0
    }
    
    func getAllReviewsForPackage(paginationParams : PaginationParams,packageId : Int,onCompletionHandler : @escaping (Bool,String?) -> Void){
        let reviewApi = APIManager.sharedInstance.reviewApi
        var urlParams = ["artist_id":packageId]
        urlParams.merge(paginationParams.dictionary){
            (current, _) in current 
        }
        
        reviewApi.getAllReviewsForPackage(params:urlParams,onSuccess: {
            responseData in
            
            do{
                let apiResponse = try JSONDecoder().decode(ApiResponse<ReviewDataClass>.self, from: responseData!)
                if apiResponse.status == 401{
                    Utils.logOut()
                }
                if apiResponse.status != 200{
                    DispatchQueue.main.async {
                        onCompletionHandler(false,apiResponse.message)
                    }
                }
                else{
                    self.allReviewsList.append(contentsOf:apiResponse.data?.review ?? [])
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
