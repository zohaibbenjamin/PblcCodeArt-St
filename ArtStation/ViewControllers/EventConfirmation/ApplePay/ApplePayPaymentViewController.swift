//
//  ApplePayPaymentViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 10/14/21.
//

import UIKit

class ApplePayPaymentViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate, ProtocolPayfortApplePayCallBacks {


    var viewModel: ApplePayPaymentViewModel?
    
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var paymentTo: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.configureButtonUI(backgroundColor: nil,fontColor: UIColor(named: "tabbar_item_tint")!, borderRadius: backButton.frame.height/2, borderColor: UIColor(named: "tabbar_item_tint"), borderWidth: 2)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let viewModel = viewModel{
            paymentTo.text = viewModel.paidTo
            orderId.text = viewModel.orderId
            
            if DataManager.getLanguage == Language.english.rawValue{
                totalAmountLabel.text = Utils.localizedText(text: "SAR ") + String(viewModel.paymentAmount!)}
            else{
                totalAmountLabel.text =  String(viewModel.paymentAmount!)
                totalAmountLabel.font = UIFont(name: "Almarai-Bold", size: 12)
            }
        
            }
        
    }
    
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- OnApplePayButtonTapped
    @IBAction func onPayButtonTapped(_ sender: Any) {
     
        debugPrint("Here")
        CustomFortApplePay.sharedinstance.delegateCallBack = self
        CustomFortApplePay.sharedinstance.currentCOntroller = self
        let item = PKPaymentSummaryItem.init()
        item.label = "ArtStation"
        item.amount = NSDecimalNumber.init(string: String(format: "%f", ((viewModel!.paymentAmount!))))
        debugPrint(item.amount,"AmountPrice")
        let request = PKPaymentRequest.init()
        request.currencyCode = "SAR"
        request.countryCode = "SA"
        request.supportedNetworks = [.visa, .mada, .masterCard, .discover]
        request.merchantIdentifier = "merchant.com.art.station.sa"
        request.merchantCapabilities = .capability3DS
        request.paymentSummaryItems = [item]
        
        let view = PKPaymentAuthorizationViewController(paymentRequest: request)
        view?.delegate = self
        self.present(view!, animated: true, completion: nil)
 
    }
    
    
    
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
    
    
    func paymentSuccessApi(){
        
         UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
            
            if let paymentParam = viewModel?.paymentParam{
            
            viewModel?.PaymentSuccess(param:paymentParam){
                 success,errorString in
             UIManager.hideCustomActivityIndicator(controller: self)
            
                 if success{
                     let vc = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.PaymentCompletedViewControllerID, viewController: PaymentCompletedViewController.self)
                    vc.bookingID = Int(self.viewModel?.orderId ?? "")
                     self.navigationController?.pushViewController(vc, animated: true)
                 }else{
                     self.showAlert(title: "Error", message: errorString ?? "")
                 }
            
            }
                }
    }
    
    
    
}
