//
//  ContactUsViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 7/5/21.
//

import UIKit

class ContactUsViewController: UIViewController {

    let viewModel = ContactUsViewModel()
    @IBOutlet weak var emailAddressLabel: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var contactNumLabel: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var websiteLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSendTapped(_ sender: Any) {
        if DataManager.getUserLog == "guest"
        {
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
            return
        }
        viewModel.subscribe(email: emailField.text ?? "", onCompletionCallback: {
            success,message in
            if success{
                self.showAlert(title: "Success", message: message ?? "",alertType: .alert)
               // self.view.endEditing(true)
                self.emailField.text = ""
            }else{
                self.showAlert(title: "Error", message: message ?? "")
            }
        })
    }
    
    @IBAction func webTapped(_ sender: Any) {
        
        guard let url = URL(string: viewModel.contactUsDetails?.website ?? "") else { return }
        UIApplication.shared.open(url)
        
        
    }
    @IBAction func contactNumTapped(_ sender: Any) {
        let whatsappURL = URL(string:"https://wa.me/+966537746799")!
        debugPrint(whatsappURL)
              if UIApplication.shared.canOpenURL(whatsappURL){

                  UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)

              }
        
    }
    @IBAction func emailTapped(_ sender: Any) {
        let email = (viewModel.contactUsDetails?.email) ?? ""
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    @IBAction func instagramButtonTapped(_ sender: Any) {
        
           let Username =  "artstationsa"
           let appURL = URL(string: "instagram://user?username=\(Username)")!
           let application = UIApplication.shared

           if application.canOpenURL(appURL) {
               application.open(appURL)
           } else {
               let webURL = URL(string: "https://instagram.com/\(Username)")!
               application.open(webURL)
           }
    }

    func setupUI(){
       // sendButton.configureButtonUI(backgroundColor: UIColor(named: "tabbar_item_tint"), fontColor: UIColor.white, borderRadius: 16, borderColor: nil, borderWidth: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        viewModel.getContactDetails(onCompletionCallback: {
            success,errorMessage in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                self.emailAddressLabel.text = self.viewModel.contactUsDetails?.email
                //self.contactNumLabel.text = self.viewModel.contactUsDetails?.number
                self.websiteLabel.text = self.viewModel.contactUsDetails?.website
                
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
