//
//  CustomPayFort.swift
//  ArtStation
//
//  Created by Apple on 08/07/2021.
//
import UIKit
protocol ProtocolPayfortCallBacks {
    func onSuccess(objPayfort:NSDictionary)
    func onCanceled(objPayfort:NSDictionary)
    func onFailure(objPayfort:NSDictionary,message:String)
}

class CustomFort{
    
    static var sharedinstance = CustomFort()
    
    var PayFortToken=NSDictionary()
    var payfortResponse = NSDictionary()
    var delegateCallBack:ProtocolPayfortCallBacks?
    var orderID = "12345"
    var orderPrice = 233.56
    var emailUser = "eri@asd.bom"
    var paymentOption = "MADA"//check for options
    var currentCOntroller : UIViewController!
    
    func initiateTokenNSDK()
    {
        
        let payFort = PayFortController.init(enviroment: ApiEndpoint.getPayFortEnvirement)!
        payFort.setPayFortCustomViewNib("PayFortView")
        let urlString = "\(ApiEndpoint.PayfortSDKToken)\(payFort.getUDID() ?? "" )"
        debugPrint(urlString,"")
        
        let paymentOption = self.paymentOption == "Mada" ? "mada" : "payfort"
        let yahooRSSURL = APIManagerBase.sharedInstance.GetURLwithParams(route: urlString, parameters: ["payment_type":paymentOption])!
        var request = URLRequest(url: yahooRSSURL)
        request.httpMethod = "GET"
        request.headers = ["Authorization":DataManager.getUserAuth ?? ""]
        UIManager.showCustomActivityIndicator(controller: currentCOntroller, withMessage: "")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: request) {data, response, err in
            OperationQueue.main.addOperation({
                print("Entered the completionHandler")
                print("Response JSON:\n\(String(data: data!, encoding: String.Encoding.utf8)!)")
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode==200
                {
                    let jsonString = String(data: data!, encoding: String.Encoding.utf8)!
                    let data: Data? = jsonString.data(using: .utf8)
                    let json = (try? JSONSerialization.jsonObject(with: data ?? Data(), options: [])) as? [String:AnyObject]
                    self.PayFortToken=json! as NSDictionary
                    UIManager.hideCustomActivityIndicator(controller: self.currentCOntroller)
                    self.payfortPay()
                }
                else
                {
                    UIManager.hideCustomActivityIndicator(controller: self.currentCOntroller)
                    self.currentCOntroller.showAlert(title: "Oops something went wrong", message: "")
                }
            })
        }
        task.resume()
        
    }
    
    
    
    func payfortPay()
    {
        
        let payFort = PayFortController.init(enviroment: ConfigurationManager.shared.getPayfortEnviroment())!
        
        
        payFort.isShowResponsePage = true
        
        let timestamp = String(Int64(Date().timeIntervalSince1970 * 1000))
        
        let   merchant_reference = "\(orderID)-\((timestamp as NSString).substring(from: timestamp.count - 4))"
        
        let price = round(orderPrice * 100)
        
        let request = NSMutableDictionary.init()
        request.setValue("PURCHASE", forKey: "command")
        request.setValue("SAR", forKey: "currency")
        request.setValue("en", forKey: "language")
        request.setValue(price, forKey: "amount")
        request.setValue(emailUser, forKey: "customer_email")
        request.setValue(PayFortToken["sdk_token"] as? String ?? "", forKey: "sdk_token")
        request.setValue(merchant_reference, forKey: "merchant_reference")
        request.setValue(paymentOption, forKey: "payment_option")
        
        //    let priceString: String = String(format: "%.0f", price)
        //    var request = Dictionary<String,String>()
        //    request = ["command":"PURCHASE","currency":"SAR","language":"en","amount":priceString,"customer_email":emailUser,"sdk_token":PayFortToken["sdk_token"] as? String ?? "","merchant_reference":merchant_reference,"payment_option":paymentOption]
        //
        //    debugPrint("HereToMakePayment",request)
        payFort.callPayFort(withRequest: request, currentViewController: self.currentCOntroller,
                            success: { (requestDic, responeDic) in
            
            OperationQueue.main.addOperation({
                UIManager.hideCustomActivityIndicator(controller: self.currentCOntroller)
                let stringAnyObj = responeDic
                
                self.payfortResponse = stringAnyObj! as NSDictionary
                self.delegateCallBack?.onSuccess(objPayfort: self.payfortResponse)
                
            })
            
        },
                            canceled: { (requestDic, responeDic) in
            
            OperationQueue.main.addOperation({
                UIManager.hideCustomActivityIndicator(controller: self.currentCOntroller)
                let stringAnyObj = responeDic
                self.payfortResponse = stringAnyObj! as NSDictionary
                
                self.delegateCallBack?.onCanceled(objPayfort: self.payfortResponse)
            })
        },
                            faild: { (requestDic, responeDic, message) in
            
            OperationQueue.main.addOperation({
                UIManager.hideCustomActivityIndicator(controller: self.currentCOntroller)
                let stringAnyObj = responeDic
                self.payfortResponse = stringAnyObj! as NSDictionary
                self.delegateCallBack?.onFailure(objPayfort: self.payfortResponse,message: message ?? "")
            })
            
        })
    }
    
    func apiPaymentRecievedPayFort(objT:NSDictionary)
    {
        
        
        UIManager.hideCustomActivityIndicator(controller: self.currentCOntroller)
        //   BASE_API_MANAGER.sharedInstance.HomeLab_TrackOrder_paymentRecivedPayFort(params:["orderID":MUtility.currentOrder._id,"BillNumber":MUtility.currentOrder.orderID.description,"BillDate":objT["PaymentDate"] as? String ?? "", "amount_paid":"\(round(MUtility.currentOrder.net_price))","payment_id":objT["fort_id"] as? String ?? "","user_email":objT["customer_email"] as? String ?? ""],success:
        //            {
        //                 (dicObj) in
        //
        //                     OperationQueue.main.addOperation({
        //
        //                         MUtility.hideCustomActivityIndicator(controller: self)
        //
        //                         if dicObj["status"] as? Int ?? 0 == 200
        //                         {
        //                             MUtility.showAlert(title: "", info: dicObj["message"]?[MUtility.getAppLanguage()] as? String ?? MUtility.localizedText(text:"No data available"), viewController: self)
        //
        //                            self.apiGetOrderDetail()
        //
        //                            self.navigationController?.popViewController(animated: true)
        //                         }
        //                         else
        //                         if dicObj["status"] as? Int ?? 0 == 401
        //                         {
        //                                UserDefaults.standard.set("false", forKey: UserDefaultsKeys.isUserLoggedIn.rawValue)
        //                                UserDefaults.standard.set("0.00" ,forKey: "order-location-lat")
        //
        //                                let mainStoryboard = UIStoryboard(name: "Main"+MUtility.ifAppLanguageCHar(), bundle: nil)
        //
        //
        //                                let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "regBar") as! UINavigationController
        //
        //                                UIApplication.shared.keyWindow?.rootViewController = initialViewController
        //
        //                                UserDefaults.standard.set("false", forKey: UserDefaultsKeys.isUserLoggedIn.rawValue)
        //                                }
        //                         else
        //                         {
        //                          MUtility.showAlert(title: "", info: dicObj["message"]?[MUtility.getAppLanguage()] as? String ?? MUtility.localizedText(text:"No data available"), viewController: self)
        //                         }
        //                     })
        //
        //                 }, failure: { (error, intval) in
        //                        OperationQueue.main.addOperation({
        //                           MUtility.hideCustomActivityIndicator(controller: self)
        //                             MUtility.showAlert(title: "", info:MUtility.localizedText(text:"Oops!something went wrong"), viewController: self)
        //
        //                                })
        //                 }, errorPopup: true)
    }
    
}
