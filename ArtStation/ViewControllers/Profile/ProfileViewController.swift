//
//  ProfileViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/30/21.
//

import UIKit

class ProfileViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var citiesView: FormDropDownAuth!
    @IBOutlet weak var selectedCityView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerDoneButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var dobCancelButton: UIButton!
    let viewModel = ProfileViewModel()
    let authViewModel = UserRegistrationViewModel()
   // @IBOutlet weak var dobLabel: UITextField!
    @IBOutlet weak var contactNumLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var signOutButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    var didChangePhoneNum = false
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        contactNumLabel.delegate=self
        contactNumLabel.keyboardType = UIKeyboardType.asciiCapableNumberPad
        nameLabel.delegate = self
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateButton.isEnabled = false
        getCities()
        didChangePhoneNum = false
  
    }
    
 
    @IBAction func onCancelDobTapped(_ sender: Any) {
        debugPrint("Cancel Button Tapped")
        //self.dobLabel.text = Utils.localizedText(text: "Tap to select DOB")
        dobCancelButton.isHidden = true
        datePickerDoneButton.isHidden = true
        datePicker.isHidden = true
    }
    
    
    @IBAction func onUpdateProfileTapped(_ sender: Any) {
       
        self.view.endEditing(true)
        dobCancelButton.isHidden = true
        datePickerDoneButton.isHidden = true
        datePicker.isHidden = true
       
        var cityId : Int?
//        if citiesView.textInputFeild.text == Utils.localizedText(text: "Tap to select city"){
//            showAlert(title:  "Alert", message: "Please select a city to continue")
//            return
//        }
        if citiesView.dropDown.selectedItem == viewModel.profileData?.city{
            cityId = viewModel.profileData?.cityID
        }else{
            cityId = authViewModel.cityList?[citiesView.dropDown.indexForSelectedRow ?? 0].id ?? 0
        }
        //var dobText: String? = dobLabel.text
//        if dobLabel.text == Utils.localizedText(text: "Tap to select DOB"){
//            dobText = ""
//        }
//        if dobText == ""{
//            dobText = ""
//        }
        let updateProfileApiRequest = UpdateProfileApiRequest(name: nameLabel.text ?? "", email: emailLabel.text ?? "", phone:(contactNumLabel.text ?? "").replacingOccurrences(of: " ", with: ""), city_id: cityId!)
       
        
        if updateProfileApiRequest.name == viewModel.profileData?.name &&
            updateProfileApiRequest.city_id == viewModel.profileData?.cityID &&
            didChangePhoneNum == false &&
            updateProfileApiRequest.email == viewModel.profileData?.email{
            debugPrint("Here")
            debugPrint(updateProfileApiRequest.city_id,viewModel.profileData?.cityID)
     
            // +966543064111
            
            showAlert(title: "Alert", message: Utils.localizedText(text: "Please provide information to update"),alertType: .alert)
            
            return
        }
        
        if DataManager.getLoginType == "social" && updateProfileApiRequest.email != viewModel.profileData?.email{
            showAlert(title:  "Alert", message:  "Apple id/email cannot be changed.")
            emailLabel.text = viewModel.profileData?.email ?? ""
            return
        }
        
        
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        viewModel.updateUserProfile(request: updateProfileApiRequest,onCompletionCallback: {
            success,message in
                UIManager.hideCustomActivityIndicator(controller: self)
                if success{
                    (self.parent?.parent?.parent as! TabbarContainerViewController).weatherView.userNameLabel.text = self.nameLabel.text ?? ""
            
                    DataManager.setCityForHomeData = DataManager.getUserData?.city_id
                    
                    self.showAlert(title: Utils.localizedText(text: "Success"), message: message ?? "",onOkTapped: {
                        if DataManager.getLanguage == Language.arabic.rawValue{
                        (self.navigationController?.tabBarController as!
                         ArtStationTabViewController).selectedIndex = 4
                        }else{
                            (self.navigationController?.tabBarController as!
                             ArtStationTabViewController).selectedIndex = 0
                        }
                                            (self.navigationController?.tabBarController as! ArtStationTabViewController).setupTabBarViews()
                    },alertType: .alert)
                    
                    
                    
                    self.didChangePhoneNum = false
                   self.getProfileData()
                }else{
                    self.showAlert(title:  "Alert", message: message ?? "")
                }
                
        })
    }
    
    
    
    func getCities(){
        authViewModel.getCities(onCompletionCallback: {
            
            [unowned self] success,errorMessage in
            if success{
                self.citiesView.dropDown.dataSource = self.authViewModel.cities
                if authViewModel.cities.count > 0{
                self.citiesView.placeHolderText = self.authViewModel.cities[0]
                }
                
                self.getProfileData()
              
            }
            else{
                self.getProfileData()
            }
            
        })
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dobCancelButton.isHidden = true
        datePickerDoneButton.isHidden = true
        datePicker.isHidden = true
    }
    
    
    func setupUI(){
        
        citiesView.holdingController = self
        citiesView.textInputFeild.textColor = UIColor.black
        datePicker.backgroundColor = datePickerDoneButton.backgroundColor
       // dobLabel.isEnabled = false
        updateButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor(named: "tabbar_item_tint")!, borderRadius: 17, borderColor: UIColor(named: "tabbar_item_tint"), borderWidth: 2)
        datePicker.setFutureYearValidation()
        
        contactNumLabel.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                 for: .editingChanged)
        contactNumLabel.addTarget(self, action: #selector(textFieldDidEditBegin(_:)), for: .editingDidBegin)
        
    }
    
    @objc func textFieldDidEditBegin(_ textField: UITextField) {
        
        if DataManager.appLanguage == Language.arabic.rawValue{
            let endPosition = textField.beginningOfDocument
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        }else{
            let endPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        }
        
     
    }
     
       
    @objc func textFieldDidChange(_ textField: UITextField) {
            if  (textField.text?.count ?? 0) == 1{
               let phoneNum = textField.text ?? ""
                
               textField.text = "+966 " + (phoneNum.toPhoneNumber() )
               didChangePhoneNum = true
            }
        else if (textField.text?.count ?? 0) > 0{
                let phoneNum = String(textField.text?.dropFirst(5) ?? "").replacingOccurrences(of: " ", with: "")
                textField.text = "+966 " + (phoneNum.toPhoneNumber() )
                didChangePhoneNum = true
            }
             
        }
    
    
    
    //MARK:- Get ProfileData
    func getProfileData(){
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        
        viewModel.getProfile(onCompletionHandler: {
            
            success , message in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                self.updateButton.isEnabled = true
                if let profileData = self.viewModel.profileData{
                    self.nameLabel.text = profileData.name
                    self.emailLabel.text = profileData.email
                   if let phoneNum = profileData.phone{
                        if phoneNum == "" || phoneNum == "0"{
                            self.contactNumLabel.text = ""
                            self.contactNumLabel.attributedPlaceholder = NSAttributedString(string: Utils.localizedText(text: "+966 "),attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                        }else{
                            self.contactNumLabel.text = "+966 " +  String(profileData.phone?.dropFirst(3) ?? "").toPhoneNumber()
                         
                        }
                    }
                    if let city = profileData.city{
                        debugPrint("cityData",city)
                        var cityString = ""
                        if city == ""{
                            cityString = ""
                        }
                        else if city == "0"{
                            cityString = ""
                        } else{
                            cityString = city
                        }
                        if cityString == ""{
                            self.citiesView.textInputFeild.text = Utils.localizedText(text: "Jeddah")
                        }
                        else{
                            self.citiesView.textInputFeild.text = Utils.localizedText(text: cityString)
                            self.citiesView.dropDown.selectRow((profileData.cityID ?? 1) - 1)
                            if DataManager.getLanguage == Language.arabic.rawValue{
                                self.citiesView.textInputFeild.font = UIFont(name: "Almarai-bold", size: 16)!
                              
                            }else{
                                self.citiesView.textInputFeild.font = UIFont(name: "Poppins-Semibold", size: 16)!
                            }
                           
                        }
                       
                    }
//                    if profileData.dob == ""{
//
//                        self.dobLabel.text = Utils.localizedText(text: "Tap to select DOB")
//                }
//                    else{
//                        self.dobLabel.text = profileData.dob
//
//                    }
                    
                }
                else{
                    
                    self.updateButton.isEnabled = false
                    self.showAlert(title: Utils.localizedText(text: "Error"), message: "An error occured")
                }
            }
            else{
                self.updateButton.isEnabled = false
                self.showAlert(title: Utils.localizedText(text: "Error"), message: message ?? "")
            }
            
        })
    }
    
    @IBAction func onDobTapped(_ sender: Any) {
        self.view.endEditing(true)
        manageDatePicker(visibility: !datePicker.isHidden)
    }
    @IBAction func onDoneButtonTapped(_ sender: Any) {
        manageDatePicker(visibility: true)
    }
    func manageDatePicker(visibility isHidden : Bool){
        
        dobCancelButton.isHidden = isHidden
        datePickerDoneButton.isHidden = isHidden
        datePicker.isHidden = isHidden
        
//        if isHidden{
//            dobLabel.text = datePicker.convertDateFormat(to: "DD/MM/YYYY")
//        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField==nameLabel
        {
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
            
            
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
               return false
            }
            else
            {
                return true
            }
        }
        if textField==contactNumLabel
        {
            let characterset = CharacterSet(charactersIn: "0123456789")
            
            
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
               return false
            }
            else
            {
                return true
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
       
        return true
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
