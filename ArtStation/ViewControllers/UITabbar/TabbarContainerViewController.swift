//
//  TabbarContainerViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import UIKit
import CoreLocation
import DropDown

protocol SelectCityDelegate{
    func citySelected(id : Int)
}
class TabbarContainerViewController: UIViewController,WeatherDateViewDelegate, NavigationStackDelegate,ArtStationTabBarDelegate {
    
    var selectCityText : String?
    
    //TODO :- To be replaced with separate dedicated viewModel
    let authViewModel = UserRegistrationViewModel()
    let cityDropDown = DropDown()
    
    
    
    var delegate : SelectCityDelegate?
    
    //MARK:- IB Refrences and Data
    @IBOutlet weak var weatherView: WeatherDateView!
    let viewModel = TabbarContainerViewModel()
    @IBOutlet weak var containerView: UIView!
    var currentLat="0.00"
    var currentLong="0.000"
    var artStationTabBarController : ArtStationTabViewController?
    var openWithIndex : Int?
    var openNotificationsPage : Bool = false
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - forceUpdate check
        checkForceUpdateDetails()
        
        // Do any additional setup after loading the view.
        setupUITabbar()
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            selectCityText = "اختر المدينة"
        }else{
            selectCityText = "Select City"
        }
        LocationManager.sharedInstance.delegate=self
        //apiCallForWeather()
        
        artStationTabBarController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarControllerId, viewController: ArtStationTabViewController.self)
        
        artStationTabBarController?.tabBarDelegate = self
        
        
        self.embed(artStationTabBarController!, inView: containerView)
        
        weatherView.backButton.isHidden = true
        weatherView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(shouldNavToEvents),name:NSNotification.Name(rawValue: "shouldNavToEvents"), object: nil)
        
        for i in 0..<(artStationTabBarController?.children.count ?? 0) {
            let navController = artStationTabBarController?.children[i] as! NavBarViewController
            navController.stackDelegate = self
        }
        
        if DataManager.navFOrEvents == true
        {
            DataManager.navFOrEvents = false
            if DataManager.getLanguage == Language.arabic.rawValue
            {
                artStationTabBarController?.selectedIndex = 3
            }
            else
            {
                artStationTabBarController?.selectedIndex = 1
            }
        }
        
        if let index = openWithIndex{
            artStationTabBarController?.selectedIndex = index
            if openNotificationsPage{
                let navController = artStationTabBarController?.children[index] as! NavBarViewController
                debugPrint(navController)
                let notificationVieController = Utils.getViewController(storyboard: StoryboardId.moreStoryboard, identifier: StoryboardId.notificationViewControllerId, viewController: NotificationViewController.self)
                navController.pushViewController(notificationVieController, animated: false)
            }
        }
        addCityDropDown()
    }
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.containerView.setNeedsLayout()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.containerView.setNeedsLayout()
    }
    
    
    @objc func shouldNavToEvents()
    {
        self.tabBarController?.selectedIndex = 1
    }
    
    func setupUITabbar(){
        
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    
    func setupCityButton(){
        debugPrint("Setup Button Here")
        weatherView.backButton.isHidden = false
        if authViewModel.cityList != nil{
            for index in 0..<(self.authViewModel.cityList?.count  ?? 0 )  {
                
                if self.authViewModel.cityList?[index].id == DataManager.getCityForHomeData{
                    self.weatherView.backButton.setTitle(Utils.localizedText(text: self.authViewModel.cityList?[index].name ?? ""), for: .normal)
                }
            }
        }
    }
    
    
    
    func onItemChanged(itemName: String) {
        debugPrint("mytabv\(artStationTabBarController?.selectedIndex)")
    }
    
    func onControllerPushed() {
        weatherView.backButton.isHidden = false
        weatherView.backButton.setTitle(Utils.localizedText(text: "Back"), for: .normal)
        
    }
    
    func onBackButtonTapped() {
        weatherView.backButton.isEnabled = false
        let navigationController = artStationTabBarController?.selectedViewController as! UINavigationController
        if navigationController.viewControllers.count > 1{
            weatherView.backButton.isHidden = false
            navigationController.popViewController(animated: true)
            debugPrint("TabCount",navigationController.viewControllers.count)
            if artStationTabBarController?.selectedIndex == 0 && navigationController.viewControllers.count == 1 && DataManager.getLanguage == Language.english.rawValue{
                debugPrint("Setting Up City Name")
                
                for index in 0..<(authViewModel.cityList?.count  ?? 0 )  {
                    
                    if authViewModel.cityList?[index].id == DataManager.getCityForHomeData{
                        weatherView.backButton.setTitle(Utils.localizedText(text:authViewModel.cityList?[index].name ?? ""), for: .normal)
                        
                    }
                    
                }
                
            }
            else if artStationTabBarController?.selectedIndex == 3 && navigationController.viewControllers.count == 1 && DataManager.getLanguage == Language.arabic.rawValue{
 
                for index in 0..<(authViewModel.cityList?.count  ?? 0 )  {
                    
                    if authViewModel.cityList?[index].id == DataManager.getCityForHomeData{
                        weatherView.backButton.setTitle(Utils.localizedText(text:authViewModel.cityList?[index].name ?? ""), for: .normal)
                        
                    }
                }
            }
            else if navigationController.viewControllers.count == 1{
                weatherView.backButton.isHidden = true
            }
        }
        else if navigationController.viewControllers.count == 1 && artStationTabBarController?.selectedIndex == 0 && DataManager.getLanguage == Language.english.rawValue{
            debugPrint("Show DropDown")
            if cityDropDown.isHidden{
                cityDropDown.show()
            } else{
                cityDropDown.hide()
            }
        }
        else if navigationController.viewControllers.count == 1 && artStationTabBarController?.selectedIndex == 4 && DataManager.getLanguage == Language.arabic.rawValue{
            debugPrint("Show DropDown")
            if cityDropDown.isHidden{
                cityDropDown.show()
            } else{
                cityDropDown.hide()
            }
        }
        weatherView.backButton.isEnabled = true
        
    }
    
    
    
    
    func navigationViewAppear(controllerCount: Int) {
        if controllerCount > 1 {
            weatherView.backButton.setTitle(Utils.localizedText(text: "Back"), for: .normal)
            weatherView.backButton.isHidden = false
        }else if controllerCount == 1 && artStationTabBarController?.selectedIndex == 0 && DataManager.getLanguage == Language.english.rawValue{
            weatherView.backButton.isHidden = false
            for index in 0..<(self.authViewModel.cityList?.count  ?? 0 )  {
                if self.authViewModel.cityList?[index].id == DataManager.getCityForHomeData{
                    self.weatherView.backButton.setTitle(self.authViewModel.cityList?[index].name ?? "", for: .normal)
                }
            }
        }else if controllerCount == 1 && artStationTabBarController?.selectedIndex == 4 && DataManager.getLanguage == Language.arabic.rawValue{
            weatherView.backButton.isHidden = false
            for index in 0..<(self.authViewModel.cityList?.count  ?? 0 )  {
                if self.authViewModel.cityList?[index].id == DataManager.getCityForHomeData{
                    self.weatherView.backButton.setTitle(self.authViewModel.cityList?[index].name_ar ?? "", for: .normal)
                }
            }
            debugPrint("SettingName")
        }else{
           
            weatherView.backButton.isHidden = true
        }
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            if (artStationTabBarController?.selectedIndex == 4){
                self.weatherView.ChatView.isHidden = false
                self.weatherView.layoutIfNeeded()
                self.weatherView.contentView.layoutIfNeeded()
            }else{
                self.weatherView.ChatView.isHidden = true
                self.weatherView.layoutIfNeeded()
                self.weatherView.contentView.layoutIfNeeded()
            }
            
        }else{
            if( artStationTabBarController?.selectedIndex == 0){
                self.weatherView.ChatView.isHidden = false
                self.weatherView.layoutIfNeeded()
                self.weatherView.contentView.layoutIfNeeded()
            }
            else{
                self.weatherView.ChatView.isHidden = true
                self.weatherView.layoutIfNeeded()
                self.weatherView.contentView.layoutIfNeeded()
            }
        }
        
    }
    
    func addCityDropDown(){
        
        cityDropDown.anchorView = weatherView.backButton
        cityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if let cityId = authViewModel.cityList?[cityDropDown.indexForSelectedRow ?? 0].id{
                delegate?.citySelected(id: cityId)
                weatherView.backButton.setTitle(Utils.localizedText(text: item), for: .normal)
            }
        }
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            let customFont:UIFont = UIFont.init(name: "Almarai-Regular", size: 12.0)!
            cityDropDown.textFont = customFont
            
        }else{
            let customFont:UIFont = UIFont.init(name: "Poppins-Regular", size: 12.0)!
            cityDropDown.textFont = customFont
        }
        getCities()
    }
    
    func getCities(){
        authViewModel.getCities(onCompletionCallback: {
            
            success,errorMessage in
            
            if success{
                self.cityDropDown.dataSource = self.authViewModel.cities
                for index in 0..<(self.authViewModel.cityList?.count  ?? 0 )  {
                    if self.artStationTabBarController?.selectedIndex == 0 && DataManager.getLanguage == Language.english.rawValue{
                        if self.authViewModel.cityList?[index].id == DataManager.getCityForHomeData{
                            self.weatherView.backButton.setTitle(Utils.localizedText(text:self.authViewModel.cityList?[index].name ?? ""), for: .normal)
                            
                        }}  else if self.artStationTabBarController?.selectedIndex == 4 && DataManager.getLanguage == Language.arabic.rawValue{
                            if self.authViewModel.cityList?[index].id == DataManager.getCityForHomeData{
                                self.weatherView.backButton.setTitle(Utils.localizedText(text:self.authViewModel.cityList?[index].name ?? ""), for: .normal)
                                
                            }
                        }
                }
            }else{
                if self.artStationTabBarController?.selectedIndex == 0{
                    self.weatherView.backButton.setTitle(Utils.localizedText(text:self.selectCityText ?? ""), for: .normal)
                    self.authViewModel.loadCachedCitiesData()
                    self.cityDropDown.dataSource = self.authViewModel.cities
                    for index in 0..<(self.authViewModel.cityList?.count  ?? 0 )  {
                        if self.artStationTabBarController?.selectedIndex == 0{
                            if self.authViewModel.cityList?[index].id == DataManager.getCityForHomeData{
                                self.weatherView.backButton.setTitle(Utils.localizedText(text:self.authViewModel.cityList?[index].name ?? ""), for: .normal)
                                
                            }}
                        
                    }
                }
            }
            
        })
    }
    
    func checkForceUpdateDetails() {
        let appversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        debugPrint(appversion)
        
        viewModel.checkForceUpdates { isSuccess, message, response in
            
            if isSuccess{
                
                if response?.force_update == true && response?.ios_version != appversion{
                    self.showForceUpdateAlert(okbtnTitle: Utils.localizedText(text: "Update"), cancelbtnTitle: Utils.localizedText(text: "No thanks"), title: "", message: Utils.localizedText(text: "Please update the ArtStation application to the latest version available to continue using it"), completionHandler: {
                        
                    }, onOkTapped: {
                        guard let url = URL(string: "https://apps.apple.com/us/app/art-station/id1585352837") else { return }
                                UIApplication.shared.open(url, options: [:]) { bool in
                                    if response?.ios_version != appversion{
                                        self.checkForceUpdateDetails()
                                    }
                                }
                            
                    }, alertType: .Forceupdate)
                }else if response?.force_update == false && response?.ios_version != appversion{
                    self.showForceUpdateAlert(okbtnTitle: Utils.localizedText(text: "Update"), cancelbtnTitle: Utils.localizedText(text: "No thanks"), title: "", message: Utils.localizedText(text: "Please update the ArtStation application to the latest version available to continue using it"), completionHandler: {
                        
                    }, onOkTapped: {
                        guard let url = URL(string: "https://apps.apple.com/us/app/art-station/id1585352837") else { return }
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                    }, alertType: .optionalupdate)
                }
            }
        }
    }
}

//MARK:Api Call Category
extension TabbarContainerViewController
{
    
    
    func apiCallForWeather() {
        
        debugPrint("WeatherData    \(currentLat)    ***      \(currentLong)")
        viewModel.getWeatherData(params: ["q" : "\(currentLat),\(currentLong)"]){
            success,errorString in
            
            if success{
                self.weatherView.updateView()
            }else{
                self.weatherView.updateView()
            }
        }
    }
}
//MARK:Location Manager Delegate
extension TabbarContainerViewController:LocationManagerDelegate
{
    func tracingLocation(currentLocation: CLLocation) {
        if !(true)//if not guest
        {
            
            if (true)
            {
                currentLat = String(format: "%f", currentLocation.coordinate.latitude)
                currentLong = String(format: "%f", currentLocation.coordinate.longitude)
                
                //apiCallForWeather()
                LocationManager.sharedInstance.stopUpdatingLocation()
                
            }else
            {
                
                LocationManager.sharedInstance.stopUpdatingLocation()
            }
        }else{
            currentLat = String(format: "%f", currentLocation.coordinate.latitude)
            currentLong = String(format: "%f", currentLocation.coordinate.longitude)
            //apiCallForWeather()
            LocationManager.sharedInstance.stopUpdatingLocation()
        }
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
       // apiCallForWeather()
    }
    
    //MARK: - Chat Option clicked delegate
    func onChatOptionClicked() {
        whatsappChatOptionClicked()
    }
    
    func whatsappChatOptionClicked() {
        if DataManager.getUserLog == "guest"
        {
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
        }
        else{
            let whatsappURL = URL(string:"https://wa.me/+966537746799")!
            debugPrint(whatsappURL)
            if UIApplication.shared.canOpenURL(whatsappURL){
                UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}
