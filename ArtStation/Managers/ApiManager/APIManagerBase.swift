//
//  APIManagerBase.swift
//  TabibGroup_Swift
//
//  Created by Tahir Pasha on 30/11/2020.
//

import UIKit
import Alamofire

class APIManagerBase: NSObject
{
    var alamoFireManager : Session!
    let defaultRequestHeader = ["Content-Type": "application/json"]
    let defaultError = NSError(domain: "ACError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request Failed."])
    
    static var sharedInstance = APIManagerBase()

    
    override init()
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 6000
        configuration.timeoutIntervalForResource = 6000
        
        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
            "ec2-52-4-186-178.compute-1.amazonaws.com": DisabledTrustEvaluator()
            ]
        
        alamoFireManager = Alamofire.Session(configuration: configuration, serverTrustManager: ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: serverTrustPolicies))
        
    }
    
    //MARK:- Get Authorization Headers
     
     func getUserHeader ()  -> HTTPHeaders
     {
        let httpHeaders = HTTPHeaders(["Authorization" : ""] )
      
        return httpHeaders
        
     }
    
    
    //Some Changes to see if it happens in art station
    func getUserHeader ()  -> Dictionary<String,String>?
    {
        return nil
    }
    
    func getDefaultTokenHeader()  -> HTTPHeaders?
    {
        // Live  admin token
      //  let language : String =  Constants.TGDATA.appLanguage!.rawValue
       // let uid : String = Constants.TGDATA.userTG?.uid ?? ""
       // let httpHeaders = HTTPHeaders.init(["Authorization": Constants.DEFAULTTOKEN,"Accept":"application/json","lang": language,"Content-Type":"application/json","uid":uid])
        
        
     //   return httpHeaders
        return nil
    }
    
    
    func getErrorFromResponseData(data: Data) -> NSError?
    {
        do{
            let result = try JSONSerialization.jsonObject(with: data,options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String,AnyObject>>
            if let message = result?[0]["message"] as? String{
                let error = NSError(domain: "GCError", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                return error;
            }
        }catch{
            NSLog("Error: \(error)")
        }
        
        return nil
    }
    
    
    func URLforRoute(route: String,params:Parameters) -> NSURL? {
        
        if let components: NSURLComponents  = NSURLComponents(string: (route)){
            var queryItems = [NSURLQueryItem]()
            for(key,value) in params{
                queryItems.append(NSURLQueryItem(name:key,value: value as? String))
            }
            components.queryItems = queryItems as [URLQueryItem]?
            
            return components.url as NSURL?
        }
        
        return nil;
    }
    
    
    func URLforRoute (route :String) -> NSURL?
    {
    if let components: NSURLComponents  = NSURLComponents(string: (route)){
              
               
               return components.url as NSURL?
           }
           
           return nil;
    }
    
    
    func URLforRouteConcateId (route :String,appendId: String) -> NSURL?
       {
        
        let routeWithId : String = route + "/\(appendId)"
         if let components: NSURLComponents  = NSURLComponents(string: (routeWithId)){
                     
                      
                      return components.url as NSURL?
                  }
                  
                  return nil;
       }
    
    
    // Pass paramaters same as post request. (But in string)
    func GetURLwithParams(route:String, parameters: Parameters) -> URL?{
        var queryParameters = ""
     
        for key in parameters.keys {
            if queryParameters.isEmpty {
                if key == ""
                {
                      queryParameters =  "\(key)/\((String(describing: (parameters[key]!))).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
                }
                else
                {
                     queryParameters =  "?\(key)=\((String(describing: (parameters[key]!))).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
                }
              
                
            } else {
                queryParameters +=  "&\(key)=\((String(describing: (parameters[key]!))).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
            }
            queryParameters =  queryParameters.trimmingCharacters(in: .whitespaces)
            
        }
        if let components: NSURLComponents = NSURLComponents(string: (route+queryParameters)){
            return components.url! as URL
        }
        return nil
    }
    
    
    
    func postRequestWith(route: URL,parameters: [String: Any],
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure,
                         errorPopup: Bool){
        //POST request method changed for magento APIs
        let url = route
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 20.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        urlRequest.httpBody = jsonData
        let config = URLSessionConfiguration.default
        let urlsession = URLSession(configuration: config)
        
        let task = urlsession.dataTask(with: urlRequest){ (data, response, error) -> Void in
            
            guard error == nil else {
               // self.showErrorMessage(error: error!)
                failure(error! as NSError)
                return
            }
            guard let data = data,
                var json = try? (JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>) else {
                    success(Dictionary<String, AnyObject>())
                    print("Nil data received from fetchAllRooms service ")
                    return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                json["StatusCode"] = httpResponse.statusCode as AnyObject
            }
            
            print("JSON \(json)")
            success(json)
            
        }
        task.resume()
    }
    
    
    func postRequestDefaultTokenWith(route: URL,parameters: Parameters,
                                   success:@escaping ResultAPISuccessClosure,
                                   failure:@escaping DefaultAPIFailureClosure,headers : HTTPHeaders?){
        
        alamoFireManager.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON
            {
            response in
            
            guard response.error == nil else{
                print("error in calling post request")
               
                failure(response.error! as NSError)
                return;
            }
            if let value = response.value {
                print (value)
              
                
                if let jsonResponse = response.data {
                    success(jsonResponse)
                } else {
                    success(nil)
                }
            }
        }
    }
    
    func postRequestUserToken(route: URL,parameters: Parameters,
                                   success:@escaping ResultAPISuccessClosure,
                                   failure:@escaping DefaultAPIFailureClosure,header:HTTPHeaders){
        
        
        alamoFireManager.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON
            {
            response in
            
          //  debugPrint(response)
            guard response.error == nil else{
                print("error in calling post request")
               // self.showErrorMessage(error: response.error!)
                failure(response.error! as NSError)
                return;
            }
            if let value = response.value {
                print (value)
              
                
                if let jsonResponse = response.data {
                    //debugPrint(header)
                //    debugPrint(parameters)
                    success(jsonResponse)
                 //   success(Constants.UPDATA.getJsonData(data: jsonResponse))
                } else {
                    success(nil)
                }
            }
        }
    }
    
    
    func getRequestWithAlmofairWithOut(route: URL,parameters: Parameters,
                                       success:@escaping ResultAPISuccessClosure,
                                       failure:@escaping DefaultAPIFailureClosure) {
        
        alamoFireManager.request(route, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON
            {
            response in
            
            guard response.error == nil else{
                
                print("error in calling post request")
                //self.showErrorMessage(error: response.error!)
                failure(response.error! as NSError)
                
                return;
            }
        
            
            switch response.result {
                    
                    case .success(_):
                        if let jsonResponse = response.data {// as? Dictionary<String, AnyObject>{
                            
                            print(jsonResponse)
                            success(jsonResponse)
                        } else {
                            success(nil)
                        }
                        break
                    case .failure(let error):
                        print("Alamo error: \(error)")
                        break
                    }
            
            
            
        }
    }
 
    func getRequestWithUserTokenHeaderParam(route: URL,parameters: Parameters,headers:HTTPHeaders?,
                                 success:@escaping ResultAPISuccessClosure,
                                 failure:@escaping DefaultAPIFailureClosure) {
        
        var _ : String = route.absoluteString
        let urlWithParams : URL = GetURLwithParams(route: route.absoluteString, parameters: parameters)!
        debugPrint(urlWithParams)
        alamoFireManager.request(urlWithParams, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            
            guard response.error == nil else{
                
                print(response.value ?? "")
                print("error in calling get request \(response.error!)")
              //  self.showErrorMessage(error: response.error!)
                failure(response.error! as NSError)
                
                return;
            }
            
            switch response.result {
                    
                    case .success(_):
                        if let jsonResponse = response.data {
                          
                           
                            
                            print(response.value ?? "")
                            success(jsonResponse)
                            
                           
                        } else {
                            success(nil)
                        }
                        break
                    case .failure(let error):
                        print("Alamo error: \(error)")
                        break
                    }
            
        }
    }
    
    func getRequestWithUserTokenwithParams(route: URL,parameters: Parameters,
                                 success:@escaping ResultAPISuccessClosure,
                                 failure:@escaping DefaultAPIFailureClosure) {
        
        var _ : String = route.absoluteString
        let urlWithParams : URL = GetURLwithParams(route: route.absoluteString, parameters: parameters)!
        print(urlWithParams)

        alamoFireManager.request(urlWithParams, method: .get).responseJSON{
            response in
            
            guard response.error == nil else{
                
                print(response.value ?? "")
                print("error in calling get request \(response.error!)")
              //  self.showErrorMessage(error: response.error!)
                failure(response.error! as NSError)
                
                return;
            }
            
            switch response.result {
                    
                    case .success(_):
                        if let jsonResponse = response.data {
                          
                           
                            
                            print(response.value ?? "")
                            success(jsonResponse)
                            
                           
                        } else {
                            success(nil)
                        }
                        break
                    case .failure(let error):
                        print("Alamo error: \(error)")
                        break
                    }
            
        }
    }
    
    func getRequestWithUserTokenNoParams(route: URL,headers:HTTPHeaders?,
                                    success:@escaping ResultAPISuccessClosure,
                                    failure:@escaping DefaultAPIFailureClosure) {
           
           alamoFireManager.request(route, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON
            {
               response in
               
               guard response.error == nil else{
                   
                   print(response.value ?? "")
                   print("error in calling get request \(response.error!)")
                 //  self.showErrorMessage(error: response.error!)
                   failure(response.error! as NSError)
                   
                   return;
               }
           
            
            switch response.result {
                    
                    case .success(_):
                        if let jsonResponse = response.data {
                         if route.absoluteString.contains("membershipScreen")
                                            {


                                                if let value = response.value as? [String: AnyObject]
                                                {
                                                    if value["data"] != nil
                                                    {
                                                         if let data = value["data"]
                                                         {
                                                            if data["total_savings"] as? Int ?? 1 == 0
                                                            {
                                                             //Constants.TGDATA.isMembershipDataString = false
                                                            }
                                                            else
                                                            {
                                                            // Constants.TGDATA.isMembershipDataString = true
                                                             }
                                                            }
                                                         }
                                                        else
                                                         {
                                                            
                                                        }
                                                    }
                                                    else
                                                    {
                                                    }

                                            }

                                            
                         
                            print(response.value ?? "")
                            success(jsonResponse)
                        } else {
                            success(nil)
                        }
                        break
                    case .failure(let error):
                        print("Alamo error: \(error)")
                        break
                    }
            
            
            
           }
       }
       
    
    
    
    
    func postRequestWithUserToken(route: URL,parameters: Parameters,
                                  success:@escaping ResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure)
    {
        
        alamoFireManager.request(route, method: .get, encoding: JSONEncoding.default, headers: getUserHeader()).responseJSON{
            response in
            
            guard response.error == nil else{
                
                print("error in calling get request \(response.error!)")
               // self.showErrorMessage(error: response.error!)
                failure(response.error! as NSError)
                
                return;
            }
            
    
            
            switch response.result {
                    
                    case .success(_):
                        if let jsonResponse = response.data {
                            
                            if response.response?.statusCode == 401
                            {

                            }
                            else
                            {
                            success(jsonResponse)
                            }
                        } else {
                            
                            success(nil)
                        }
                        break
                    case .failure(let error):
                        print("Alamo error: \(error)")
                        break
                    }
            
            
        }
    }
    
    
    func rawGetRequest(route: URL,parameters: Parameters,
                       success:@escaping ResultAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure) {
        
        let request = NSMutableURLRequest(url: route,
                                          cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                          timeoutInterval: 1000000000.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = getUserHeader()
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
                return
            } else {
                
                if let dataString = String.init(data: data!, encoding: .utf8) {
                    print(dataString)
                }
                
                
                
                success(data)
                
                // print(httpResponse)
                
            }
        })
    
        dataTask.resume()
        
        
        
        //        var request = URLRequest(url: route)
        //        request.httpMethod = "GET"
        //        request.allHTTPHeaderFields = getUserLoginHeader()
        //        request.timeoutInterval = 600000
        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //
        //        do {
        //            let requestObject = try JSONSerialization.data(withJSONObject: parameters)
        //            request.httpBody = requestObject
        //            Alamofire.request(request).responseJSON { (response) in
        //                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //
        //                guard response.error == nil else{
        //
        //                    print("error in calling get request \(response.error!)")
        //                    self.showErrorMessage(error: response.error!)
        //                    failure(response.error! as NSError)
        //
        //                    return;
        //                }
        //
        //                if response.result.isSuccess {
        //                    if let jsonResponse = response.data {
        //                        success(jsonResponse)
        //                    } else {
        //                        success(nil)
        //                    }
        //                }
        //
        //                // TODO: - Call Success Callback Function
        //
        //            }
        //        } catch {
        //            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //            success(nil)
        //
        //            // TODO: - Call Error Callback Function
        //        }
        
    }
    
    func rawPostRequest(_ isRequestType : Bool = false , route: URL,parameters: Parameters,
                        success:@escaping ResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure,header : HTTPHeaders) {
        
        
        
        var request = URLRequest(url: route)
        if isRequestType {
            request.httpMethod = "PUT"
        } else {
            request.httpMethod = "POST"
        }
      //  debugPrint(request.httpMethod)
       // debugPrint(request.httpBody)
      //  request.allHTTPHeaderFields = getUserHeader()
        request.timeoutInterval = 600000
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        do {
            let requestObject = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = requestObject
          //  debugPrint(request.httpBody?.description)
            request.headers = header
            AF.request(request).responseJSON { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                guard response.error == nil else{
                    
                    print("error in calling get request \(response.error!)")
                   // self.showErrorMessage(error: response.error!)
                    failure(response.error! as NSError)
                    
                    return;
                }
                
                
                switch response.result {
                        
                case .success( _):
                            print(response.value ?? "")
                            if let jsonResponse = response.data {
                                success(jsonResponse)
                                
                            } else {
                                
                                if response.response?.statusCode == 401
                                {
        //                            APIManager.sharedInstance.refreshTokenAPI(parameters: [:], success: { (data) in
        //
        //                            })
        //                            { (error) in
        //
        //                            }
                                }
                                
                                success(nil)
                            }
                            break
                        case .failure(let error):
                            print("Alamo error: \(error)")
                            break
                        }
                
                
                // TODO: - Call Success Callback Function
                
            }
        } catch {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            success(nil)
            
            // TODO: - Call Error Callback Function
        }
        
    }
    
    func rawPostRequest1(_ isRequestType : Bool = false , route: URL,parameters: [Parameters],
                        success:@escaping ResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure) {
        
        
        
        var request = URLRequest(url: route)
        if isRequestType {
            request.httpMethod = "PUT"
        } else {
            request.httpMethod = "POST"
        }
        
     //   request.allHTTPHeaderFields = getUserHeader()
        request.timeoutInterval = 600000
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        do {
            let requestObject = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = requestObject
            debugPrint(requestObject)
            AF.request(request).responseJSON { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                guard response.error == nil else{
                    
                    print("error in calling get request \(response.error!)")
                   // self.showErrorMessage(error: response.error!)
                    failure(response.error! as NSError)
                    
                    return;
                }
                
                switch response.result {
                        
                        case .success(_):
                            print(response.value ?? "")
                            if let jsonResponse = response.data {
                                success(jsonResponse)
                                
                            } else {
                                success(nil)
                            }
                            break
                        case .failure(let error):
                            print("Alamo error: \(error)")
                            break
                        }
                
                
                
                
                // TODO: - Call Success Callback Function
                
            }
        } catch {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            success(nil)
            
            // TODO: - Call Error Callback Function
        }
        
    }
    
    
    
    func putRequestWith(route: URL,parameters: Parameters, isAdminRequest : Bool = false,
                        success:@escaping ResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure,headers : HTTPHeaders? = nil) {
        
        var httpHeader = HTTPHeaders()
        if isAdminRequest {
            httpHeader = getDefaultTokenHeader()!
        } else {
           // httpHeader = getUserHeader()
        }
        
        alamoFireManager.request(route, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers ?? httpHeader).responseJSON {
            response in
            
            guard response.error == nil else{
                print("error in calling post request")
                failure(response.error! as NSError)
                return;
            }
  
            
            switch response.result {
                    
                    case .success(_):
                        print(response.value ?? "")
                        if let jsonResponse = response.data {
                            success(jsonResponse)
                            
                        } else {
                            success(nil)
                        }
                        break
                    case .failure(let error):
                        print("Alamo error: \(error)")
                        break
                    }
            
        }
    }
    
    
    

 
    
    func requestWithMultipart(URLSTR: URLRequest, route: URL,parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure,
                              errorPopup: Bool){
        
        
     
        AF.upload(multipartFormData: { multipartFormData in
            
            if parameters.keys.contains("photobase64") {
                let fileURL = URL(fileURLWithPath: parameters["photobase64"] as! String)
                multipartFormData.append(fileURL, withName: "profile_picture", fileName: "image.png", mimeType: "image/png")
            }
            
            var subParameters = Dictionary<String, AnyObject>()
            let keys: Array<String> = Array(parameters.keys)
            let values = Array(parameters.values)
            
            for i in 0..<keys.count {
                if ((keys[i] != "photobase64") && (keys[i] != "images")) {
                    subParameters[keys[i]] = values[i] as AnyObject
                }
            }
            
            if parameters.keys.contains("images") {
                let images = parameters["images"] as! Array<String>
                for i in 0  ..< images.count {
                    let fileURL = URL(fileURLWithPath: images[i])
                    multipartFormData.append(fileURL, withName: "image\(i+1)", fileName: "image\(i).png", mimeType: "image/png")
                }
            }
            
            for (key, value) in subParameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                //debug
                print(value)
            }
            
        }, with: URLSTR)
        
        .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: {response in
                

                            guard response.error == nil else{
                                print("👹 Error in calling post request")
                                
                                //errorPopup
                                    //? self.showErrorMessage(error: response.error!) : nil
                                
                                failure(response.error! as NSError)
                                return;
                            }
                            
                            if let value = response.value {
                                print (value)
                                if let jsonResponse = response.value as? Dictionary<String, AnyObject>{
                                    success(jsonResponse)
                                } else {
                                    success(Dictionary<String, AnyObject>())
                                }
                                
                            }
                    else
                            {
                                failure(response.error! as NSError)
                            }
                
                    })
     
         
    }
    
    
    func putRequestWithMultipart(route: URL,parameters: Parameters,
                                 success:@escaping DefaultArrayResultAPISuccessClosure,
                                 failure:@escaping DefaultAPIFailureClosure,
                                 errorPopup: Bool){
        
        let URLSTR = try! URLRequest(url: route.absoluteString, method: HTTPMethod.put, headers: getUserHeader())
        
        requestWithMultipart(URLSTR: URLSTR, route: route, parameters: parameters, success: success, failure: failure , errorPopup: errorPopup)
    }
    
    
    func postRequestWithMultipart_General(route: URL,parameters: Parameters,
                                          success:@escaping DefaultArrayResultAPISuccessClosure,
                                          failure:@escaping DefaultAPIFailureClosure,
                                          errorPopup: Bool){
        
        let URLSTR = try! URLRequest(url: route.absoluteString, method: HTTPMethod.post, headers: getUserHeader())
        
        requestWithMultipart(URLSTR: URLSTR, route: route, parameters: parameters, success: success, failure: failure, errorPopup: errorPopup)
    }
    
    
    func postRequestWithMultipart(route: URL,parameters: Parameters,
                                  success:@escaping DefaultArrayResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure,
                                  errorPopup: Bool){
        
        let URLSTR = try! URLRequest(url: route.absoluteString, method: HTTPMethod.post, headers: getUserHeader())
        
        AF.upload(multipartFormData: { multipartFormData in
            
            var subParameters = Dictionary<String, AnyObject>()
            let keys: Array<String> = Array(parameters.keys)
            let values = Array(parameters.values)
            
            for i in 0..<keys.count {
                //                if ((keys[i] != "file") && (keys[i] != "images")) {
                subParameters[keys[i]] = values[i] as AnyObject
            }
            
            
            for (key, value) in subParameters {
                if let data:Data = value as? Data {
                    
                    multipartFormData.append(data, withName: "ProfilePicture", fileName: "image.png", mimeType: "image/png")
                } else {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, with: URLSTR)
        .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: {response in
                

                            guard response.error == nil else{
                                print("👹 Error in calling post request")
                                
                                //errorPopup
                                    //? self.showErrorMessage(error: response.error!) : nil
                                
                                failure(response.error! as NSError)
                                return;
                            }
                            
                            if let value = response.value {
                                print (value)
                                if let jsonResponse = response.value as? Dictionary<String, AnyObject>{
                                    success(jsonResponse)
                                } else {
                                    success(Dictionary<String, AnyObject>())
                                }
                                
                            }
                    else
                            {
                                failure(response.error! as NSError)
                            }
                
                    })
                
  
    }
    
    
    func patchRequest(route: URL,parameters: Parameters,
                      success:@escaping ResultAPISuccessClosure,
                      failure:@escaping DefaultAPIFailureClosure,headers : HTTPHeaders? = nil){
        
    
        alamoFireManager.request(route, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers ?? getDefaultTokenHeader()).responseJSON
        {
        response in
        
        debugPrint(response)
    
        
        guard response.error == nil else{
            print("error in calling post request")
           
            failure(response.error! as NSError)
            return;
        }
        if let value = response.value {
            print (value)
          
            
            if let jsonResponse = response.data {
                success(jsonResponse)
               // success(Constants.UPDATA.getJsonData(data: jsonResponse))
            } else {
                success(nil)
            }
        }
    }
    }
    
    
    
    
    fileprivate func multipartFormData(parameters: Parameters) {
        let formData: MultipartFormData = MultipartFormData()
        for (key , value) in parameters {
            
            if let data:Data = value as? Data {
                
                formData.append(data, withName: "profile_picture", fileName: "image.png", mimeType: "image/png")
            } else {
                formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }
        
        print("\(formData)")
        
    }
}



public extension Data {
    var mimeType:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            case 0x49, 0x4D:
                return "image/tiff";
            case 0x25:
                return "application/pdf";
            case 0xD0:
                return "application/vnd";
            case 0x46:
                return "text/plain";
            default:
                print("mimeType for \(c[0]) in available");
                return "application/octet-stream";
            }
        }
    }
    
    
    
}
