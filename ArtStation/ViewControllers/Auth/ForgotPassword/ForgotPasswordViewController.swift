//
//  ForgotPasswordViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/1/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    let viewModel = ForgotPasswordViewModel()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailInputFeild: FormTextInput!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    func setupUI(){
        
       changePasswordButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor.systemPink, borderRadius: changePasswordButton.frame.height/2, borderColor: nil)
        backButton.configureButtonUI(backgroundColor: nil, borderRadius: backButton.frame.height/2, borderColor: .white, borderWidth: 2)
        
    }
    

    @IBAction func onBackButtonTapped(_ sender: Any) {
        debugPrint("HERE")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onChangePasswordButtonTapped(_ sender: Any) {
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        let apiRequest = ForgotPasswordApiRequest(emailAddress: emailInputFeild.textInputFeild.text ?? "")
        
        viewModel.sendOtpCodeTo(request: apiRequest, onCompletionHandler: {
            success,errorMessage in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
               
                let vc = Utils.getViewController(storyboard: StoryboardId.authStoryBoardId, identifier: StoryboardId.setNewPasswordControllerId, viewController: SetNewPasswordViewController.self)
                vc.userEmail = self.emailInputFeild.textInputFeild.text ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                self.showAlert(title: "", message: errorMessage ?? "Please check your email for OTP code",alertType: .alert)
            }else{
                self.showAlert(title: "Error", message: errorMessage ?? "An error occured")
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
