//
//  EventConrimationViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/28/21.
//

import UIKit

enum EventStatus{
    
    case approved
    case notApproved
    case Complete
    case expired
    
}

class EventConrimationViewController: UIViewController, ProtocolPayNow,CompletedBookingDelegate {
    func onContractTapped() {
        
    }
    
    @IBOutlet weak var buttonsContainer: UIStackView!
    
    @IBOutlet weak var artistPackageDetailsView:UIStackView!
    @IBOutlet weak var entertainerPackageDetailsView:UIStackView!
    @IBOutlet weak var durationEntertainerlabel:UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var artistTypeLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var dressCodeLabel: UILabel!
    @IBOutlet weak var typeOfEventLabel: UILabel!
    @IBOutlet weak var eventSetupLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var includesLabel: UILabel!
    @IBOutlet weak var typeOfInstrumentLabel: UILabel!
    @IBOutlet weak var noOfBandMembersLabel: UILabel!
    @IBOutlet weak var areTheyGoingToSingLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    
    @IBOutlet weak var locationstackview: UIStackView!
    @IBOutlet weak var locationTypeLabel: UILabel!
    
    @IBOutlet weak var eventCategoryLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var cancelBookingButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var approvalImageView: UIImageView!
    @IBOutlet weak var completeImageView: UIImageView!
    @IBOutlet weak var statusContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bookingStatusViewWIdth: NSLayoutConstraint!
    @IBOutlet weak var lblBooking: UILabel!
    
    @IBOutlet weak var OfferDetail:UILabel!
    @IBOutlet weak var durationEntertainer:UILabel!
    
    
    var paymentView : ApprovedEvent?
    var showBottomContainer : Bool = true
    var eventStatus : EventStatus? = .notApproved
    var booking : Booking?
    let viewModel = EventConfirmationViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
    }
    
    
    @IBAction func onViewArtistProfileTapped(_ sender: Any) {
        
        if booking?.userType == "Artist" || booking?.package.artist?.role_id == 2{
            if let id = booking?.package.artist?.id{
                DataManager.setPackageSelection = false
                DataManager.CategoryTypeSelection = ""
                let presentingVC = ((self.presentingViewController?.children[0] as! ArtStationTabViewController).selectedViewController as! NavBarViewController).topViewController as! EventContainerViewController
                // presentingVC.showArtistProfile(artistId: String(id))
                presentingVC.showArtistPackageProfile(artistId: String(id))
                self.dismiss(animated: true, completion: nil)
            }
        }
        else {
            if let id = booking?.package.artist?.id{
                DataManager.setPackageSelection = false
                DataManager.CategoryTypeSelection = ""
                let presentingVC = ((self.presentingViewController?.children[0] as! ArtStationTabViewController).selectedViewController as! NavBarViewController).topViewController as! EventContainerViewController
                // presentingVC.showArtistProfile(artistId: String(id))
                presentingVC.showEntertainerPackageProfile(entertainerID: String(id))
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupUI(){
        artistImageView.layer.cornerRadius = 10
        artistImageView.layer.masksToBounds = true
        setupLableViews()
        lblBooking.text = Utils.localizedText(text: "Booking#") + String(booking?.id ?? 0)
        viewProfileButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor(named: "tabbar_item_tint")!, borderRadius: 5, borderColor: UIColor(named: "tabbar_item_tint")!, borderWidth: 2)
        
        backButton.configureButtonUI(backgroundColor: UIColor.white, fontColor: UIColor(named: "tabbar_item_tint")!, borderRadius: backButton.frame.height/2, borderColor: UIColor(named: "tabbar_item_tint")!, borderWidth: 2)
        
        cancelBookingButton.configureButtonUI(backgroundColor: UIColor(named: "cancel_booking_color")!, fontColor: UIColor.white, borderRadius: 17, borderColor: nil, borderWidth: 0)
        rescheduleButton.configureButtonUI(backgroundColor: UIColor(named: "reschedule_button_color")!, fontColor: UIColor.white, borderRadius: 17, borderColor: nil, borderWidth: 0)
        
        
        switch eventStatus {
            
        case .approved:
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let myString = formatter.string(from: Date())
            let duration = findDateDiff(time1Str: myString, time2Str: booking?.paid_till ?? "")
            statusContainerHeightConstraint.constant = 160
            paymentView = ApprovedEvent(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: statusContainerHeightConstraint.constant))
            statusContainerView.addSubview(paymentView!)
            
            paymentView!.delegatePayNow = self
            paymentView?.duration = TimeInterval(duration)
            paymentImageView.isHidden = false
            if duration <= 0{
                viewModel.expireBookingWithId(bookingId: booking!.id)
            }
        case .notApproved:
            statusContainerHeightConstraint.constant = 75
            let waitingApprovalView = WaitingForApproval(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: statusContainerHeightConstraint.constant))
            statusContainerView.addSubview(waitingApprovalView)
            approvalImageView.isHidden = false
        case .Complete:
            statusContainerHeightConstraint.constant = 201
            let completedView = CompletedBooking(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: statusContainerHeightConstraint.constant))
            statusContainerView.addSubview(completedView)
            completedView.delegate = self
            buttonsContainer.isHidden = !showBottomContainer
            completeImageView.isHidden = false
        case .expired:
            buttonsContainer.isHidden = true
            statusContainerHeightConstraint.constant = 75
            let waitingApprovalView = WaitingForApproval(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: statusContainerHeightConstraint.constant))
            statusContainerView.addSubview(waitingApprovalView)
            waitingApprovalView.messageView.text = Utils.localizedText(text: "Your booking has expired")
            waitingApprovalView.messageView.textColor = UIColor.red
            
        case .none:
            break
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        paymentView?.timer?.invalidate()
    }
    
    func btnPayNowClick() {
        
        let viewController = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.PayFromPayFortViewControllerId, viewController: PayFromPayFortViewController.self)
        viewController.booking = booking
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func setupLableViews(){
        
        if let booking = booking{
            
            if booking.userType == "Artist" || booking.package.artist?.role_id == 2 {
                artistPackageDetailsView.isHidden = false
                entertainerPackageDetailsView.isHidden = true
                self.view.layoutIfNeeded()
            }else if booking.userType == "Entertainer" || booking.package.artist?.role_id == 3{
                artistPackageDetailsView.isHidden = true
                entertainerPackageDetailsView.isHidden = false
                self.view.layoutIfNeeded()
            }
            
            areTheyGoingToSingLabel.text = booking.package.goToSing == "0" ? Utils.localizedText(text: "No") : Utils.localizedText(text: "Yes")
            
            noOfBandMembersLabel.text = Utils.localizedArabicNumber(stringV:String(booking.package.bandMembersCount ?? 0))
            
            
            if booking.package.isRange == "0"{
                
                let playtime = booking.package.playTime ?? 0
                
                if playtime > 1{
                    self.durationLabel.text = Utils.localizedArabicNumber(stringV:booking.package.playTime?.clean ?? "0") + " " + Utils.localizedText(text: booking.package.timeType ?? "")
                    self.durationEntertainer.text = Utils.localizedArabicNumber(stringV:booking.package.playTime?.clean ?? "0") + " " + Utils.localizedText(text: booking.package.timeType ?? "")
                }
                else{
                    self.durationLabel.text = Utils.localizedArabicNumber(stringV:String(booking.package.playTime?.clean ?? "0")) + " " + Utils.localizedText(text: String((booking.package.timeType ?? "").dropLast()))
                    self.durationEntertainer.text = Utils.localizedArabicNumber(stringV:String(booking.package.playTime?.clean ?? "0")) + " " + Utils.localizedText(text: String((booking.package.timeType ?? "").dropLast()))
                }
            }else if booking.package.isRange == "1"{
                self.durationLabel.text = Utils.localizedArabicNumber(stringV:String(booking.package.playTimeFrom ?? 0)) + " - "+Utils.localizedArabicNumber(stringV:String(booking.package.playTimeTo ?? 0)) + " " + Utils.localizedText(text: booking.package.timeType ?? "")
                self.durationEntertainer.text = Utils.localizedArabicNumber(stringV:String(booking.package.playTimeFrom ?? 0)) + " - "+Utils.localizedArabicNumber(stringV:String(booking.package.playTimeTo ?? 0)) + " " + Utils.localizedText(text: booking.package.timeType ?? "")
            }
            else if booking.package.isRange == "2" {
                let select_hour = booking.hours_selected ?? 0
                self.durationLabel.text = Utils.localizedArabicNumber(stringV:"\(select_hour)") + " " + Utils.localizedText(text: booking.package.timeType ?? "")
                self.durationEntertainer.text = Utils.localizedArabicNumber(stringV:"\(select_hour)") + " " + Utils.localizedText(text: booking.package.timeType ?? "")
            }
            
            
            
            eventSetupLabel.text = Utils.localizedText(text: booking.eventSetup ?? "")
            typeOfEventLabel.text = booking.eventType
            dressCodeLabel.text = Utils.localizedText(text:booking.dressCode)
            
            var timePostFix = "PM"
            var hour = Int(booking.startTime.prefix(2) ?? "12")
            if hour! <= 12{
                timePostFix = "AM"
            }else{
                hour! -= 12
            }
            var dateLabelString = (Utils.changeDateFormatTo(from: "yyyy-MM-dd", to: "dd-MMM", date: booking.startDate ?? "") + ", " + String(hour!) + (booking.startTime.dropFirst(2).dropLast(3) ?? ""))
            dateLabelString += " " + timePostFix
            
            eventDateLabel.text = dateLabelString
            
            
            if booking.userType == "Entertainer" || booking.package.artist?.role_id == 3{
                self.locationstackview.isHidden = true
                self.durationEntertainerlabel.isHidden = false
                self.view.layoutIfNeeded()
            }else if booking.userType == "Artist" || booking.package.artist?.role_id == 2{
                self.view.layoutIfNeeded()
                self.locationstackview.isHidden = false
                self.durationEntertainerlabel.isHidden = true
                locationTypeLabel.text = Utils.localizedText(text: booking.requested_place ?? "")
                self.view.layoutIfNeeded()
            }
            self.view.layoutSubviews()
            
            eventLocationLabel.text = booking.address
            
            if DataManager.getLanguage == Language.arabic.rawValue{
                includesLabel.text = booking.package.addInfo_ar
                artistNameLabel.text = booking.package.artist?.artistInfo?[0].stageName_ar
                artistTypeLabel.text = Utils.localizedText(text: booking.package.artist?.categories?.name_ar ?? "")
                eventCategoryLabel.text = booking.package.artist?.categories?.name_ar
                typeOfInstrumentLabel.text = booking.package.instrumentType_ar?.replacingOccurrences(of: ",", with:  "|")
                eventPriceLabel.text =  (booking.amount.clean ?? "0") +  Utils.localizedText(text: "SAR ")
                eventPriceLabel.font = UIFont(name: "Almarai-Bold", size: 16)
                OfferDetail.text = booking.package.offer_ar ?? "test entertainer"
                
            }else{
                eventPriceLabel.text = Utils.localizedText(text: "SAR ") + (booking.amount.clean ?? "0")
                
                includesLabel.text = booking.package.addInfo
                artistTypeLabel.text = booking.package.artist?.categories?.name
                artistNameLabel.text = booking.package.artist?.artistInfo?[0].stageName
                eventCategoryLabel.text = booking.package.artist?.categories?.name
                typeOfInstrumentLabel.text = booking.package.instrumentType?.replacingOccurrences(of: ",", with:  "|")
                OfferDetail.text = booking.package.offer ?? "test entertainer"
            }
            
            let imgarray = booking.package.artist?.artistImages
            if !(imgarray?.isEmpty ?? true){
                Utils.setImageTo(imageView: artistImageView, imageName: (imgarray?[0].coverImage ?? "picture"), placeholderImage: "picture")
            }
            artistImageView.layer.cornerRadius = 10
            artistImageView.layer.masksToBounds = true
            artistImageView.contentMode = .scaleAspectFill
            
            
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
    @IBAction func onBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelBookingTapped(_ sender: Any) {
        let refreshAlert = UIAlertController(title: Utils.localizedText(text: "Alert"), message: Utils.localizedText(text: "Do you want to cancel?"), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: Utils.localizedText(text: "Yes"), style: .default, handler: { (action: UIAlertAction!) in
            self.cancelBooking()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: Utils.localizedText(text: "No"), style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func cancelBooking(){
        
        if let id = booking?.id{
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            viewModel.cancelBooking(withId: id, onCompletionHandler:
                                        {
                success,message in
                UIManager.hideCustomActivityIndicator(controller: self)
                if success{
                    self.showAlert(title: "Success", message: message ?? "",onOkTapped: {
                        self.dismiss(animated: true, completion: nil)
                    },alertType: .alert)
                    
                }
                else{
                    self.showAlert(title: "Error", message: message ?? "")
                }
            }
            )
            
        }
    }
    
    
    @IBAction func onRescheduleBookingTapped(_ sender: Any) {
        
        
        if let booking = booking{
            let presentingVC = ((self.presentingViewController?.children[0] as! ArtStationTabViewController).selectedViewController as! NavBarViewController).topViewController as! EventContainerViewController
            presentingVC.showRescheduleScreen(booking: booking)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    func onInvoiceTapped() {
        if let bookingId = booking?.id{
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            viewModel.getInvoice(urlType: "read", withId: bookingId, onCompletionCallback: {
                success,data in
                UIManager.hideCustomActivityIndicator(controller: self)
                if success{
                    let invoiceViewController = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: "InvoiceControllerId", viewController: PdfViewController.self)
                    
                    let dat = data
                    invoiceViewController.invoiceUrl = data
                    
                    self.navigationController?.pushViewController(invoiceViewController, animated: true)
                }else{
                    self.showAlert(title: "Error", message: data ?? "" )
                }
            })
        }
    }
    
    func findDateDiff(time1Str: String, time2Str: String) -> Int {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let time2 = timeformatter.date(from: time2Str) else { return -1 }
        guard let time1 = timeformatter.date(from: time1Str) else {return -2 }
        
        //You can directly use from here if you have two dates
        
        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        return intervalInt
    }
    
    func showAlertwithMessage(string: String) {
        self.showAlert(title:  "Alert", message: string,alertType: .alert)
        buttonsContainer.isHidden = true
        for view in statusContainerView.subviews{
            view.removeFromSuperview()
        }
        viewModel.expireBookingWithId(bookingId: booking!.id)
        
        statusContainerHeightConstraint.constant = 75
        let waitingApprovalView = WaitingForApproval(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: statusContainerHeightConstraint.constant))
        statusContainerView.addSubview(waitingApprovalView)
        waitingApprovalView.messageView.text = Utils.localizedText(text: "Your booking has expired")
        waitingApprovalView.messageView.textColor = UIColor.red
        buttonsContainer.isHidden = true
    }
    
    @IBAction func onLocationTapped(_ sender: Any) {
        
        if let booking = booking{
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=" + String (booking.lat ?? 0.0) + String(booking.lng ?? 0.0)+"&zoom=14&views=traffic&q=" + String(booking.lat ?? 0.0) + "," + String(booking.lng ?? 0.9))!, options: [:], completionHandler: nil)
            } else {
                print("Can't use comgooglemaps://")
            }
        }
        
        
        
    }
    
}
