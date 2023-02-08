//
//  SetNewPasswordViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/14/21.
//

import UIKit

class SetNewPasswordViewController: UIViewController {

    
    let viewModel = SetNewPasswordViewModel()
    
    //MARK:- IB Refrences
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var confirmPasswordInputField: FormTextInput!
    @IBOutlet weak var newPasswordInputField: FormTextInput!
    @IBOutlet weak var otpInputFeild: FormTextInput!
    
    //MARK:- Data
    var userEmail : String?
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    //MARK:- Setup UI
    func setupUI(){
        
       changePasswordButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor.systemPink, borderRadius: changePasswordButton.frame.height/2, borderColor: nil)
        confirmPasswordInputField.textInputFeild.maxLength = 20
        newPasswordInputField.textInputFeild.maxLength = 20
        backButton.configureButtonUI(backgroundColor: nil, borderRadius: backButton.frame.height/2, borderColor: .white, borderWidth: 2)
        
    }
 

    //MARK:- OnBackButtonTappeda
    @IBAction func onBackButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onChangePasswordButtonTapped(_ sender: Any) {
      
        let request = ValidateOtpApiRequest(emailAddress: userEmail ?? "", otpCode: otpInputFeild.textInputFeild.text ?? "", type: OtpType.forgotPassword.rawValue)
        debugPrint(request)
        if request.emailAddress.isEmpty || request.otpCode.isEmpty || (newPasswordInputField.textInputFeild.text ?? "").isEmpty{
           showAlert(title: "Error", message: "Please fill all input fields")
            return
        }
        if newPasswordInputField
            .textInputFeild.text ?? "" != confirmPasswordInputField.textInputFeild.text ?? ""{
            showAlert(title: "Error", message: "Passwords must match")
             return
        }
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "Updating Password")
        viewModel.validateOtp(provideUrlFor: .verifyOtp, request: request, onCompletionHandler: {
            success,errorMessage in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                self.viewModel.validateOtp(provideUrlFor: .updatePasscode, request: UpdatePasswordApiRequest(emailAddress: self.userEmail ?? "", password: self.newPasswordInputField.textInputFeild.text ?? ""), onCompletionHandler: {
                    success,message in
                    if success{
                        self.showAlert(title: "Success", message: message ?? "",onOkTapped:{
                            self.navigationController?.popToRootViewController(animated: true)
                        },alertType: .alert)
                    }else{
                        self.showAlert(title: "Error", message: message ?? "")
                    }
                })
            }else{
                self.showAlert(title: "Error", message: errorMessage ?? "")
            }
        })
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
