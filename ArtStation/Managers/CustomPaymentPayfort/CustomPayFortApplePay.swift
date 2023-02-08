//
//  CustomPayFort.swift
//  ArtStation
//
//  Created by Apple on 08/07/2021.
//

import UIKit
protocol ProtocolPayfortApplePayCallBacks {
    func onSuccessApplePay(objPayfort:NSDictionary)
    func onCanceledApplePay(objPayfort:NSDictionary)
    func onFailureApplePay(objPayfort:NSDictionary,message:String)
}

class CustomFortApplePay{

static var sharedinstance = CustomFortApplePay()
    
 var PayFortToken=NSDictionary()
 var payfortResponse=NSDictionary()
 var delegateCallBack:ProtocolPayfortApplePayCallBacks?
 var orderID = "12345"
 var orderPrice = 233.56
 var emailUser = "eri@asd.bom"
var userName: String?
 var paymentOption = "MADA"//check for options
 var currentCOntroller : UIViewController!
var payment : PKPayment?
func initiateTokenNSDK()
{
  
    let payFort = PayFortController.init(enviroment: ApiEndpoint.getPayFortEnvirement)!
    payFort.setPayFortCustomViewNib("PayFortView")
    debugPrint("Environment",ApiEndpoint.getPayFortEnvirement)
    let urlString = "\(ApiEndpoint.PayfortSDKToken)\(payFort.getUDID() ?? "")"
    debugPrint(payFort.getUDID() ?? "","URL")
    let yahooRSSURL = APIManagerBase.sharedInstance.GetURLwithParams(route: urlString, parameters: ["payment_type":"applepay"])!
    var request = URLRequest(url: yahooRSSURL)
    debugPrint(yahooRSSURL,"URL")
    
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
        self.payfortApplePay()
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
    


func payfortApplePay()
{

    debugPrint(payment,"PayfortApplePay")
    debugPrint("PayFortApplePay")
    let payFort = PayFortController.init(enviroment: ConfigurationManager.shared.getPayfortEnviroment())!
    payFort.isShowResponsePage = false
    let timeInSeconds = Int (Date.init().timeIntervalSince1970)
   
    let merchant_reference = String(format: "%@-%d", orderID, timeInSeconds % 10000)
    let price = round(orderPrice  * 100)
    
    let request = NSMutableDictionary.init()
        request.setValue("APPLE_PAY", forKey: "digital_wallet")
        request.setValue("PURCHASE", forKey: "command")
        request.setValue(merchant_reference, forKey: "merchant_reference")
        request.setValue("SAR", forKey: "currency")
        request.setValue("en", forKey: "language")
        request.setValue(price, forKey: "amount")
        request.setValue(emailUser, forKey: "customer_email")
        request.setValue((DataManager.getUserData?.name ?? ""), forKey: "customer_name")
        request.setValue(PayFortToken["sdk_token"] as? String ?? "", forKey: "sdk_token")
        
    debugPrint("ApplePayRequest",request)
    payFort.callPayFortForApplePay(withRequest: request, applePay: payment, currentViewController: self.currentCOntroller,
           success: { (requestDic, responeDic) in
            OperationQueue.main.addOperation({
                UIManager.hideCustomActivityIndicator(controller: self.currentCOntroller)
                let stringAnyObj = responeDic as NSDictionary? ?? NSDictionary()
                self.payfortResponse=stringAnyObj as NSDictionary
                self.delegateCallBack?.onSuccessApplePay(objPayfort: self.payfortResponse)
                
            })
           },
           faild: { (requestDic, responeDic, message) in

            OperationQueue.main.addOperation({
                UIManager.hideCustomActivityIndicator(controller: self.currentCOntroller)
                let stringAnyObj = responeDic as NSDictionary? ?? NSDictionary()
                self.payfortResponse=stringAnyObj as NSDictionary
                self.delegateCallBack?.onFailureApplePay(objPayfort: self.payfortResponse,message: message!)
                           })

           })
}


}
