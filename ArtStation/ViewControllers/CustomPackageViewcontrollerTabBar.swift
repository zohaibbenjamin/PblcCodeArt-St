
//  ArtistCustomPackViewController.swift
//  ArtStation
//
//  Created by Apple on 09/06/2021.

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import FSCalendar


class CustomPackageViewcontrollerTabBar: UIViewController,ProtocolResignKeyboard {
    
    @IBOutlet weak var viewNoOfMusicianTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewNoOfBandMembersTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewNoOfInstrumentsTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTypeOfInstrumentsTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewPrefferedNoOfAudienceTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewEventPlaceTabbar: FormDropDownPackage!
    @IBOutlet weak var viewAdditionalTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewPlayTImeTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewEventDateTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTimeHoursTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTimeMinTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTimeAmPmTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewDressCodeTabbar: FormDropDownPackage!
    @IBOutlet weak var viewEventTypeTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var viewYouBudgetTabbar: InputTextfieldWithDropDown!
    @IBOutlet weak var scrollviewTabbar: UIScrollView!
    @IBOutlet weak var mapviewTabbar:UIView!
    @IBOutlet weak var searchBarViewTabbar:UIView!
    
    @IBOutlet weak var scrollViewHeightConstraintTabbar:NSLayoutConstraint!
    
    @IBOutlet weak var viewCaledarSelectionTabbar: UIView!
    @IBOutlet weak var calendarViewTabbar: FSCalendar!
    
    @IBOutlet weak var viewTimeSelectionTabbar: UIView!
    @IBOutlet weak var timePickerTabbar: UIDatePicker!
    
    @IBOutlet weak var imgSingNoTabbar: UIImageView!
    @IBOutlet weak var imgSingYesTabbar: UIImageView!
    
    
    @IBOutlet weak var imgIndoorTabbar: UIImageView!
    @IBOutlet weak var imgOutDoorTabbar: UIImageView!
    
    @IBOutlet weak var viewLocationSearchTableViewTabbar:UIView!
    
    
    //MARK: - Google Map Outlets
    @IBOutlet weak var mapViewTabbar: GMSMapView!
    @IBOutlet weak var txtLocTabbar: InputTextfieldWithDropDown!
    private var tableDataSourceTabbar: GMSAutocompleteTableDataSource!
    
    var isFirstTime : Bool = true
    @IBOutlet weak var locationsTableViewTabbar: UITableView!
    @IBOutlet weak var searchBarTabbar: UISearchBar!
    
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
    
    
    fileprivate var lunar: Bool = false {
        didSet {
            self.calendarViewTabbar.reloadData()
        }
    }
    fileprivate let lunarFormatter = LunarFormatter()
    fileprivate var theme: Int = 0 {
        didSet {
            switch (theme) {
            case 0:
                self.calendarViewTabbar.appearance.weekdayTextColor = /*UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)*/UIColor.red
                self.calendarViewTabbar.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0,blue: 221/255.0, alpha: 1.0)
                self.calendarViewTabbar.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendarViewTabbar.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendarViewTabbar.appearance.headerDateFormat = "MMMM yyyy"
                
                self.calendarViewTabbar.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                self.calendarViewTabbar.appearance.borderRadius = 1.0
                self.calendarViewTabbar.appearance.headerMinimumDissolvedAlpha = 0.2
            case 1:
                self.calendarViewTabbar.appearance.weekdayTextColor = UIColor.red
                self.calendarViewTabbar.appearance.headerTitleColor = UIColor.darkGray
                self.calendarViewTabbar.appearance.eventDefaultColor = UIColor.green
                self.calendarViewTabbar.appearance.selectionColor = UIColor.blue
                self.calendarViewTabbar.appearance.headerDateFormat = "yyyy-MM";
                self.calendarViewTabbar.appearance.todayColor = UIColor.red
                self.calendarViewTabbar.appearance.borderRadius = 1.0
                self.calendarViewTabbar.appearance.headerMinimumDissolvedAlpha = 0.0
            case 2:
                self.calendarViewTabbar.appearance.weekdayTextColor = UIColor.red
                self.calendarViewTabbar.appearance.headerTitleColor = UIColor.red
                self.calendarViewTabbar.appearance.eventDefaultColor = UIColor.green
                self.calendarViewTabbar.appearance.selectionColor = UIColor.blue
                self.calendarViewTabbar.appearance.headerDateFormat = "yyyy/MM"
                self.calendarViewTabbar.appearance.todayColor = UIColor.orange
                self.calendarViewTabbar.appearance.borderRadius = 0
                self.calendarViewTabbar.appearance.headerMinimumDissolvedAlpha = 1.0
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
    }
    
    func resignFirstResp() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnBookCustomPackageTabbar(_ sender:UIButton){
        apiCallForCustomBooking()
    }
    
    @IBAction func btnEventCalendarCLickTabbar(_ sender: Any) {
        apiCallForArtistCalendar()
    }
    
    @IBAction func btnDoneForCalendarSelectionTabbar(_ sender: Any) {
        viewCaledarSelectionTabbar.isHidden=true
        
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
        viewEventDateTabbar.txtField.text = dateToDisplay
    }
    
    @IBAction func btnEventTimeCLickTabbar(_ sender: Any) {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        viewTimeSelectionTabbar.isHidden=false
    }
    
    
    @IBAction func btnDoneForTImeTabbar(_ sender: Any) {
        
        let outputFormatterM = DateFormatter()
        outputFormatterM.dateFormat = "HH:mm"
        timeSelection = outputFormatterM.string(from: timePickerTabbar.date)
        
        
        viewTimeSelectionTabbar.isHidden=true
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "hh:mm a"
        var timeSelectionM = outputFormatter.string(from: timePickerTabbar.date)
        
        outputFormatter.dateFormat = "hh"
        viewTimeHoursTabbar.txtField.text = outputFormatter.string(from: timePickerTabbar.date)
        
        outputFormatter.dateFormat = "mm"
        viewTimeMinTabbar.txtField.text = outputFormatter.string(from: timePickerTabbar.date)
        
        outputFormatter.dateFormat = "a"
        viewTimeAmPmTabbar.txtField.text = outputFormatter.string(from: timePickerTabbar.date)
        
        var hoours=1
        if timeSelectionM==nil
        {
            return
        }
        hoours =  Int(viewTimeHoursTabbar.txtField.text ?? "1")!
        if outputFormatter.string(from: timePickerTabbar.date)=="PM"
        {
            outputFormatter.dateFormat = "hh"
            if outputFormatter.string(from: timePickerTabbar.date)=="12"
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
    
    
    @IBAction func btnCurrentLocClickTabbar(_ sender: Any) {
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    func loadoutletsDelegate() {
        mapViewTabbar.delegate=self
        mapViewTabbar.setMinZoom(8, maxZoom: 22)
        LocationManager.sharedInstance.delegate=self
        txtLocTabbar.imgDropDown.isHidden = true
        txtLocTabbar.btnDropDown.isHidden = true
        
        searchBarTabbar.delegate = self
        tableDataSourceTabbar = GMSAutocompleteTableDataSource()
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "SA"
        
        tableDataSourceTabbar.autocompleteFilter = filter
        tableDataSourceTabbar.delegate = self
        
        locationsTableViewTabbar.delegate = tableDataSourceTabbar
        locationsTableViewTabbar.dataSource = tableDataSourceTabbar
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            searchBarTabbar.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    
    //MARK: - willAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        SettingUI()
        loadoutletsDelegate()
        scrollviewTabbar.scrollToView(view: self.viewNoOfMusicianTabbar, animated: false)
        clearForm()
    }
    
    
    //MARK: - didAppear
    
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
        let dressCodes = ["Saudi Formal","Casual","Formal"]
        
        var DressCodeLocalized: [String] = []
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            for item in dressCodes {
                DressCodeLocalized.append(Utils.localizedText(text: item))
            }
            viewDressCodeTabbar.dropDownDataSource =  DressCodeLocalized ?? []
        }else{
            viewDressCodeTabbar.dropDownDataSource =  dressCodes ?? []
        }
        
         viewDressCodeTabbar.holdingController = self
         viewDressCodeTabbar.dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
             guard let _ = self else { return }
             self?.DressCodeSelected = dressCodes[index]
             self?.viewDressCodeTabbar.textInputFeild.text = item
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
            viewEventPlaceTabbar.dropDownDataSource =  placesLocalized ?? []
        }else{
            viewEventPlaceTabbar.dropDownDataSource =  eventPlaces ?? []
        }
        
         
         viewEventPlaceTabbar.holdingController = self
         viewEventPlaceTabbar.dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
             guard let _ = self else { return }
             self?.preferedPlace = eventPlaces[index]
             self?.viewEventPlaceTabbar.textInputFeild.text = item
             DataManager.requestPlaceToBeSent = item
             DataManager.requestedPlaces = item
             debugPrint(item)
         }
        
        
        viewNoOfMusicianTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        viewNoOfBandMembersTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
      
        viewTypeOfInstrumentsTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text:"full squad,violin,lute"), txtLabel: "")
        
        viewNoOfInstrumentsTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        
        viewPrefferedNoOfAudienceTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text:""), txtLabel: "")

        viewEventPlaceTabbar.textInputFeild.frame = CGRect.init(x: 0, y: 0, width: viewEventPlaceTabbar.frame.width, height:viewEventPlaceTabbar.frame.height)
        viewEventPlaceTabbar.dropdownAncherImageview.contentMode = .center
       
        
        viewAdditionalTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text: "yes or no"), txtLabel: "")
        
        viewEventDateTabbar.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "", txtLabel: "")
        viewEventDateTabbar.imgDropDown.image=UIImage.init(named: "ic_event_24px")
        
        calendarViewTabbar.delegate=self
        UIManager.makeShadow(view: calendarViewTabbar)
        UIManager.makeShadow(view: viewTimeSelectionTabbar)
        calendarViewTabbar.appearance.borderRadius = 16
        calendarViewTabbar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        calendarViewTabbar.appearance.calendar.placeholderType = FSCalendarPlaceholderType.none
        
        
        viewEventTypeTabbar.imgDropDown.image=UIImage.init(named: "")
        viewEventTypeTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text:Utils.localizedText(text: "Please specify event type")), txtLabel: "")
        
        viewEventDateTabbar.imgDropDown.image=UIImage.init(named: "ic_event_24px")
        viewEventDateTabbar.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: Utils.localizedText(text: "Please select a date"), txtLabel: "")
        
        

        viewDressCodeTabbar.textInputFeild.frame = CGRect.init(x: 0, y: 0, width: viewDressCodeTabbar.frame.width, height:viewDressCodeTabbar.frame.height)
        viewDressCodeTabbar.dropdownAncherImageview.contentMode = .center
       
        
        viewTimeHoursTabbar.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "00", txtLabel: "")
        
        viewTimeHoursTabbar.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTimeHoursTabbar.frame.width, height:viewTimeHoursTabbar.frame.height)
        viewTimeHoursTabbar.imgDropDown.contentMode = .center
        viewTimeHoursTabbar.txtField.textAlignment = NSTextAlignment.center
        
        viewTimeMinTabbar.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "00", txtLabel: "")
        viewTimeMinTabbar.imgDropDown.contentMode = .center
        viewTimeMinTabbar.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTimeMinTabbar.frame.width, height:viewTimeMinTabbar.frame.height)
        viewTimeMinTabbar.txtField.textAlignment = NSTextAlignment.center
        
        viewTimeAmPmTabbar.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "--", txtLabel: "")
        viewTimeAmPmTabbar.imgDropDown.contentMode = .center
        
        viewTimeAmPmTabbar.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTimeAmPmTabbar.frame.width, height:viewTimeAmPmTabbar.frame.height)
        viewTimeAmPmTabbar.txtField.textAlignment = NSTextAlignment.center
        
        viewYouBudgetTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        viewYouBudgetTabbar.txtField.frame = CGRect.init(x: 0, y: 0, width: viewYouBudgetTabbar.frame.width, height:viewYouBudgetTabbar.frame.height)
        viewYouBudgetTabbar.imgDropDown.contentMode = .center
        viewYouBudgetTabbar.txtField.textAlignment = NSTextAlignment.center
        
        if DataManager.getLanguage=="ar"
        {
            viewEventDateTabbar.imgViewTrailingCOnst.constant = 10
            viewTimeHoursTabbar.imgViewTrailingCOnst.constant = 5
            viewTimeMinTabbar.imgViewTrailingCOnst.constant = 5
            viewTimeAmPmTabbar.imgViewTrailingCOnst.constant = 5
            viewEventPlaceTabbar.textInputFeild.textAlignment = NSTextAlignment.right
            viewDressCodeTabbar.textInputFeild.textAlignment = NSTextAlignment.right
            viewYouBudgetTabbar.txtField.textAlignment = NSTextAlignment.right
            viewPlayTImeTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "عدد الساعات", txtLabel: "")
            viewTypeOfInstrumentsTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder:"مثال : عود ، كمان ، فرقة كاملة", txtLabel: "")
        }
        else
        {
            viewEventDateTabbar.imgViewTrailingCOnst.constant = -10
            viewTimeHoursTabbar.imgViewTrailingCOnst.constant = -5
            viewTimeMinTabbar.imgViewTrailingCOnst.constant = -5
            viewTimeAmPmTabbar.imgViewTrailingCOnst.constant = -5
            viewEventPlaceTabbar.textInputFeild.textAlignment = NSTextAlignment.left
            viewDressCodeTabbar.textInputFeild.textAlignment = NSTextAlignment.left
            viewYouBudgetTabbar.txtField.textAlignment = NSTextAlignment.left
            viewPlayTImeTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "Hours", txtLabel: "")
            viewTypeOfInstrumentsTabbar.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder:"", txtLabel: "")
            
        }
        
    }
    
    @IBAction func btnCLickSIngTabbar(_ sender: Any) {
        
        if imgSingYesTabbar.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()
        {
            imgSingYesTabbar.image=UIImage.init(named: "check_box_unchecked")
            imgSingNoTabbar.image=UIImage.init(named: "check_box_checked")
        }
        else
        {
            imgSingYesTabbar.image=UIImage.init(named: "check_box_checked")
            imgSingNoTabbar.image=UIImage.init(named: "check_box_unchecked")
        }
    }
    
    
    @IBAction func btnClickEventSetupTabbar(_ sender: Any) {
        if imgIndoorTabbar.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()
        {
            imgIndoorTabbar.image=UIImage.init(named: "check_box_unchecked")
            imgOutDoorTabbar.image=UIImage.init(named: "check_box_checked")
        }
        else
        {
            imgIndoorTabbar.image=UIImage.init(named: "check_box_checked")
            imgOutDoorTabbar.image=UIImage.init(named: "check_box_unchecked")
        }
    }
}
extension CustomPackageViewcontrollerTabBar: LocationManagerDelegate
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
        self.mapViewTabbar?.animate(to: camera)
    }
    
}

extension CustomPackageViewcontrollerTabBar:UIGestureRecognizerDelegate,GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        LocationManager.sharedInstance.stopUpdatingLocation()
        LocationManager.userLocation = CLLocation.init(latitude: mapView.camera.target.latitude, longitude:  mapView.camera.target.longitude)
        LocationManager.sharedInstance.getAddressFromLocation { (Address) in
            self.txtLocTabbar.txtField.text=Address
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
        let zoom = mapViewTabbar.camera.zoom
        let camera = GMSCameraPosition.camera(withLatitude:place.coordinate.latitude,longitude:place.coordinate.longitude, zoom: zoom)
        mapViewTabbar.animate(to: camera)
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CustomPackageViewcontrollerTabBar : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 || searchBar.text == nil{
           // locationsTableView.isHidden = true
            viewLocationSearchTableViewTabbar.isHidden = true
            scrollViewHeightConstraintTabbar.constant = 1600
            self.view.layoutIfNeeded()
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }else{
            //locationsTableView.isHidden = false
            tableDataSourceTabbar.sourceTextHasChanged(searchText)
        }
            self.view.layoutIfNeeded()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("SearchBarText \(searchBar.text ?? "")")
    }
}


extension CustomPackageViewcontrollerTabBar: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        // Reload table data.
        locationsTableViewTabbar.reloadData()
        locationsTableViewTabbar.isHidden = false
        scrollViewHeightConstraintTabbar.constant = 1600+locationsTableViewTabbar.contentSize.height
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        // Reload table data.
        locationsTableViewTabbar.reloadData()
        self.scrollviewTabbar.scrollToView(view: self.mapviewTabbar, animated: true)
        locationsTableViewTabbar.isHidden = false
        scrollViewHeightConstraintTabbar.constant = 1600+locationsTableViewTabbar.contentSize.height
        viewLocationSearchTableViewTabbar.isHidden = false
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        // Do something with the selected place.
        
        let zoom = mapViewTabbar.camera.zoom
        let camera = GMSCameraPosition.camera(withLatitude:place.coordinate.latitude,longitude:place.coordinate.longitude, zoom: zoom)
        mapViewTabbar.animate(to: camera)
        locationsTableViewTabbar.isHidden = true
        scrollViewHeightConstraintTabbar.constant = 1600
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

extension CustomPackageViewcontrollerTabBar:FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance
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


extension CustomPackageViewcontrollerTabBar
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
                self.view.resignFirstResponder()
                self.view.endEditing(true)
                self.viewCaledarSelectionTabbar.isHidden=false


            }else{
                self.showAlert(title: "Error", message: errorString ?? "")
            }
            self.calendarViewTabbar.reloadData()
        }
    }
    
    func apiCallForCustomBooking() {
        
        customBooking.sharedInstance.userType = "Artist"
        customBooking.sharedInstance.bandMembersCount = Int(viewNoOfBandMembersTabbar.txtField.text ?? "0") ?? 0
        customBooking.sharedInstance.musiciansCount = Int(viewNoOfBandMembersTabbar.txtField.text ?? "0") ?? 0
        customBooking.sharedInstance.instrumentCount = Int(viewNoOfInstrumentsTabbar.txtField.text ?? "0") ?? 0
        customBooking.sharedInstance.instrumentType = viewTypeOfInstrumentsTabbar.txtField.text ?? ""
        customBooking.sharedInstance.preferredAudienceCount = Int(viewPrefferedNoOfAudienceTabbar.txtField.text ?? "0") ?? 0
        customBooking.sharedInstance.dress_code =  DressCodeSelected
        customBooking.sharedInstance.eventDate = dateSelected
        customBooking.sharedInstance.eventTime = timeSelection
        customBooking.sharedInstance.eventAddress = addressSelection
        customBooking.sharedInstance.eventPlace = preferedPlace
        customBooking.sharedInstance.eventInfo = viewAdditionalTabbar.txtField.text ?? ""
        customBooking.sharedInstance.price = Double(viewYouBudgetTabbar.txtField.text ?? "0") ?? 0
        
        let playtime = viewPlayTImeTabbar.txtField.text?.description ?? "0"
        
        customBooking.sharedInstance.playTime = Int(playtime) ?? 0
        
        customBooking.sharedInstance.goToSing = (imgSingYesTabbar.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()) ? "1" : "0"
        
        customBooking.sharedInstance.event_type = viewEventTypeTabbar.txtField.text ?? ""
        customBooking.sharedInstance.dress_setup = (imgIndoorTabbar.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()) ? "Indoor" : "Outdoor"
        
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
                    
                    self.tabBarController?.selectedIndex = (DataManager.getLanguage == Language.arabic.rawValue) ? 4 : 0
                    
                }, alertType: .alert)
            }else{
                UIManager.hideCustomActivityIndicator(controller: self)
                self.showAlert(title: "Error", message: errorString ?? "")
            }
            self.calendarViewTabbar.reloadData()
        }
    }
    
    func clearForm() {
        viewNoOfBandMembersTabbar.txtField.text = ""
        viewNoOfBandMembersTabbar.txtField.text = ""
        viewNoOfInstrumentsTabbar.txtField.text = ""
        viewTypeOfInstrumentsTabbar.txtField.text = ""
        viewPrefferedNoOfAudienceTabbar.txtField.text = ""
        viewDressCodeTabbar.textInputFeild.text = ""
        viewEventDateTabbar.txtField.text = ""
        viewTimeMinTabbar.txtField.text = "--"
        viewTimeHoursTabbar.txtField.text = "--"
        viewTimeAmPmTabbar.txtField.text = "--"
        
        viewAdditionalTabbar.txtField.text = ""
        txtLocTabbar.txtField.text = ""
        
        viewEventPlaceTabbar.textInputFeild.text = ""
        
        viewAdditionalTabbar.txtField.text = ""
        viewYouBudgetTabbar.txtField.text = ""
        
        viewPlayTImeTabbar.txtField.text = ""
        
        customBooking.sharedInstance.goToSing = (imgSingYesTabbar.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()) ? "1" : "0"
        
        viewEventTypeTabbar.txtField.text = ""
    }
    
}
