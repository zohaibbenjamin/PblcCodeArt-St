//
//  DressCalendarViewController.swift
//  ArtStation
//
//  Created by Apple on 24/06/2021.
//

import UIKit
import FSCalendar

class DressCalendarViewController: UIViewController {
    
    var isOpenedToRescheduleEvent : Bool = false
    var bookingToReschedule : Booking?
    var selectedLongitudeToReschedule : Double?
    var selectedLatitudeToReschedule : Double?
    var newAddress : String?
    var previousLocationLongitude: Double?
    var previousLocationLatitude: Double?
    
    @IBOutlet weak var viewCaledarSelection: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var viewEventDate: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTImeHours: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTImeMins: InputTextfieldWithDropDown!
    @IBOutlet weak var viewTimeAm: InputTextfieldWithDropDown!
    @IBOutlet weak var imgCasual: UIImageView!
    @IBOutlet weak var imgFormal: UIImageView!
    @IBOutlet weak var imgSaudi: UIImageView!
    @IBOutlet weak var imgIndoor: UIImageView!
    @IBOutlet weak var imgOutDoor: UIImageView!
    @IBOutlet weak var viewTimeSelection: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var viewTypEvent: InputTextfieldWithDropDown!
    
    @IBOutlet weak var preferednoofAudienceTxtfeild: InputTextfieldWithDropDown!
    @IBOutlet weak var budgetTxtfeild: InputTextfieldWithDropDown!
    //calendar outlets/variables
    //MARK:- Data
    let onBoardingCollectionViewCellIdentifier = "onboarding_feature_cell"
    var currentItem = 0
    var dateSelectable = [String]()
    var dateUnavailable = [String]()
    var dateUnSelectable = [String]()
    var allowableMonthsForBooking = 6
    var dateSelected = ""
    var timeSelection = ""
    var eventSetupSelection = "Indoor"
    var eventDressCode = "Saudi Formal"
    
    //calendar outlet
    @IBOutlet weak var viewCalendar: UIView!
    var viewModel = DressCalendarViewModel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //    apiCallForArtistCalendar()
        setupUI()
        
        if isOpenedToRescheduleEvent{
            setupUIToReschedule()
        }
        
        if customBookingV2.sharedInstance.userType == "Entertainer"{
            self.preferednoofAudienceTxtfeild.isHidden = true
        }
    }
    
    func setupUIToReschedule(){
        
        viewEventDate.txtField.text = bookingToReschedule?.startDate ?? ""
        dateSelected = bookingToReschedule?.startDate ?? ""
        viewTypEvent.txtField.text = bookingToReschedule?.eventType ?? ""
        
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        
        let time = inputFormatter.date(from: bookingToReschedule?.startTime ?? "") ?? Date()
        timePicker.date = time
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "hh:mm a"
        
        outputFormatter.dateFormat = "hh"
        viewTImeHours.txtField.text = outputFormatter.string(from:time)
        
        outputFormatter.dateFormat = "mm"
        viewTImeMins.txtField.text = outputFormatter.string(from: time)
        
        outputFormatter.dateFormat = "a"
        viewTimeAm.txtField.text = outputFormatter.string(from: time)
        
        
        timeSelection = bookingToReschedule?.startTime  ?? ""
        
        eventDressCode = bookingToReschedule?.dressCode ?? ""
        switch bookingToReschedule?.dressCode ?? ""
        {
            
        case "casual":
            imgCasual.image=UIImage.init(named: "check_box_checked")
            imgFormal.image=UIImage.init(named: "check_box_unchecked")
            imgSaudi.image=UIImage.init(named: "check_box_unchecked")
        case "formal":
            imgCasual.image=UIImage.init(named: "check_box_unchecked")
            imgFormal.image=UIImage.init(named: "check_box_checked")
            imgSaudi.image=UIImage.init(named: "check_box_unchecked")
        case "saudi Formal":
            imgCasual.image=UIImage.init(named: "check_box_unchecked")
            imgFormal.image=UIImage.init(named: "check_box_unchecked")
            imgSaudi.image=UIImage.init(named: "check_box_unchecked")
        default:
            break
            
        }
        
        switch bookingToReschedule?.eventSetup{
        case "Indoor":
            imgIndoor.image=UIImage.init(named: "check_box_checked")
            imgOutDoor.image=UIImage.init(named: "check_box_unchecked")
            eventSetupSelection = "Indoor"
        case "Outdoor":
            imgIndoor.image=UIImage.init(named: "check_box_unchecked")
            imgOutDoor.image=UIImage.init(named: "check_box_checked")
            eventSetupSelection = "Outdoor"
        default:
            break
            
        }
    }
    
    func setupUI()
    {
        calendarView.delegate=self
        UIManager.makeShadow(view: viewCalendar)
        UIManager.makeShadow(view: viewTimeSelection)
        calendarView.appearance.borderRadius = 16
        calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        calendarView.appearance.calendar.placeholderType = FSCalendarPlaceholderType.none
        
        viewTypEvent.imgDropDown.image=UIImage.init(named: "")
        viewTypEvent.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text: "Please specify event type"), txtLabel: "")
        
        viewEventDate.imgDropDown.image=UIImage.init(named: "ic_event_24px")
        viewEventDate.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: Utils.localizedText(text: "Please select a date"), txtLabel: "")
        
        viewTImeHours.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "00", txtLabel: "")
        
        viewTImeHours.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTImeHours.frame.width, height:viewTImeHours.frame.height)
        viewTImeHours.imgDropDown.contentMode = .center
        viewTImeHours.txtField.textAlignment = NSTextAlignment.center
        
        
        preferednoofAudienceTxtfeild.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        
        preferednoofAudienceTxtfeild.txtField.frame = CGRect.init(x: 0, y: 0, width: preferednoofAudienceTxtfeild.frame.width, height:preferednoofAudienceTxtfeild.frame.height)
        preferednoofAudienceTxtfeild.imgDropDown.contentMode = .center
        
        budgetTxtfeild.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: "", txtLabel: "")
        
        budgetTxtfeild.txtField.frame = CGRect.init(x: 0, y: 0, width: budgetTxtfeild.frame.width, height:budgetTxtfeild.frame.height)
        budgetTxtfeild.imgDropDown.contentMode = .center
       
        
        viewTImeMins.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "00", txtLabel: "")
        viewTImeMins.imgDropDown.contentMode = .center
        
        viewTImeMins.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTImeMins.frame.width, height:viewTImeMins.frame.height)
        viewTImeMins.txtField.textAlignment = NSTextAlignment.center
        viewTimeAm.setupCurrentScheme(isOnlyTextfield: false, txtForPlaceHolder: "--", txtLabel: "")
        viewTimeAm.imgDropDown.contentMode = .center
        
        viewTimeAm.txtField.frame = CGRect.init(x: 0, y: 0, width: viewTimeAm.frame.width, height:viewTimeAm.frame.height)
        viewTimeAm.txtField.textAlignment = NSTextAlignment.center
        
        if DataManager.getLanguage=="ar"
        {
            viewEventDate.imgViewTrailingCOnst.constant = 10
            viewTImeHours.imgViewTrailingCOnst.constant = 5
            viewTImeMins.imgViewTrailingCOnst.constant = 5
            viewTimeAm.imgViewTrailingCOnst.constant = 5
            preferednoofAudienceTxtfeild.txtField.textAlignment = NSTextAlignment.right
            budgetTxtfeild.txtField.textAlignment = NSTextAlignment.right
            
        }
        else
        {
            viewEventDate.imgViewTrailingCOnst.constant = -10
            viewTImeHours.imgViewTrailingCOnst.constant = -5
            viewTImeMins.imgViewTrailingCOnst.constant = -5
            viewTimeAm.imgViewTrailingCOnst.constant = -5
            preferednoofAudienceTxtfeild.txtField.textAlignment = NSTextAlignment.left
            budgetTxtfeild.txtField.textAlignment = NSTextAlignment.left
        }
        
    }
    
    @IBAction func btnEventDressCodeCLick(_ sender: UIButton) {
        
        if sender.tag==1
        {
            imgCasual.image=UIImage.init(named: "check_box_checked")
            imgFormal.image=UIImage.init(named: "check_box_unchecked")
            imgSaudi.image=UIImage.init(named: "check_box_unchecked")
            eventDressCode = "Casual"
        }
        else if sender.tag==2
        {
            imgCasual.image=UIImage.init(named: "check_box_unchecked")
            imgFormal.image=UIImage.init(named: "check_box_checked")
            imgSaudi.image=UIImage.init(named: "check_box_unchecked")
            eventDressCode = "Formal"
        }
        else if sender.tag==3
        {
            imgCasual.image=UIImage.init(named: "check_box_unchecked")
            imgFormal.image=UIImage.init(named: "check_box_unchecked")
            imgSaudi.image=UIImage.init(named: "check_box_checked")
            eventDressCode = "Saudi Formal"
        }
        else
        {
            imgCasual.image=UIImage.init(named: "check_box_unchecked")
            imgFormal.image=UIImage.init(named: "check_box_unchecked")
            imgSaudi.image=UIImage.init(named: "check_box_unchecked")
        }
        
    }
    
    
    @IBAction func btnEventSetup(_ sender: UIButton)
    {
        if sender.tag==1
        {
            
            imgIndoor.image=UIImage.init(named: "check_box_checked")
            imgOutDoor.image=UIImage.init(named: "check_box_unchecked")
            eventSetupSelection = "Indoor"
        }
        else if sender.tag==2
        {
            imgIndoor.image=UIImage.init(named: "check_box_unchecked")
            imgOutDoor.image=UIImage.init(named: "check_box_checked")
            eventSetupSelection = "Outdoor"
            
        }
        else
        {
            imgIndoor.image=UIImage.init(named: "check_box_unchecked")
            imgOutDoor.image=UIImage.init(named: "check_box_unchecked")
            
        }
    }
    
    
    @IBAction func btnEventCalendarCLick(_ sender: Any) {
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
        viewTimeSelection.isHidden=false
        self.view.endEditing(true)
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
        viewTImeHours.txtField.text = outputFormatter.string(from: timePicker.date)
        
        outputFormatter.dateFormat = "mm"
        viewTImeMins.txtField.text = outputFormatter.string(from: timePicker.date)
        
        outputFormatter.dateFormat = "a"
        viewTimeAm.txtField.text = outputFormatter.string(from: timePicker.date)
        
        var hoours=1
        if timeSelectionM==nil
        {
            return
        }
        hoours =  Int(viewTImeHours.txtField.text ?? "1")!
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
    
    
    @IBAction func btnContinueCLickForBooking(_ sender: Any) {
        if dateSelected.count<1
        {
            self.showAlert(title: "Error", message: "Please select a date first")
            return
        }
        if timeSelection.count<1
        {
            self.showAlert(title: "Error", message: "Please select a time first")
            return
        }
        if viewTypEvent.txtField.text?.count ?? 0 < 1
        {
            self.showAlert(title: "Error", message: "Please specify event type")
            return
        }
    
        if ((customBookingV2.sharedInstance.userType == "Artist") && (preferednoofAudienceTxtfeild.txtField.text?.count ?? 0 < 1))
        {
            self.showAlert(title: "Error", message: "Please specify number of audience")
            return
        }
        
        if budgetTxtfeild.txtField.text?.count ?? 0 < 1
        {
            self.showAlert(title: "Error", message: "Please specify your budget")
            return
        }
        
        
        if isOpenedToRescheduleEvent{
            
            let rescheduleBookingRequest = RescheduleEventApiRequest(startDate: dateSelected, startTime: timeSelection, latitude: selectedLatitudeToReschedule!  , longitude: selectedLongitudeToReschedule!, address: newAddress ?? "")
            debugPrint(dateSelected,timeSelection + "  Rescehduled Booking")
            viewModel.rescheduleBooking(bookingId: bookingToReschedule?.id ?? -1, apiRequest: rescheduleBookingRequest, onCompletionCallback: {
                success,message in
                if success{
                    self.showAlert(title: "Success", message: message ?? "",onOkTapped: {
                        
                        let homepageViewController = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.confirmViewControllerId, viewController: ConfirmationViewController.self)
                        
                        if let keyWindow = UIWindow.key {
                            keyWindow.rootViewController = homepageViewController
                        }
                        
                    },alertType: .alert)
                }else{
                    self.showAlert(title: "Error", message: message ?? "")
                }
            })
        }else{
            customBookingV2.sharedInstance.event_type = viewTypEvent.txtField.text!
            customBookingV2.sharedInstance.start_date = dateSelected
            customBookingV2.sharedInstance.start_time = timeSelection
            customBookingV2.sharedInstance.dress_code = eventDressCode
            customBookingV2.sharedInstance.event_setup = eventSetupSelection
            customBookingV2.sharedInstance.audienceCount = Int(self.preferednoofAudienceTxtfeild.txtField.text ?? "0") ?? 0
            customBookingV2.sharedInstance.eventPrice = Double(self.budgetTxtfeild.txtField.text ?? "0") ?? 0.0
            
            
            apiCallFBookNewArtist()
        }
    }
    
    
}



extension DressCalendarViewController:FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance
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



open class LunarFormatter: NSObject {
    
    fileprivate let chineseCalendar = Calendar(identifier: .chinese)
    fileprivate let formatter = DateFormatter()
    fileprivate let lunarDays = ["初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二一","二二","二三","二四","二五","二六","二七","二八","二九","三十"]
    fileprivate let lunarMonths = ["正月","二月","三月","四月","五月","六月","七月","八月","九月","十月","冬月","腊月"]
    
    
    override init() {
        self.formatter.calendar = self.chineseCalendar
        self.formatter.dateFormat = "M"
    }
    
    open func string(from date: Date) -> String {
        let day = self.chineseCalendar.component(.day, from: date)
        if day != 1 {
            return self.lunarDays[day-2]
        }
        // First day of month
        let monthString = self.formatter.string(from: date)
        if self.chineseCalendar.veryShortMonthSymbols.contains(monthString) {
            if let month = Int(monthString) {
                return self.lunarMonths[month-1]
            }
            return ""
        }
        // Leap month
        let month = self.chineseCalendar.component(.month, from: date)
        return "闰" + self.lunarMonths[month-1]
    }
    
    
    
}



extension DressCalendarViewController
{
    func apiCallForArtistCalendar() {
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
        viewModel.getArtistCalendarData(params: ["month":allowableMonthsForBooking.description,"artist_id":customBookingV2.sharedInstance.artist_id.description]){
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
                self.view.endEditing(true)
                
            }else{
                self.showAlert(title: "Error", message: errorString ?? "")
            }
            self.calendarView.reloadData()
        }
    }
    
    func apiCallFBookNewArtist() {
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
        viewModel.BookNewArtistV2(param:[String:Any]()){
            success,errorString in
            UIManager.hideCustomActivityIndicator(controller: self)
            self.dateUnSelectable = [String]()
            if success{
                
                let homepageViewController = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.confirmViewControllerId, viewController: ConfirmationViewController.self)
                
                if let keyWindow = UIWindow.key {
                    keyWindow.rootViewController = homepageViewController
                }
                
            }else{
                self.showAlert(title: "Error", message: errorString ?? "")
            }
            self.calendarView.reloadData()
        }
    }
    
    
}
