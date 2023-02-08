//
//  UserRegistrationViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/1/21.
//

import UIKit
import DropDown

class UserRegistrationViewController: UIViewController {
   
    
    //MARK:- IB Refrences
    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var temrsAndConditionsCheckBox: Checkbox!
    @IBOutlet weak var datePickerCancelButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerDoneButton: UIButton!
    @IBOutlet weak var userNameInputField: FormTextInput!
    @IBOutlet weak var userEmailInputField: FormTextInput!
    @IBOutlet weak var contactNumInputField: ContactInputAuth!
    @IBOutlet weak var cityInputField: FormDropDownAuth!
    @IBOutlet weak var confirmPasswordInputField: FormTextInput!
    @IBOutlet weak var passwordInputField: FormTextInput!
    @IBOutlet weak var dobInputField: CustomDatePicker!
  
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var privacyPolicyCheckBox: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    
    //MARK:- Data
    let viewModel = UserRegistrationViewModel()
    var dropDown : DropDown?
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    
    
    //MARK:- Setup UI
    func setupUI(){
        let text = signInButton.titleLabel?.text ?? ""
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
               attributedText.addAttribute(.underlineStyle,
                                           value: NSUnderlineStyle.single.rawValue,
                                           range: textRange)
        signInButton.titleLabel?.attributedText = attributedText
        
        registrationButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor(named: "tabbar_item_tint")!, borderRadius: registrationButton.frame.height/2, borderColor: nil)
  
        cityInputField.holdingController = self
      backButton.configureButtonUI(backgroundColor: nil, borderRadius: backButton.frame.height/2, borderColor: .white, borderWidth: 2)
        
        privacyPolicyCheckBox.layer.cornerRadius = 2
        
        //dobInputField.delegate = self
        datePicker.backgroundColor = datePickerDoneButton.backgroundColor
        datePicker.setFutureYearValidation()
        passwordInputField.textInputFeild.maxLength = 20
        //confirmPasswordInputField.textInputFeild.maxLength = 20
        getCities()
        
    }
    
    //MARK:- GetDataForCities
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
    
    
    //MARK:- SingUp Button Tapped
    @IBAction func onSIgnUpButtonTapped(_ sender: Any) {
        if !checkBox.isChecked{
            self.showAlert(title: "Alert", message: "Please agree to terms and conditions before continuing",alertType: .alert)
            return
        }
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)

        let userRegistrationRequest = UserRegistrationApiRequest(email: userEmailInputField.textInputFeild.text ?? "", password: passwordInputField.textInputFeild.text ?? "", socialID: nil, socialPlatform: nil, signupType: nil, user_type: UserType.user.rawValue, name: userNameInputField.textInputFeild.text ?? "", city:cityInputField.textInputFeild.text ?? "", category: nil, deviceToken: DataManager.getFCMToken ?? "", phone:  ("+966 " + (contactNumInputField.textInputFeild.text ?? "")).replacingOccurrences(of: " ", with: ""), city_id:String(viewModel.cityList?[cityInputField.dropDown.indexForSelectedRow ?? 0].id ?? 1), device_type: "ios")
        
         let phoneNumber = (contactNumInputField.textInputFeild.text ?? "").replacingOccurrences(of: " ", with: "")
        
        if !phoneNumber.hasPrefix("5"){
            self.showAlert(title: "Alert", message: Utils.localizedText(text: "Please enter your phone number starting with 5"),alertType: .alert)
            UIManager.hideCustomActivityIndicator(controller: self)
            return
        }
        
            self.viewModel.registerUser(request: userRegistrationRequest, onCompletionHandler: {
            success,errorMessage in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                DataManager.setUserLog = "true"
                DataManager.setUserData = self.viewModel.userData
                DataManager.setLoginType = "normal"
                DataManager.setCityForHomeData = self.viewModel.userData?.city_id
                
                let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
                if let keyWindow = UIWindow.key {
                    keyWindow.rootViewController = homepageViewController
                }
            }else{
                self.showAlert(title:Utils.localizedText(text:  "Alert"), message: errorMessage ?? "")
            }
        })

    }
    
    //MARK:- Date Selected
    @IBAction func onDateSelected(_ sender: Any) {
        Utils.changeVisibilityOf(views: [datePicker,datePickerDoneButton,datePickerCancelButton], isHidden: true)
       // dobInputField.textInputFeild.text = datePicker.convertDateFormat(to: "yyyy-mm-dd")
    }
    
    @IBAction func termsAndConditionsCheckBoxTapped(_ sender: Any) {
        temrsAndConditionsCheckBox.isChecked = !temrsAndConditionsCheckBox.isChecked
    }
    
    
    @IBAction func btnTermsSHowCLick(_ sender: Any)
    {
       
        guard let url = URL(string: ApiEndpoint.termsAndConditionsUrl.removingPercentEncoding ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    
    //MARK:- Back Button Tapped
    @IBAction func onBackButtonTapped(_ sender: Any) {
        debugPrint("Back Button Tapped")
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func datePickerCancelButtonTapped(_ sender: Any) {
        Utils.changeVisibilityOf(views: [datePicker,datePickerDoneButton,datePickerCancelButton], isHidden: true)
        
    }
    @IBAction func alreadyHaveAccountTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UserRegistrationViewController : CustomDatePickerDelegate{
    
    func onCalenderIconTapped() {
        Utils.changeVisibilityOf(views: [datePicker,datePickerDoneButton,datePickerCancelButton], isHidden: !datePicker.isHidden)
    }
    
    
}

