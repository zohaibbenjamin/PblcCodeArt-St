
//  ArtistCustomPackViewController.swift
//  ArtStation
//
//  Created by Apple on 09/06/2021.

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import FSCalendar


class ArtistCustomPackViewController: UIViewController {
    
    @IBOutlet weak var viewNoOfMusician: InputTextfieldWithDropDown!
    @IBOutlet weak var viewNoOfBandMembers: InputTextfieldWithDropDown!
    @IBOutlet weak var viewNoOfInstruments: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTypeOfInstruments: InputTextfieldWithDropDown!
    @IBOutlet weak var viewPrefferedNoOfAudience: InputTextfieldWithDropDown!
    @IBOutlet weak var viewEventPlace: FormDropDownPackage!
    @IBOutlet weak var viewAdditional: InputTextfieldWithDropDown!
    @IBOutlet weak var viewPlayTIme: InputTextfieldWithDropDown!
    @IBOutlet weak var viewEventDate: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTimeHours: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTimeMin: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTimeAmPm: InputTextfieldWithDropDown!
    @IBOutlet weak var viewDressCode: FormDropDownPackage!
    @IBOutlet weak var viewEventType: InputTextfieldWithDropDown!
    @IBOutlet weak var viewYourBudget: InputTextfieldWithDropDown!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var mapview:UIView!
    @IBOutlet weak var searchBarView:UIView!
    
    @IBOutlet weak var scrollViewHeightConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var viewCaledarSelection: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var viewTimeSelection: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var imgSingNo: UIImageView!
    @IBOutlet weak var imgSingYes: UIImageView!
    
    @IBOutlet weak var imgIndoor: UIImageView!
    @IBOutlet weak var imgOutDoor: UIImageView!
    
    @IBOutlet weak var viewLocationSearchTableView:UIView!
    
    
    //MARK: - Google Map Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtLoc: InputTextfieldWithDropDown!
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    var isFirstTime : Bool = true
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = DressCalendarViewModel()
    
    var currentLat="0.00"
    var currentLong="0.000"
    var hasScheduledLocationSet = false
    
    //MARK:- Data
    let onBoardingCollectionViewCellIdentifier = "onboarding_feature_cell"
    var currentItem = 0
    var dateSelectable = [String]()
    var dateUnavailable = [String]()
    var dateUnSelectable = [String]()
    var allowableMonthsForBooking = 6
    var dateSelected = ""
    var timeSelection = ""
    var addressSelection = ""
    var eventSetupSelection = "Indoor"
    var DressCodeSelected = ""
    var preferedPlace = ""
    
    var artistID:String?
    var isTabBarCustomPackagViewController:Bool?
    
    //MARK: - check if the screen is from tabbar of viewcontroller
    var isTabbarScreen:Bool?
    
    
    fileprivate var lunar: Bool = false {
        didSet {
            self.calendarView.reloadData()
        }
    }
    fileprivate let lunarFormatter = LunarFormatter()
    fileprivate var theme: Int = 0 {
        didSet {
            switch (theme) {
            case 0:
                self.calendarView.appearance.weekdayTextColor = /*UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)*/UIColor.red
                self.calendarView.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0,blue: 221/255.0, alpha: 1.0)
                self.calendarView.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendarView.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendarView.appearance.headerDateFormat = "MMMM yyyy"
                
                self.calendarView.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                self.calendarView.appearance.borderRadius = 1.0
                self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.2
            case 1:
                self.calendarView.appearance.weekdayTextColor = UIColor.red
                self.calendarView.appearance.headerTitleColor = UIColor.darkGray
                self.calendarView.appearance.eventDefaultColor = UIColor.green
                self.calendarView.appearance.selectionColor = UIColor.blue
                self.calendarView.appearance.headerDateFormat = "yyyy-MM";
                self.calendarView.appearance.todayColor = UIColor.red
                self.calendarView.appearance.borderRadius = 1.0
                self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
            case 2:
                self.calendarView.appearance.weekdayTextColor = UIColor.red
                self.calendarView.appearance.headerTitleColor = UIColor.red
                self.calendarView.appearance.eventDefaultColor = UIColor.green
                self.calendarView.appearance.selectionColor = UIColor.blue
                self.calendarView.appearance.headerDateFormat = "yyyy/MM"
                self.calendarView.appearance.todayColor = UIColor.orange
                self.calendarView.appearance.borderRadius = 0
                self.calendarView.appearance.headerMinimumDissolvedAlpha = 1.0
            default:
                break;
            }
        }
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate var gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    
    //MARK: - didLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingUI()
        
        mapView.delegate=self
        mapView.setMinZoom(8, maxZoom: 22)
        LocationManager.sharedInstance.delegate=self
        txtLoc.imgDropDown.isHidden = true
        txtLoc.btnDropDown.isHidden = true
        
        searchBar.delegate = self
        tableDataSource = GMSAutocompleteTableDataSource()
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "SA"
        
        tableDataSource.autocompleteFilter = filter
        tableDataSource.delegate = self
        
        locationsTableView.delegate = tableDataSource
        locationsTableView.dataSource = tableDataSource
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            searchBar.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollview.scrollToView(view: self.viewNoOfMusician, animated: false)
        clearForm()
    }
  
    
    @IBAction func btnBookCustomPackage(_ sender:UIButton){
        apiCallForCustomBooking()
    }
    
    @IBAction func btnEventCalendarCLick(_ sender: Any) {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        apiCallForArtistCalendar()
    }
    
    @IBAction func btnDoneForCalendarSelection(_ sender: Any) {
        viewCaledarSelection.isHidden=true
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = inputFormatter.date(from: dateSelected.description)
        if currentDate==nil
        {
            return
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateToDisplay = outputFormatter.string(from: currentDate!)
        viewEventDate.txtField.text = dateToDisplay
    }
    
    @IBAction func btnEventTimeCLick(_ sender: Any) {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        viewTimeSelection.isHidden=false
    }
    
    
    @IBAction func btnDoneForTIme(_ sender: Any) {
        
        let outputFormatterM = DateFormatter()
        outputFormatterM.dateFormat = "HH:mm"
        timeSelection = outputFormatterM.string(from: timePicker.date)
        
        
        viewTimeSelection.isHidden=true
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "hh:mm a"
        var timeSelectionM = outputFormatter.string(from: timePicker.date)
        
        outputFormatter.dateFormat = "hh"
        viewTimeHours.txtField.text = outputFormatter.string(from: timePicker.date)
        
        outputFormatter.dateFormat = "mm"
        viewTimeMin.txtField.text = outputFormatter.string(from: timePicker.date)
        
        outputFormatter.dateFormat = "a"
        viewTimeAmPm.txtField.text = outputFormatter.string(from: timePicker.date)
        
        var hoours=1
        if timeSelectionM==nil
        {
            return
        }
        hoours =  Int(viewTimeHours.txtField.text ?? "1")!
        if outputFormatter.string(from: timePicker.date)=="PM"
        {
            outputFormatter.dateFormat = "hh"
            if outputFormatter.string(from: timePicker.date)=="12"
            {
                
            }
            else
            {
                
                hoours = hoours+12
            }
        }
        
        //timeSelection = "\(hoours):\(String(describing: viewTImeMins.txtField.text!)))"
        print("uuuuuuuuuuuuuuuuuu",timeSelection)
    }
    
    
    @IBAction func btnCurrentLocClick(_ sender: Any) {
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        debugPrint("ViewDidAppear")
        if CLLocationManager.locationServicesEnabled(){
            
            switch LocationManager.sharedInstance.getAuthorizationStatus(){
                
            case .notDetermined:
                LocationManager.sharedInstance.requestForLocationPermission()
            case .restricted,.denied:
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
                break
            default:
                break
            }
            
        }else{
            showAlert(title: "Alert", message: "Allow access to your location so we can confirm nearest possible location for your event.")
        }
        
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    func SettingUI()
    {
        
        //MARK: - FormDropDowndelegates
        
        viewEventPlace.delegate = self
        viewDressCode.delegate = self
        
        
        let dressCodes = ["Saudi Formal","Casual","Formal"]
        
        var DressCodeLocalized: [String] = []
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            for item in dressCodes {
                DressCodeLocalized.append(Utils.localizedText(text: item))
            }
            viewDressCode.dropDownDataSource =  DressCodeLocalized ?? []
        }else{
            viewDressCode.dropDownDataSource =  dressCodes ?? []
        }
         
         viewDressCode.holdingController = self
        
         viewDressCode.dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
             guard let _ = self else { return }
             self?.DressCodeSelected = dressCodes[index]
             self?.viewDressCode.textInputFeild.text = item
            // DataManager.requestPlaceToBeSent = item
             //DataManager.requestedPlaces = item
             debugPrint(item)
         }
        
      
        
         
        let eventPlaces =  ["Private House","Beach House","Woman wedding","Mens wedding","Isteraha","Desert or tent"]
        
        var placesLocalized: [String] = []
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            for item in eventPlaces {
                placesLocalized.append(Utils.localizedText(text: item))
            }
            viewEventPlace.dropDownDataSource =  placesLocalized ?? []
        }else{
            viewEventPlace.dropDownDataSource =  eventPlaces ?? []
        }
        
        viewEventPlace.holdingController = self
        viewEventPlace.dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            self?.preferedPlace = eventPlaces[index]
            self?.viewEventPlace.textInputFeild.text = item
            DataManager.requestPlaceToBeSent = item
            DataManager.requestedPlaces = item
            debugPrint(item)
        }
        
        viewNoOfMusician.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        viewNoOfBandMembers.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        viewNoOfInstruments.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
    
       
        
        viewPrefferedNoOfAudience.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text: ""), txtLabel: "")

        viewEventPlace.textInputFeild.frame = CGRect.init(x: 0, y: 0, width: viewEventPlace.frame.width, height:viewEventPlace.frame.height)
        viewEventPlace.dropdownAncherImageview.contentMode = .center
       
        
        viewAdditional.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text: "yes or no"), txtLabel: "")
        viewPlayTIme.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        viewEventDate.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "", txtLabel: "")
        viewEventDate.imgDropDown.image=UIImage.init(named: "ic_event_24px")
        
        calendarView.delegate=self
        UIManager.makeShadow(view: calendarView)
        UIManager.makeShadow(view: viewTimeSelection)
        calendarView.appearance.borderRadius = 16
        calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        calendarView.appearance.calendar.placeholderType = FSCalendarPlaceholderType.none
        
        
        viewEventType.imgDropDown.image=UIImage.init(named: "")
        viewEventType.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text: Utils.localizedText(text: "Please specify event type")), txtLabel: "")
        
        viewEventDate.imgDropDown.image=UIImage.init(named: "ic_event_24px")
        viewEventDate.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: Utils.localizedText(text: "Please select a date"), txtLabel: "")
        
        

        viewDressCode.textInputFeild.frame = CGRect.init(x: 0, y: 0, width: viewDressCode.frame.width, height:viewDressCode.frame.height)
        viewDressCode.dropdownAncherImageview.contentMode = .center
       
        
        viewTimeHours.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "00", txtLabel: "")
        
        viewTimeHours.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTimeHours.frame.width, height:viewTimeHours.frame.height)
        viewTimeHours.imgDropDown.contentMode = .center
        viewTimeHours.txtField.textAlignment = NSTextAlignment.center
        
        viewTimeMin.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "00", txtLabel: "")
        viewTimeMin.imgDropDown.contentMode = .center
        viewTimeMin.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTimeMin.frame.width, height:viewTimeMin.frame.height)
        viewTimeMin.txtField.textAlignment = NSTextAlignment.center
        
        viewTimeAmPm.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "--", txtLabel: "")
        viewTimeAmPm.imgDropDown.contentMode = .center
        
        viewTimeAmPm.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTimeAmPm.frame.width, height:viewTimeAmPm.frame.height)
        viewTimeAmPm.txtField.textAlignment = NSTextAlignment.center
        
        viewYourBudget.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        viewYourBudget.txtField.frame = CGRect.init(x: 0, y: 0, width: viewYourBudget.frame.width, height:viewYourBudget.frame.height)
        viewYourBudget.imgDropDown.contentMode = .center
        
        if DataManager.getLanguage=="ar"
        {
            viewEventDate.imgViewTrailingCOnst.constant = 10
            viewTimeHours.imgViewTrailingCOnst.constant = 5
            viewTimeMin.imgViewTrailingCOnst.constant = 5
            viewTimeAmPm.imgViewTrailingCOnst.constant = 5
            viewEventPlace.textInputFeild.textAlignment = NSTextAlignment.right
            viewDressCode.textInputFeild.textAlignment = NSTextAlignment.right
            viewYourBudget.txtField.textAlignment = NSTextAlignment.right
            viewPlayTIme.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "عدد الساعات", txtLabel: "")
            viewTypeOfInstruments.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder:"مثال : عود ، كمان ، فرقة كاملة", txtLabel: "")
        }
        else
        {
            viewEventDate.imgViewTrailingCOnst.constant = -10
            viewTimeHours.imgViewTrailingCOnst.constant = -5
            viewTimeMin.imgViewTrailingCOnst.constant = -5
            viewTimeAmPm.imgViewTrailingCOnst.constant = -5
            viewEventPlace.textInputFeild.textAlignment = NSTextAlignment.left
            viewDressCode.textInputFeild.textAlignment = NSTextAlignment.left
            viewYourBudget.txtField.textAlignment = NSTextAlignment.left
            viewPlayTIme.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "Hours", txtLabel: "")
            viewTypeOfInstruments.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        }
        
    }
    
    @IBAction func btnCLickSIng(_ sender: Any) {
        
        if imgSingYes.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()
        {
            imgSingYes.image=UIImage.init(named: "check_box_unchecked")
            imgSingNo.image=UIImage.init(named: "check_box_checked")
        }
        else
        {
            imgSingYes.image=UIImage.init(named: "check_box_checked")
            imgSingNo.image=UIImage.init(named: "check_box_unchecked")
        }
    }
    
    @IBAction func btnClickEventSetup(_ sender: Any) {
        if imgIndoor.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()
        {
            imgIndoor.image=UIImage.init(named: "check_box_unchecked")
            imgOutDoor.image=UIImage.init(named: "check_box_checked")
        }
        else
        {
            imgIndoor.image=UIImage.init(named: "check_box_checked")
            imgOutDoor.image=UIImage.init(named: "check_box_unchecked")
        }
    }
}
extension ArtistCustomPackViewController: LocationManagerDelegate
{
    func tracingLocation(currentLocation: CLLocation) {
        LocationManager.sharedInstance.stopUpdatingLocation()
        LocationManager.userLocation = currentLocation
        setLocationAddress()
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        LocationManager.sharedInstance.stopUpdatingLocation()
        LocationManager.userLocation = CLLocation.init(latitude: 0.00, longitude: 0.00)
        setLocationAddress()
    }
    
    
    func setLocationAddress()
    {
        
        var camera = GMSCameraPosition()
        camera = GMSCameraPosition.camera(withLatitude:LocationManager.userLocation?.coordinate.latitude ?? 0.00,longitude:LocationManager.userLocation?.coordinate.longitude ?? 0.00, zoom: 16)
        self.mapView?.animate(to: camera)
    }
    
}

extension ArtistCustomPackViewController:UIGestureRecognizerDelegate,GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        LocationManager.sharedInstance.stopUpdatingLocation()
        LocationManager.userLocation = CLLocation.init(latitude: mapView.camera.target.latitude, longitude:  mapView.camera.target.longitude)
        LocationManager.sharedInstance.getAddressFromLocation { (Address) in
            self.txtLoc.txtField.text=Address
            self.addressSelection = Address
            
        }
        if isFirstTime{
            isFirstTime.toggle()
        }else{
            LocationManager.sharedInstance.getAddressFromLocation(Address: {
                //              self.searchBar.text = $0
                debugPrint($0.debugDescription)
            })
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        debugPrint(place.addressComponents,"PlaceInformation")
        let zoom = mapView.camera.zoom
        let camera = GMSCameraPosition.camera(withLatitude:place.coordinate.latitude,longitude:place.coordinate.longitude, zoom: zoom)
        mapView.animate(to: camera)
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ArtistCustomPackViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 || searchBar.text == nil{
           // locationsTableView.isHidden = true
            viewLocationSearchTableView.isHidden = true
            scrollViewHeightConstraint.constant = (DataManager.getLanguage == "ar") ? 1600 : 1650
            self.view.layoutIfNeeded()
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }else{
            //locationsTableView.isHidden = false
            tableDataSource.sourceTextHasChanged(searchText)
        }
            self.view.layoutIfNeeded()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("SearchBarText \(searchBar.text ?? "")")
    }
}


extension ArtistCustomPackViewController: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        // Reload table data.
        locationsTableView.reloadData()
        locationsTableView.isHidden = false
        scrollViewHeightConstraint.constant = ((DataManager.getLanguage == "ar") ? 1600 : 1650)+locationsTableView.contentSize.height
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        // Reload table data.
        locationsTableView.reloadData()
        self.scrollview.scrollToView(view: self.mapview, animated: true)
        locationsTableView.isHidden = false
        scrollViewHeightConstraint.constant = ((DataManager.getLanguage == "ar") ? 1600 : 1650)+locationsTableView.contentSize.height
        viewLocationSearchTableView.isHidden = false
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        // Do something with the selected place.
        
        let zoom = mapView.camera.zoom
        let camera = GMSCameraPosition.camera(withLatitude:place.coordinate.latitude,longitude:place.coordinate.longitude, zoom: zoom)
        mapView.animate(to: camera)
        locationsTableView.isHidden = true
        scrollViewHeightConstraint.constant = ((DataManager.getLanguage == "ar") ? 1600 : 1650)
        self.view.layoutIfNeeded()

        
        self.view.endEditing(true)
        
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // Handle the error.
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}

extension ArtistCustomPackViewController:FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance
{
    
    //color selection background circle
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
    //       return UIColor.blue
    //    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let currentDate = inputFormatter.date(from: date.description)
        let outputFormatter = DateFormatter()
        print(currentDate)
        outputFormatter.dateFormat = "yyyy-MM-dd"
        let todayNumberString = outputFormatter.string(from: currentDate!)
        //        if dateSelectable.contains(todayNumberString)
        //        {
        //            return UIColor.hexStringToUIColor(hex: "#A7FFAD")
        //        }
        //        else
        
        
        
        if date .compare(Date()) == .orderedAscending {
            return UIColor.white
        }
        if dateUnSelectable.contains(todayNumberString)
        {
            return UIColor.hexStringToUIColor(hex: "#FFABC1")
        }
        else if dateUnavailable.contains(todayNumberString)
        {
            return UIColor.hexStringToUIColor(hex: "#FFCC00")
        }
        
        else
        {
            return UIColor.hexStringToUIColor(hex: "#A7FFAD")
        }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        //
        //             let inputFormatter = DateFormatter()
        //             inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //
        //             let outputFormatter = DateFormatter()
        //             outputFormatter.dateFormat = "dd-MM-YYYY"
        //
        //             let showDate = inputFormatter.date(from: date.description)
        //             let resultString1 = outputFormatter.string(from: showDate!)
        //
        //             let todayDate = inputFormatter.date(from: Date.init().description)
        //             let resultString2 = outputFormatter.string(from: todayDate!)
        //
        //             if resultString1==resultString2 {
        //                  return true
        //             }
        //             if date .compare(Date()) == .orderedDescending {
        //                  return false
        //             }
        //             else {
        //                  return true
        //              }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let currentDate = inputFormatter.date(from: date.description)
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        let todayNumberString = outputFormatter.string(from: currentDate!)
        
        
        
        if date.compare(Date()) == .orderedAscending {
            return false
        }
        
        if dateUnSelectable.contains(todayNumberString)
        {
            return false
        }
        else
            if dateUnavailable.contains(todayNumberString)
        {
                return false
            }
        else
        {
            return true
        }
        
    }
    
    //    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
    //        return (MUtility.ifAppLanguageARABIC()) ? self.showArabicSubTitle(date: date) : ""
    //    }
    //
    //
    
    
    
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return self.gregorian.isDateInToday(date) ? "今天" : nil
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard self.lunar else {
            return nil
        }
        return self.lunarFormatter.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let currentDate = inputFormatter.date(from: date.description)
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        dateSelected = outputFormatter.string(from: currentDate!)
        
    }
    
    func showArabicSubTitle(date: Date!) -> String!
    {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd"
        
        var calendarDate = dateFormater.string(from: date as Date)
        
        let characters = Array(calendarDate)
        
        let substituteArabic = ["0":"٠", "1":"١", "2":"٢", "3":"٣", "4":"٤", "5":"٥", "6":"٦", "7":"٧", "8":"٨", "9":"٩"]
        var arabicDate =  ""
        
        for i in characters {
            if let subs = substituteArabic[String(i)] {
                arabicDate += subs
            } else {
                arabicDate += String(i)
            }
        }
        
        return arabicDate
    }
    
    
    
}


extension ArtistCustomPackViewController
{
    func apiCallForArtistCalendar() {
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
        viewModel.getArtistCalendarData(params: ["month":allowableMonthsForBooking.description,"artist_id":""]){
            success,errorString in
            UIManager.hideCustomActivityIndicator(controller: self)
            self.dateUnSelectable = [String]()
            if success{

                for itemObj in self.viewModel.dataObj?.days ?? [Day]() {
                    if itemObj.availability=="unavailable"
                    {
                        self.dateUnavailable.append(itemObj.start_date!)
                    }
                    else
                    {
                        self.dateUnSelectable.append(itemObj.start_date!)
                    }
                }
                self.viewCaledarSelection.isHidden=false


            }else{
                self.showAlert(title: "Error", message: errorString ?? "")
            }
            self.calendarView.reloadData()
        }
    }
    
    func apiCallForCustomBooking() {
        
        customBooking.sharedInstance.userType = "Artist"
        customBooking.sharedInstance.bandMembersCount = Int(viewNoOfBandMembers.txtField.text?.description ?? "0") ?? 0
        customBooking.sharedInstance.musiciansCount = Int(viewNoOfBandMembers.txtField.text?.description ?? "0") ?? 0
        customBooking.sharedInstance.instrumentCount = Int(viewNoOfInstruments.txtField.text?.description ?? "0") ?? 0
        customBooking.sharedInstance.instrumentType = viewTypeOfInstruments.txtField.text ?? ""
        customBooking.sharedInstance.preferredAudienceCount = Int(viewPrefferedNoOfAudience.txtField.text?.description ?? "0") ?? 0
        customBooking.sharedInstance.dress_code = DressCodeSelected
        customBooking.sharedInstance.eventDate = dateSelected
        customBooking.sharedInstance.eventTime = timeSelection
        customBooking.sharedInstance.eventAddress = addressSelection
        customBooking.sharedInstance.eventPlace = preferedPlace
        customBooking.sharedInstance.eventInfo = viewAdditional.txtField.text ?? ""
        
        let playtime = viewPlayTIme.txtField.text?.description ?? "0"
        
        customBooking.sharedInstance.playTime = Int(playtime) ?? 0
        
        customBooking.sharedInstance.goToSing = (imgSingYes.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()) ? "1" : "0"
        
        customBooking.sharedInstance.event_type = viewEventType.txtField.text ?? ""
        customBooking.sharedInstance.dress_setup = (imgIndoor.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()) ? "Indoor" : "Outdoor"
        
        customBooking.sharedInstance.price = Double(viewYourBudget.txtField.text ?? "0") ?? 0
        
        debugPrint(customBooking.sharedInstance)
        
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
    
        viewModel.SubmitCustomPackageRequest2(param: customBooking.sharedInstance) {
            success,errorString in
            UIManager.hideCustomActivityIndicator(controller: self)
            self.dateUnSelectable = [String]()
            if success{
                UIManager.hideCustomActivityIndicator(controller: self)
                self.showArtStationAlert(message: Utils.localizedText(text: "Your request has been sent. You will be contacted by Art Station soon"), onOkTapped: {
                    self.clearForm()
                    if self.isTabBarCustomPackagViewController ?? true{
                        self.navigationController?.popToRootView()
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }, alertType: .alert)
                
            }else{
                UIManager.hideCustomActivityIndicator(controller: self)
                self.showAlert(title: "Error", message: errorString ?? "")
            }
            self.calendarView.reloadData()
        }
        
    }
}

extension ArtistCustomPackViewController:onDropDownGainFocaus,ProtocolResignKeyboard{
    func didgainFocaus() {
        self.view.endEditing(true)
    }
    func resignFirstResp() {
        self.view.endEditing(true)
    }
    
    func clearForm() {
        viewNoOfBandMembers.txtField.text = ""
        viewNoOfBandMembers.txtField.text = ""
        viewNoOfInstruments.txtField.text = ""
        viewTypeOfInstruments.txtField.text = ""
        viewPrefferedNoOfAudience.txtField.text = ""
        viewDressCode.textInputFeild.text = ""
        viewEventDate.txtField.text = ""
        viewTimeMin.txtField.text = "--"
        viewTimeHours.txtField.text = "--"
        viewTimeAmPm.txtField.text = "--"
        
        viewAdditional.txtField.text = ""
        txtLoc.txtField.text = ""
        
        viewEventPlace.textInputFeild.text = ""
        
        viewAdditional.txtField.text = ""
        self.viewYourBudget.txtField.text = ""
        
        viewPlayTIme.txtField.text = ""
        
        customBooking.sharedInstance.goToSing = (imgSingYes.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()) ? "1" : "0"
        
        viewEventType.txtField.text = ""
    }
    
}
