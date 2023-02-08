//
//  UserRegistrationArtistViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/8/21.
//

import UIKit

class UserRegistrationArtistViewController: UIViewController {
    
    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var categoryField: FormDropDownAuth!
    @IBOutlet weak var TelentType: FormDropDownAuth!
    @IBOutlet weak var termsAndConditionsCheckbox: Checkbox!
    @IBOutlet weak var userNameInputField: FormTextInput!
    @IBOutlet weak var userEmailInputField: FormTextInput!
    @IBOutlet weak var contactNumInputField: ContactInputAuth!
    @IBOutlet weak var cityInputField: FormDropDownAuth!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var privacyPolicyCheckBox: UIView!
    
    let viewModel = UserRegistrationViewModel()
    
    var userType:UserType = UserType.artist
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        
        //        let text = signInButton.titleLabel?.text ?? ""
        cityInputField.holdingController = self
        categoryField.holdingController = self
        TelentType.holdingController = self
        
        
        self.TelentType.dropDown.dataSource = ["Artist","Entertainer"]
        
        self.TelentType.dropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            if index == 0 && item.elementsEqual("Artist"){
                self?.userType = UserType.artist
                self?.categoryField.isHidden = false
                
            }else{
                self?.userType = UserType.entertainer
                self?.categoryField.isHidden = false
            }
            self?.TelentType.textInputFeild.text = item
            self?.getCategories()
        }
        
        registrationButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor.systemPink, borderRadius: registrationButton.frame.height/2, borderColor: nil)
        
        backButton.configureButtonUI(backgroundColor: nil, borderRadius: backButton.frame.height/2, borderColor: .white, borderWidth: 2)
        
        privacyPolicyCheckBox.layer.cornerRadius = 2
        
        userNameInputField.placeHolderText = Utils.localizedText(text: "Artist Stage Name")
        userEmailInputField.placeHolderText = Utils.localizedText(text: "Official Email Address")
        
      
        getCities()
        
    }
    
    func getCategories(){
        
        
        viewModel.getCategories(rolltype: self.userType.rawValue == "entertainer" ? 3 : 2 , onCompletionCallback: {
            
            success,errorMessage in
            
            if success{
                self.categoryField.dropDown.dataSource = self.viewModel.categories ?? []
            }
            else{
                self.cityInputField.dropDown.dataSource = []
            }
        })
    }
    
    func getCities(){
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        
        viewModel.getCities(onCompletionCallback: {
            
            success,errorMessage in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                self.cityInputField.dropDown.dataSource = self.viewModel.cities
            }else{
                
                self.viewModel.loadCachedCitiesData()
                self.cityInputField.dropDown.dataSource = self.viewModel.cities
            }
            
        })
    }
    
    
    @IBAction func onSIgnUpButtonTapped(_ sender: Any) {
        if !checkBox.isChecked{
            self.showAlert(title:  Utils.localizedText(text: "Alert"), message: Utils.localizedText(text: "Please agree to terms and conditions before continuing"),alertType: .alert)
            return
        }
        
        let selectedTalentTypeIndex = TelentType.dropDown.indexForSelectedRow
        if selectedTalentTypeIndex == nil{
            self.showAlert(title: Utils.localizedText(text: "Alert"), message: Utils.localizedText(text: "Talent Type cannot be empty"))
            return
        }
        if selectedTalentTypeIndex == 0{
            let selectedCategoryIndex = categoryField.dropDown.indexForSelectedRow
            if selectedCategoryIndex == nil{
                self.showAlert(title: Utils.localizedText(text: "Alert"), message: Utils.localizedText(text: "Category cannot be empty"))
                return
            }
        }
        
        let userRegistrationRequest = UserRegistrationApiRequest(email: userEmailInputField.textInputFeild.text ?? "", password:  "", socialID:nil, socialPlatform: nil, signupType: "login", user_type: self.userType.rawValue, name: userNameInputField.textInputFeild.text ?? "", city: cityInputField.textInputFeild.text ?? "",
                                                                 category:userType == UserType.artist ? (viewModel.categoriesList?[categoryField.dropDown.indexForSelectedRow!].id ?? -1).description : "1"
                ,
                deviceToken: DataManager.getFCMToken ?? "" , phone:   ("+966 " + (contactNumInputField.textInputFeild.text ?? "")).replacingOccurrences(of: " ", with: ""), city_id:String(viewModel.cityList?[cityInputField.dropDown.indexForSelectedRow ?? 0].id ?? 1), device_type: "ios")
        
        //checks if user enter phone number starting with 5
        
        let phoneNumber = (contactNumInputField.textInputFeild.text ?? "").replacingOccurrences(of: " ", with: "")
       
       if !phoneNumber.hasPrefix("5"){
           self.showAlert(title: "Alert", message: Utils.localizedText(text: "Please enter your phone number starting with 5"),alertType: .alert)
           UIManager.hideCustomActivityIndicator(controller: self)
           return
       }
        
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        
        self.viewModel.registerUser(request: userRegistrationRequest, onCompletionHandler: {
            success,errorMessage in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                
                self.showAlert(title: Utils.localizedText(text: "Success"), message: Utils.localizedText(text: "Your request has been sent. You will be contacted by ArtStation soon."),onOkTapped: {
                    if self.navigationController != nil{
                        self.navigationController?.popViewController(animated: true)}
                    else{
                        self.dismiss(animated: true, completion: nil)
                    }
                },alertType: .alert)
                
            }else{
                self.showAlert(title: Utils.localizedText(text: "Alert"), message: Utils.localizedText(text: errorMessage ?? ""))
            }
        })
        
    }
    
    
    @IBAction func termsAndConditionsCheckBoxTapped(_ sender: Any) {
        termsAndConditionsCheckbox.isChecked = !termsAndConditionsCheckbox.isChecked
    }
    
    
    @IBAction func btnTermsSHowCLick(_ sender: Any)
    {
        
        guard let url = URL(string: ApiEndpoint.termsAndConditionsUrl.removingPercentEncoding ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    
    
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        debugPrint("Back Button Tapped")
        if navigationController != nil{
            self.navigationController?.popViewController(animated: true)}
        else{
            self.dismiss(animated: true, completion: nil)
        }
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
