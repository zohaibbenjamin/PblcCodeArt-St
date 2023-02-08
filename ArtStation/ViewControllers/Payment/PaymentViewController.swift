//
//  PaymentViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 8/4/21.
//

import UIKit

class PaymentViewController: UIViewController{

    //MARK:- IB Refrences
    @IBOutlet weak var madaButton: Checkbox!
    @IBOutlet weak var applePayButton: Checkbox!
    @IBOutlet weak var creditCardButton: Checkbox!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var lblOrderId: UILabel!
  
    //MARK:- Data
    var viewModel : PaymentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOrderId.text = Utils.localizedText(text: "Booking#") +  (viewModel?.orderID ?? "")
        backButton.configureButtonUI(backgroundColor: nil,fontColor: UIColor(named: "tabbar_item_tint")!, borderRadius: backButton.frame.height/2, borderColor: UIColor(named: "tabbar_item_tint"), borderWidth: 2)
    }
    
    
    
    
    //MARK:- CreditCard Selected
    @IBAction func onCreditCardTapped(_ sender: Any) {
        applePayButton.isChecked = false
        madaButton.isChecked = false
        creditCardButton.isChecked = true
    }
    
    //MARK:- ApplePaySelected
    @IBAction func onApplePayTapped(_ sender: Any) {
        creditCardButton.isChecked = false
        madaButton.isChecked = false
        applePayButton.isChecked = true
    }
    
    //MARK:- Mada Selected
    @IBAction func onMadaTapped(_ sender: Any) {
       applePayButton.isChecked = false
        creditCardButton.isChecked = false
        madaButton.isChecked = true
    }
    
    @IBAction func onPayNowTapped(_ sender: Any) {
    
        if madaButton.isChecked{
            initiateMadaOrCreditCard(paymentType: "MADA")
        }else if creditCardButton.isChecked{
            initiateMadaOrCreditCard(paymentType: "")
        }else if applePayButton.isChecked{
            initiateApplePay()
        }
    }
    
    
    func initiateApplePay(){
        
      
        CustomFortApplePay.sharedinstance.orderID = viewModel?.orderID ?? ""
        CustomFortApplePay.sharedinstance.orderPrice = viewModel?.orderPrice ?? 0.0
        CustomFortApplePay.sharedinstance.emailUser = viewModel?.emailUser ?? ""
        CustomFortApplePay.sharedinstance.paymentOption = viewModel?.paymentOption ?? ""
    
        
        let viewController = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.applePayDetailsController, viewController: ApplePayPaymentViewController.self)
        let viewModelApplePay = ApplePayPaymentViewModel()
        viewModelApplePay.orderId = viewModel?.orderID
        viewModelApplePay.paymentAmount = viewModel?.orderPrice
        viewModelApplePay.paymentParam = viewModel?.paymentParam
        viewModelApplePay.paidTo = viewModel?.artistName
        
        viewController.viewModel = viewModelApplePay
        
        
        self.navigationController?.pushViewController(viewController, animated: true)
    
        
 
        /*
        if PKPaymentAuthorizationViewController.canMakePayments()
        {
            if #available(iOS 12.1.1, *)
            {
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [ .masterCard, .visa, .mada])
                {
                    let item = PKPaymentSummaryItem.init()
                    item.label = "ArtStation"
                    item.amount = NSDecimalNumber.init(string: String(format: "%f", round((viewModel!.orderPrice!))))
                    
                    let request = PKPaymentRequest.init()
                    request.currencyCode = "SAR"
                    request.countryCode = "SA"
                    //request.requiredBillingAddressFields = .all
                    request.supportedNetworks = [.visa, .mada, .masterCard, .discover]
                    request.merchantIdentifier = "merchant.com.art.station.sa"
                    request.merchantCapabilities = .capability3DS
                    request.paymentSummaryItems = [item]
                    
                    let view = PKPaymentAuthorizationViewController(paymentRequest: request)
                    view?.delegate = self
                    self.present(view!, animated: true, completion: nil)
     
                }
                else
                {
                    self.showAlert(title: "Failure", message: "Apple pay is not supported")
                }
            }
            else
            {
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [ .masterCard, .visa])
                {
                    let item = PKPaymentSummaryItem.init()
                    item.label = "ArtStation"
                    item.amount = NSDecimalNumber.init(string: String(format: "%f", round((viewModel!.orderPrice!))))
                    let request = PKPaymentRequest.init()
                    request.currencyCode = "SAR"
                    request.countryCode = "SA"
                    request.supportedNetworks = [.visa, .masterCard, .discover,.mada]
                    request.merchantIdentifier = "merchant.com.art.station.sa"
                    request.merchantCapabilities = .capability3DS
                    request.paymentSummaryItems = [item]
                    
                    let view = PKPaymentAuthorizationViewController(paymentRequest: request)
                    view?.delegate = self
                    
                    self.present(view!, animated: true, completion: nil)
                }
                else
                {
                    self.showAlert(title: "Failure", message: "Apple pay is not supported")
             }
            }
        }
        else
        {
            self.showAlert(title: "Failure", message: "Apple pay is not supported")
        }
         */
    }
    
    
    func initiateMadaOrCreditCard(paymentType: String){
        CustomFort.sharedinstance.delegateCallBack = self
        CustomFort.sharedinstance.currentCOntroller = self
        CustomFort.sharedinstance.orderID = viewModel?.orderID ?? ""
        CustomFort.sharedinstance.orderPrice = viewModel?.orderPrice ?? 0.0
        CustomFort.sharedinstance.emailUser = DataManager.getUserData?.email ?? ""
        CustomFort.sharedinstance.paymentOption = paymentType
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        CustomFort.sharedinstance.initiateTokenNSDK()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBackButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension PaymentViewController : PKPaymentAuthorizationViewControllerDelegate{
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        
        controller.dismiss(animated: true, completion: nil)
    }
   
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        debugPrint(payment,"Apple Payment Data")
        CustomFortApplePay.sharedinstance.payment = payment
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        CustomFortApplePay.sharedinstance.initiateTokenNSDK()
    
        completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: nil))
        
    }
 
    
}

extension PaymentViewController {
    
   
    
    func paymentSuccessApi()
    {
     UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
        
        if let paymentParam = viewModel?.paymentParam{
        
        viewModel?.PaymentSuccess(param:paymentParam){
             success,errorString in
         UIManager.hideCustomActivityIndicator(controller: self)
        
             if success{
                 let vc = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.PaymentCompletedViewControllerID, viewController: PaymentCompletedViewController.self)
                vc.bookingID = Int(self.viewModel?.orderID ?? "")
                 self.navigationController?.pushViewController(vc, animated: true)
             }else{
                 self.showAlert(title: "Error", message: errorString ?? "")
             }
        
        }
            }
        
    }
    
    
}


extension PaymentViewController : ProtocolPayfortApplePayCallBacks{
    func onSuccessApplePay(objPayfort: NSDictionary) {
        viewModel?.paymentParam?.payment_id = objPayfort["fort_id"] as? String ?? ""
        viewModel?.paymentParam?.payment_type = "applepay"
        paymentSuccessApi()
    
    }
    
    func onCanceledApplePay(objPayfort: NSDictionary) {
        self.showAlert(title: "Alert", message: "Payment Cancelled",onOkTapped: {
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func onFailureApplePay(objPayfort: NSDictionary, message: String) {
    
        debugPrint(objPayfort,"OBJ PAYFORT")
        self.showAlert(title: "Error", message: message,onOkTapped: {
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func onSuccess(objPayfort: NSDictionary) {
        debugPrint(objPayfort,"OBJ PAYFORT")
     
        viewModel?.paymentParam?.payment_id = objPayfort["fort_id"] as? String ?? ""
        if creditCardButton.isChecked{
        viewModel?.paymentParam?.payment_type = "payfort"
        }else if madaButton.isChecked{
            viewModel?.paymentParam?.payment_type = "mada"
        }
        paymentSuccessApi()
    }
    
    func onCanceled(objPayfort: NSDictionary) {
        self.showAlert(title: "Alert", message: "Payment cancelled",onOkTapped: {
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func onFailure(objPayfort: NSDictionary, message: String) {
        debugPrint(objPayfort)
        self.showAlert(title: "Error", message: message,onOkTapped: {
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    

    
   
}
extension PaymentViewController : ProtocolPayfortCallBacks{
    
    
}



