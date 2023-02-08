//
//  PayFromPayFortViewController.swift
//  ArtStation
//
//  Created by Apple on 08/07/2021.
//

import UIKit

class PayFromPayFortViewController: UIViewController {

    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblPackagePrice: UILabel!
    @IBOutlet weak var lblPromoDiscount: UILabel!
    @IBOutlet weak var lblVAT: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    var booking:Booking?
    @IBOutlet weak var txtPROMO: UITextField!
    var promoApplied = false
    var vatPercent = 0.0
    var vatAmount = 0.0
    var amountNet: Double?
    var discountAmount = 0.0
    var viewModel=PaymentViewModel()
    var paymentParam = PaymentSuccess.init(payment_id: "0", booking_id: "", amount: "", discount: "", vatAmount: "", vatPercent: "", netAmount: "", payment_type: "")
    var paymentParamPromo = PaymentSuccessPromo.init(promo_id: "", payment_id: "", booking_id: "", amount: "", discount: "", vatAmount: "", vatPercent: "", netAmount: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    
    func setupUI()
    {
        backButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor(named: "tabbar_item_tint")!, borderRadius: backButton.frame.height/2, borderColor: UIColor(named: "tabbar_item_tint")!, borderWidth: 2)
        txtPROMO.delegate = self
        lblOrderId.text = Utils.localizedText(text:"Booking#") + String(booking?.id ?? 0)
        lblPromoDiscount.text=""
       calCulateParams()
    }
   
    @IBAction func btnContinueClick(_ sender: Any)
    {
        if !txtPROMO.isFirstResponder{
       
        let paymentViewModel = PaymentViewModel()
          
            paymentViewModel.orderID = booking?.id.description ?? ""
            paymentViewModel.orderPrice = amountNet
            paymentViewModel.emailUser = DataManager.getUserData?.email ?? ""
            paymentViewModel.paymentOption = ""
            if DataManager.getLanguage == Language.english.rawValue{
                paymentViewModel.artistName = booking!.package.artist!.name
            }else{
                paymentViewModel.artistName = booking!.package.artist!.name
               }
            
            paymentParam.amount = String(booking!.amount ?? 0)
            paymentParam.booking_id = booking?.id.description ?? "0"
            paymentParam.discount = discountAmount.description
            paymentParam.vatAmount = vatAmount.description
            paymentParam.vatPercent = DataManager.getVAT
            paymentParam.netAmount = String(amountNet!)
            if promoApplied{
                paymentParam.promo_id = (viewModel.promoData?.id ?? 0).description
            }
            
            paymentViewModel.paymentParam = paymentParam
            
            
            let viewController = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.paymentController, viewController: PaymentViewController.self)
            viewController.viewModel = paymentViewModel
            self.navigationController?.pushViewController(viewController, animated: true)
        /*
        CustomFort.sharedinstance.delegateCallBack = self
        CustomFort.sharedinstance.currentCOntroller = self
        CustomFort.sharedinstance.orderID = booking?.id.description ?? ""
        CustomFort.sharedinstance.orderPrice = Double(lblTotal.text!) ?? 0.0
        CustomFort.sharedinstance.emailUser = DataManager.getUserData?.email ?? ""
        CustomFort.sharedinstance.paymentOption = ""
        CustomFort.sharedinstance.initiateTokenNSDK()
          */
        }
        // VISA, MASTERCARD, American Express (AMEX), MADA and MEEZA.
        view.endEditing(true)
       
    }
    
    
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func calCulateParams()
    {
        if DataManager.getVAT=="NotFound"
        {
           // lblVAT.text="Please restart app for VAT"
        }
        else
        {
       //lblVAT.text=(DataManager.getVAT.description+" %")
            //lblVAT.text=(" %")
        }
        if promoApplied
        {
           if viewModel.promoData?.discount_type == "Flat"
            {
            discountAmount = viewModel.promoData?.discount_value ?? 0.0
            }
            else
           {
            
            discountAmount = ((booking?.amount ?? 0.0)*(viewModel.promoData?.discount_value)!)/100
            
           }
            lblPromoDiscount.text = String(discountAmount)
        }
        
        //vatPercent = Double(DataManager.getVAT)!
       // vatAmount = (((booking?.amount ?? 0.0)-discountAmount)*vatPercent)/100
       // amountNet = (booking?.amount ?? 0.0)+vatAmount-discountAmount
        amountNet = (booking?.amount ?? 0.0)-discountAmount
        lblPackagePrice.text=booking?.amount.description
        if DataManager.getLanguage == Language.arabic.rawValue{
            lblTotal.text = String(amountNet!) +  " " + Utils.localizedText(text: " SAR")
            lblTotal.font = UIFont(name: "Almarai-Bold", size: 18)
           
        }else{
            lblTotal.text =  Utils.localizedText(text: "SAR") + " " +  String(amountNet!)
        }
    }
    
}

extension PayFromPayFortViewController:ProtocolPayfortCallBacks
{
    func onSuccess(objPayfort: NSDictionary) {
       
        if promoApplied
        {
            paymentParamPromo.amount = String(amountNet!)
            paymentParamPromo.booking_id = booking?.id.description ?? "0"
            paymentParamPromo.discount = discountAmount.description
            paymentParamPromo.vatAmount = vatAmount.description
            paymentParamPromo.vatPercent = DataManager.getVAT
            paymentParamPromo.netAmount = lblTotal.text!
            paymentParamPromo.payment_id = objPayfort["fort_id"] as? String ?? ""
            paymentParamPromo.promo_id = (viewModel.promoData?.id ?? 0).description
            paymentSuccessPromoApi()
        }
        else
        {
            paymentParam.amount = String(amountNet!)
            paymentParam.booking_id = booking?.id.description ?? "0"
            paymentParam.discount = discountAmount.description
            paymentParam.vatAmount = vatAmount.description
            paymentParam.vatPercent = DataManager.getVAT
            paymentParam.netAmount = lblTotal.text!
            paymentParam.payment_id = objPayfort["fort_id"] as? String ?? ""
            paymentSuccessApi()
        }
    }
    
    func onCanceled(objPayfort:NSDictionary) {
    }
    
    func onFailure(objPayfort: NSDictionary, message: String) {
        self.showAlert(title: "Payment failed", message: message)
    }
    
    
}

extension PayFromPayFortViewController
{
   func paymentSuccessApi()
   {
    UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
    viewModel.PaymentSuccess(param:paymentParam){
            success,errorString in
        UIManager.hideCustomActivityIndicator(controller: self)
       
            if success{
                let vc = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.PaymentCompletedViewControllerID, viewController: PaymentCompletedViewController.self)
                vc.bookingID = self.booking?.id
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.showAlert(title: "Error", message: errorString ?? "")
            }
       
    }
   }
    
    func paymentSuccessPromoApi()
    {
     UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
     viewModel.PaymentSuccessPromo(param:paymentParamPromo){
             success,errorString in
         UIManager.hideCustomActivityIndicator(controller: self)
        
             if success{
                 let vc = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.PaymentCompletedViewControllerID, viewController: PaymentCompletedViewController.self)
                 vc.bookingID = self.booking?.id
                 self.navigationController?.pushViewController(vc, animated: true)
             }else{
                 self.showAlert(title: "Error", message: errorString ?? "")
             }
        
     }
    }
    
    func applyPromoApi()
    {
     UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
        viewModel.applyPromo(param:["promo_code":txtPROMO.text ?? ""]){
             success,message in
         UIManager.hideCustomActivityIndicator(controller: self)
        
             if success{
                self.showAlert(title: "Success", message: message ?? "" )
                self.txtPROMO.isEnabled = false
                self.promoApplied = true
                self.calCulateParams()
             }else{
                 self.showAlert(title: "Error", message: message ?? "")
             }
        
     }
    }
}


extension PayFromPayFortViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        applyPromoApi()
        self.txtPROMO.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        applyPromoApi()
        self.txtPROMO.resignFirstResponder()
    }
}
