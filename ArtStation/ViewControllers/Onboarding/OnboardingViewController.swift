//
//  OnboardingViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 5/20/21.
//
import UIKit
import FSCalendar
import CoreLocation
import Firebase

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var topBackButton: UIButton!
    
    //MARK:- IB Refrences
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonImage: UIImageView!
    //MARK:- Data
    let onBoardingCollectionViewCellIdentifier = "onboarding_feature_cell"
    var currentItem = 0
    var dataOrder = [0,1]
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.isHidden = true
        if DataManager.getLanguage == Language.arabic.rawValue{
            dataOrder.reverse()
            currentItem = 1
        }
        debugPrint(dataOrder)
        setupUI()
    }
    
    //MARK:- Initial UI Setup
    func setupUI(){
        
        pageControl.isUserInteractionEnabled = false
        pageControl.isHidden = true
        pageControl.numberOfPages = 2
        collectionView.backgroundColor = .none
        topBackButton.configureButtonUI(backgroundColor: nil, borderRadius: topBackButton.frame.height/2, borderColor: .white, borderWidth: 2)
        showBackButton(status: false)
        
    }
    
    //MARK:- BackButtonTapListener
    @IBAction func onBackButtonTapped(_ sender: Any)
    {
        
        if currentItem != 0{
            currentItem -= 1
            collectionView.scrollRectToVisible(CGRect(x: view.frame.width * CGFloat(currentItem), y: 0, width: collectionView.frame.width, height: collectionView.frame.height), animated: true)
            updatePageControl()
        }else if currentItem == 0 && DataManager.getLanguage == Language.arabic.rawValue{
            
            debugPrint("HERE")
            
            let vc = Utils.getViewController(storyboard: StoryboardId.authStoryBoardId, identifier: StoryboardId.authNavControllerId, viewController: UINavigationController.self)
            
            if let keyWindow = UIWindow.key {
                keyWindow.rootViewController = vc
            }
        }
    }
    
    //MARK:- NextButtonTapListener
    @IBAction func onNextButtonTapped(_ sender: Any) {
        debugPrint("HERE")
        //MARK:- Removed Notification and Location Request Messages
        if currentItem != 1{
            currentItem += 1
            collectionView.scrollRectToVisible(CGRect(x: collectionView.frame.width * CGFloat(currentItem), y: 0, width: collectionView.frame.width, height: collectionView.frame.height), animated: true)
            updatePageControl()
        }
        else if DataManager.getLanguage == Language.english.rawValue{
            let vc = Utils.getViewController(storyboard: StoryboardId.authStoryBoardId, identifier: StoryboardId.authNavControllerId, viewController: UINavigationController.self)
            
            if let keyWindow = UIWindow.key {
                keyWindow.rootViewController = vc
            }
        }
        else if DataManager.getLanguage == Language.arabic.rawValue{
            debugPrint("HERE")
        }
    }
    
    //MARK:- Update PageControl
    func updatePageControl(){
        
        if DataManager.getLanguage == Language.english.rawValue{
            if currentItem > 0{
                
                pageControl.currentPage = currentItem - 1
                showBackButton(status: true)
            }
            else{
                UIView.animate(withDuration: 1, animations: { [self] in
                    showBackButton(status: false)
                })
                
            }
            
        }else{
            if currentItem < 1{
                
                pageControl.currentPage = currentItem
                showBackButton(status: true)
            }
            else{
                UIView.animate(withDuration: 1, animations: { [self] in
                    showBackButton(status: false)
                })
                
            }
            
        }
    }
    
    //MARK:- Manages Buttons visiblity
    func showBackButton(status : Bool){
        topBackButton.isHidden = !status
        //        backButtonImage.isHidden = !status
        //        backButton.isHidden = !status
        //        //pageControl.isHidden = !status
    }
    
    
}
//MARK:- CollectionView Delegate
extension OnboardingViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: onBoardingCollectionViewCellIdentifier, for: indexPath) as! OnboardingCollectionViewCell
        
        if indexPath.row == dataOrder[0]{
            
            let languageView = SelectLanguage(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
            languageView.delegate = self
            cell.configureCellUI(contentView: languageView)
            
        }else if indexPath.row == dataOrder[1]{
            let logoView = Logo(frame:  CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
            cell.configureCellUI(contentView: logoView)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

extension OnboardingViewController : ChangeLanguageDelegate{
    func onLanguageChanged() {
        
        debugPrint("Called")
        // Firebase analytics added for language change
        Analytics.logEvent("ios_language_change", parameters: nil)
        
        
             let viewController = Utils.getViewController(storyboard: StoryboardId.onBoardingStoryboard, identifier: "navReg", viewController: UINavigationController.self)
        
            if let keyWindow = UIWindow.key {
                              keyWindow.rootViewController = viewController
                          }
        
    }
}

extension OnboardingViewController: PermissionViewDelegate{
    func onAllowedPermissionTapped(permissionType: PermissionType?) {
        if permissionType == .location{
            
            if CLLocationManager.locationServicesEnabled(){
                
                switch LocationManager.sharedInstance.getAuthorizationStatus(){
                    
                case .notDetermined:
                    LocationManager.sharedInstance.requestForLocationPermission()
                case .restricted,.denied:
                    debugPrint("HERE")
                    let alertController = UIAlertController(title: "Alert", message: "Please go to settings and turn on the location permission.", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: Utils.localizedText(text: "Settings"), style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    self.present(alertController, animated: true, completion: nil)
                case .authorizedWhenInUse,.authorizedAlways:
                    self.showAlert(title: "Alert", message: "You have already given this app permission to use your location.",onOkTapped: {
                        self.onNextButtonTapped(self)
                    },alertType: .alert)
                default:
                    break
                }
                
            }else{
                showAlert(title: "Alert", message: "Please enable locations services to continue.",alertType: .alert)
            }
            
        }
        else if permissionType == .notification{
            
        }
    }
    
    func onDontAllowTapped(permissionType: PermissionType?) {
        onNextButtonTapped(self)
    }
}
