//
//  CustomViewViewControllerTabBar.swift
//  ArtStation
//
//  Created by Andpercent on 02/02/2022.
//

import UIKit

class CustomPackageViewControllerTabBar: UIViewController {
    
        let bookArtistViewModel = DressCalendarViewModel()
        
        var artistID:String?
        
        @IBOutlet var customPakcagetext:UITextView!
        
        @IBAction func submitBtnAction(_ sender:UIButton){
            if customPakcagetext.text.count > 0{
                UIManager.showCustomActivityIndicator(controller: self, withMessage: "submitting")
                onSubmit()
            }else{
                self.showAlert(title: Utils.localizedText(text: "Alert"), message: Utils.localizedText(text: "Please write the custom package details!"))
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.addDoneButtonOnKeyboard()
        }
        
        
        
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.view.isHidden = false
            customPakcagetext.textViewDidChange(self.customPakcagetext)
        }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.view.isHidden = true
            self.customPakcagetext.text = ""
        }
        
        func onSubmit() {
            var params: [String:Any] = [:]
           // params["artist_id"] = ""
            params["description"] = self.customPakcagetext.text
            
            bookArtistViewModel.SubmitCustomPackageRequest(param: params) { isSuccess, someresponse in
                
                if isSuccess{
                    UIManager.hideCustomActivityIndicator(controller: self)
                    
                    self.showArtStationAlert(message: Utils.localizedText(text: "Your request has been sent. You will be contacted by Art Station soon"), onOkTapped: {
                      
                        self.tabBarController?.selectedIndex = (DataManager.getLanguage == Language.arabic.rawValue) ? 4 : 0
                        
                    }, alertType: .alert)
                    self.customPakcagetext.text = ""
                    
                }else{
                    self.showAlert(title: "Error", message: someresponse ?? "")
                    UIManager.hideCustomActivityIndicator(controller: self)
                }
            }
        }

        func addDoneButtonOnKeyboard()
        {
            var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default

            var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))

            var items = NSMutableArray()
            items.add(flexSpace)
            items.add(done)

            doneToolbar.items = items as! [UIBarButtonItem]
            doneToolbar.sizeToFit()

            self.customPakcagetext.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction()
        {
            self.customPakcagetext.resignFirstResponder()
        }
}
