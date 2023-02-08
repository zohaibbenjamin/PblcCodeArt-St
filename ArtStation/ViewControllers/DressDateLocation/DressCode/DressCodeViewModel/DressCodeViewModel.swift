//
//  DressCodeViewModel.swift
//  ArtStation
//
//  Created by Apple on 02/07/2021.
//
import Foundation


class DressCalendarViewModel{
    
    var dataObj:DressCodeApiData?
    func getArtistCalendarData(params:[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){
   
        do{
        
            let data = try JSONEncoder().encode(params as? [String:String])
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.bookArtistAPI.getArtistCalendar(params: params, onSuccess: { response in
                
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<DressCodeApiData>.self, from: response!)
                    self.dataObj = loginApiResponse.data
                    //Parse Api Response
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            onCompletionCallback(true,nil)
                        }
                    }
                 }
                catch DecodingError.keyNotFound(let key, let context) {
                   debugPrint("could not find key \(key) in JSON: \(context)")
                    onCompletionCallback(false,"Unknown Server Error")
               } catch DecodingError.valueNotFound(let type, let context) {
                  print("could not find type \(type) in JSON: \(context.debugDescription)")
                onCompletionCallback(false,"Unknown Server Error")
               } catch DecodingError.typeMismatch(let type, let context) {
                   print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                onCompletionCallback(false,"Unknown Server Error")
               } catch DecodingError.dataCorrupted(let context) {
                   print("data found to be corrupted in JSON: \(context.debugDescription)")
                onCompletionCallback(false,"Unknown Server Error")
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
    
    func BookNewArtist(param :[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){

        do{
            print(BookingNow.sharedInstance)
            let data = try JSONEncoder().encode(BookingNow.sharedInstance)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.bookArtistAPI.BookNew(params: params, onSuccess: { response in
                
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<BookNewApiData>.self, from: response!)
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                           
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
    
    func BookNewArtistV2(param :[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){

        do{
            print(customBookingV2.sharedInstance)
            let data = try JSONEncoder().encode(customBookingV2.sharedInstance)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.bookArtistAPI.BookNewV2(params: params, onSuccess: { response in
                
                let res = String(data:response!,encoding: .utf8)
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<BookNewApiData>.self, from: response!)
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {
                           
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
    
    //MARK: - submit custom package request
    func SubmitCustomPackageRequest(param :[String:Any],onCompletionCallback : @escaping (Bool,String?) -> Void){

        do{
            print(param)
//            let data = try JSONEncoder().encode(param)
//            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.bookArtistAPI.submitCustomPackageRequest(params: param, onSuccess: { response in
                
                let res = response
                
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<String>.self, from: response!)
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {

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
    
    //MARK: - submit custom package request
    func SubmitCustomPackageRequest2(param :customBooking,onCompletionCallback : @escaping (Bool,String?) -> Void){
<<<<<<< HEAD
        if !(customBooking.sharedInstance.instrumentType.count>0){
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
           if !(customBooking.sharedInstance.preferredAudienceCount>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
           if !(customBooking.sharedInstance.eventPlace.count>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
           if !(customBooking.sharedInstance.eventInfo.count>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
           if !(customBooking.sharedInstance.playTime>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
           if !(customBooking.sharedInstance.eventDate.count>0){
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
           if !(customBooking.sharedInstance.eventTime.count>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
        if !(customBooking.sharedInstance.dress_code.count>0){
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
            if !(customBooking.sharedInstance.event_type.count>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
=======
        
        if !(customBooking.sharedInstance.instrumentType.count>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
            if !(customBooking.sharedInstance.preferredAudienceCount>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
            if !(customBooking.sharedInstance.eventPlace.count>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
            if !(customBooking.sharedInstance.eventInfo.count>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
            if !(customBooking.sharedInstance.playTime>0) {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
            if !(customBooking.sharedInstance.eventDate.count>0)
            {
                onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
                return
            }
           if !(customBooking.sharedInstance.eventTime.count>0)
            {
                onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
                return
            }
           if !(customBooking.sharedInstance.dress_code.count>0)
            {
                onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
                return
            }
        if !(customBooking.sharedInstance.event_type.count>0)
            {
                onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
                return
            }
>>>>>>> MR_freature_updates-temp
        if !(customBooking.sharedInstance.eventAddress.count>0)
        {
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
        
        if !(customBooking.sharedInstance.price>0){
            onCompletionCallback(false, Utils.localizedText(text:"Please write the custom package details"))
            return
        }
        
        do{
            print(param)
            let data = try JSONEncoder().encode(param)
            let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            
            APIManager.sharedInstance.bookArtistAPI.submitCustomPackageRequest(params: params, onSuccess: { response in
                
                let res = String(data: response!, encoding: .utf8)
                do{
                    let loginApiResponse = try JSONDecoder().decode(ApiResponse<String>.self, from: response!)
                    if loginApiResponse.status != 200{
                        DispatchQueue.main.async {
                            onCompletionCallback(false,loginApiResponse.message)
                        }
                    }else{
                        DispatchQueue.main.async {

                            onCompletionCallback(true,loginApiResponse.message)
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
    
    
    
    func rescheduleBooking(bookingId : Int,apiRequest : RescheduleEventApiRequest,onCompletionCallback : @escaping (Bool,String?)-> Void){
        
        do{
            let data = try JSONEncoder().encode(apiRequest)
            let bodyParams = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            APIManager.sharedInstance.bookArtistAPI.rescheduleEvent(bookingId: bookingId,bodyParams: bodyParams, onSuccess: { response in
                
                do{
                 
                    let  apiResponse = try JSONDecoder().decode(ApiResponse<JSONAny>.self, from: response!)
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
                catch DecodingError.keyNotFound(let key, let context) {
                   debugPrint("could not find key \(key) in JSON: \(context)")
                    onCompletionCallback(false,"Unknown Server Error")
               } catch DecodingError.valueNotFound(let type, let context) {
                  print("could not find type \(type) in JSON: \(context.debugDescription)")
                onCompletionCallback(false,"Unknown Server Error")
               } catch DecodingError.typeMismatch(let type, let context) {
                   print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                onCompletionCallback(false,"Unknown Server Error")
               } catch DecodingError.dataCorrupted(let context) {
                   print("data found to be corrupted in JSON: \(context.debugDescription)")
                onCompletionCallback(false,"Unknown Server Error")
               }
                catch let error{
                    DispatchQueue.main.async {
                        onCompletionCallback(false,error.localizedDescription)
                    }
                }
            }, onFailure: { error in
            DispatchQueue.main.async {
                onCompletionCallback(false,error.localizedDescription + "1")
            }
        })
        }
        catch let error{
            onCompletionCallback(false,error.localizedDescription + "2")
        }
        
        
        
        
    }
    
}

    



// MARK: - Welcome
struct RescheduleEventApiRequest: Codable {
    let startDate, startTime: String
    let latitude, longitude: Double
    let address : String

    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case startTime = "start_time"
        case latitude, longitude
        case address
    }
}

struct RescheduleBookingDataClass: Codable {
    let id, userID, packageID, amount: Int
    let status: String
    let paid: Bool
    let startTime, dressCode, eventType, eventSetup: String
    let lat, lng, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case packageID = "package_id"
        case amount, status, paid
        case startTime = "start_time"
        case dressCode = "dress_code"
        case eventType = "event_type"
        case eventSetup = "event_setup"
        case lat, lng, createdAt, updatedAt
    }
}
