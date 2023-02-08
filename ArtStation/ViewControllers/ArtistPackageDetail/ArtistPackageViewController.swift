//
//  ArtistPackageViewController.swift
//  ArtStation
//
//  Created by Apple on 07/06/2021.
//

import UIKit
import Cosmos
import LiveChat
import DropDown
import SwiftUI
import AVFoundation

class ArtistPackageViewController:  UIViewController {
    
    @IBOutlet weak var viewGenre: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    //MARK: - IB Refrences
    
    @IBOutlet weak var specialitiesCollectionView:UICollectionView!
    @IBOutlet weak var ProfileCardViewHeightConstraints:NSLayoutConstraint!
    @IBOutlet weak var specialitiesCollectionViewHeightConstraints:NSLayoutConstraint!
    @IBOutlet weak var playtimeDropdownHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var priceInfoViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var playtimStackView:UIStackView!
    @IBOutlet weak var doyoureventneedSpeaker: InputTextfieldWithDropDown!
    
    
    @IBOutlet weak var imgSingNo: UIImageView!
    @IBOutlet weak var imgSingYes: UIImageView!
    
    @IBOutlet weak var btnTooltipPrice:UIButton!
    
    
    enum CollectionViewCellIdentifier: String{
        case imageCellIdentifier = "imageCellIdentifier"
        case videoCellIdentifier = "videoCellIdentifier"
        case specialitiesCellIdentifer = "specialityCollectionViewCell"
    }
    
    let packageCollectionViewCellIdentifier = "ArtistPackageCollectionViewCell"
    //MARK: - Data
    let packageTableCellIdentifier = "ArtistPackageTableViewCell"
    
    var specialitiesDataSource: [String]?{
        didSet{
            self.specialitiesCollectionView.dataSource = self
            self.specialitiesCollectionView.delegate = self
            self.specialitiesCollectionView.contentInsetAdjustmentBehavior = .always
            self.specialitiesCollectionView.reloadData()
            
            
            let specialitiesCollectionHeight = specialitiesCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            self.specialitiesCollectionViewHeightConstraints.constant = specialitiesCollectionHeight
            
            if specialitiesCollectionHeight > 40{
                self.ProfileCardViewHeightConstraints.constant = 450 + specialitiesCollectionHeight
            }
            self.scrollview.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    @IBOutlet weak var artistDetailsCard: PackageProfileCard!
    
    //MARK: - packageOutlets
    @IBOutlet weak var numberOfBandMember: InputTextfieldWithDropDown!
    @IBOutlet weak var typeOfInstruments: InputTextfieldWithDropDown!
    @IBOutlet weak var playTime: UILabel!
    
    //MARK: - ToolTipview Outlet
    var isShownpriceTooltipview:Bool = false
    
    
    // MARK: - IB actions
    @IBAction func createCustomPackage(_ sender:UIButton){
        if DataManager.getUserLog == "guest"
        {
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
        }
        else{
            let viewController = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.artistPackagesCustomPackageFormViewControllerId, viewController: ArtistCustomPackViewController.self)
            viewController.artistID = self.artistId
            viewController.isTabBarCustomPackagViewController = false
            //viewController.artistData = self.artistData
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func doyouSingYesNo(_ sender:Any){
        debugPrint("clickkkkkkkkkkk")
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
    
    @IBAction func btntooltipforPrice(_ sender:Any){
        if isShownpriceTooltipview{
            withAnimation(.easeInOut(duration: 1)) {
                self.priceInfoViewHieghtConstraint.constant = 0
                
            }
            isShownpriceTooltipview = false
        }else{
            withAnimation(.easeInOut(duration: 1)) {
                self.priceInfoViewHieghtConstraint.constant = (DataManager.getLanguage == "ar") ? 85 : 90
            }
            isShownpriceTooltipview = true
        }
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        self.scrollview.reloadInputViews()
    }
    
    var selectedPlace = ""
    var selectedPlaytime = ""
    //MARK: - Variable brought from artist profile
    @IBOutlet weak var bioGraphyHeaderView: UIView!
    @IBOutlet weak var artistBiography: UILabel!
    
    @IBOutlet weak var viewallImagesBtn:UIButton!
    @IBOutlet weak var viewallVideoBtn:UIButton!
    
    var artistId : String?
    var imagesArray : [String] = []
    var videosArray : [String] = []
    var photoIndex:Int = 0
    var totalEventPrice:Double = 0
    var selectPlaytime:Int = 0
    
    @IBOutlet weak var preferPlaces: FormDropDownPackage!
    @IBOutlet weak var playtimeDropDown: FormDropDownPackage!
    
    
    var showcloseChatOptionsState:Bool = false
    
    @IBOutlet weak var lblPrice: UILabel!
    var packageInfo : Package?
    var artistInfo : ArtistInfo?
    var artistInfo1 : ArtistInfo?
    var artistData : GetArtistDetailApiResponse?
    var artistImage : ArtistImage?
    var artistTalent : Artist_Talent?
    var artistPrice : String?
    var talent : Artist_Talent?
    var artist_intro: [Artist_Intro]?
    @IBOutlet weak var lblGenre: UILabel!
    
    let viewModel = ArtistProfileViewModel()
    
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        scrollview.delegate = self
        DataManager.requestedPlaces = ""
    }
    
    
    
    //MARK: - Sets up initial UI
    func setupUI(){
        
        preferPlaces.holdingController = self
        preferPlaces.dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            self?.selectedPlace = item
            self?.preferPlaces.textInputFeild.text = item
            DataManager.requestPlaceToBeSent = item
            DataManager.requestedPlaces = item
            debugPrint(item)
        }
        
        playtimeDropDown.holdingController = self
        self.viewallImagesBtn.titleLabel?.font = UIFont.init(name: "Almarai-Bold", size: 14)
        self.viewallVideoBtn.titleLabel?.font = UIFont.init(name: "Almarai-Bold", size: 14)
        //self.loadPackageData()
        
        
        doyoureventneedSpeaker.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text: "yes or no"), txtLabel: "")
        doyoureventneedSpeaker.txtField.frame = CGRect.init(x: 0, y: 0, width: doyoureventneedSpeaker.frame.width, height:doyoureventneedSpeaker.frame.height)
        doyoureventneedSpeaker.imgDropDown.contentMode = .center
        
        typeOfInstruments.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text: ""), txtLabel: "")
        typeOfInstruments.txtField.frame = CGRect.init(x: 0, y: 0, width: typeOfInstruments.frame.width, height:typeOfInstruments.frame.height)
        typeOfInstruments.imgDropDown.contentMode = .center
        
        numberOfBandMember.setupCurrentScheme(isOnlyTextfield: true, txtForPlaceHolder: Utils.localizedText(text: ""), txtLabel: "")
        numberOfBandMember.txtField.frame = CGRect.init(x: 0, y: 0, width: numberOfBandMember.frame.width, height:numberOfBandMember.frame.height)
        numberOfBandMember.imgDropDown.contentMode = .center
        
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            doyoureventneedSpeaker.txtField.textAlignment = NSTextAlignment.right
            numberOfBandMember.txtField.textAlignment = NSTextAlignment.right
            typeOfInstruments.txtField.textAlignment = NSTextAlignment.right
        }else{
            doyoureventneedSpeaker.txtField.textAlignment = NSTextAlignment.left
            numberOfBandMember.txtField.textAlignment = NSTextAlignment.left
            typeOfInstruments.txtField.textAlignment = NSTextAlignment.left
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bioGraphyHeaderView.setGradientBackground(colorStart:UIColor(red: 255, green: 241, blue: 201, alpha: 1), colorEnd: UIColor(red: 255, green: 228, blue: 201, alpha: 0))
        getArtistProfileData()
        self.view.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.artistDetailsCard.videoPlayerView.isPlaying = false
        if self.artistDetailsCard.videoPlayerView.player != nil{
            self.artistDetailsCard.videoPlayerView.player?.replaceCurrentItem(with: nil)
            self.artistDetailsCard.videoPlayerView.player = nil
        }
        self.view.isHidden = true
    }
    
    //MARK: - get ArtistProfile  API EndPoint: getPackagesByArtist
    func getArtistProfileData(){
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "Loading")
        let request = GetArtistDetailApiRequest(artistId: artistId ?? "-1", type: DataManager.CategoryTypeSelection)
        viewModel.getDataForArtistProfile(request: request, onCompletionHandler: {
            success,message in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                self.artistData = self.viewModel.artistData
                self.artistInfo = self.viewModel.artistData?.getArtistInfo()
                self.artist_intro = self.artistData?.artist_intro
                self.talent = self.artistData?.artist_talent?[0]
                self.updateArtistInfo()
                self.loadImages()
                self.loadVideos()
                self.loadPackageData()
                
            }else{
                
                self.showAlert(title: "Error", message: message ?? "")
                
            }
        })
    }
    
    //MARK: - view all images on gridviewViewController
    @IBAction func viewAllImages(_ sender: UIButton){
        
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: "ImagesGridControllerId", viewController: ImagesGridViewController.self)
        
        
        viewController.contentType = .images
        viewController.dataSource = imagesArray
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //MARK: - view all videos on gridviewViewController
    @IBAction func viewAllVideos(_ sender:UIButton){
        
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: "ImagesGridControllerId", viewController: ImagesGridViewController.self)
        
        
        viewController.dataSource = self.videosArray
        viewController.contentType = .videos
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - load images on imageCollection
    func loadImages(){
        if let artistId = viewModel.artistData?.id{
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            
            let viewModel = ArtistProfileViewModel()
            viewModel.getArtistImages(artistId: artistId, onCompletionHandler: {
                success,errorMessage,imagesData in
                UIManager.hideCustomActivityIndicator(controller: self)
                if success{
                    if imagesData?.count == 0{
                        self.showAlert(title: "Error", message: "No images found for this artist")
                    }else{
                        self.imagesArray.removeAll()
                        for index in 0..<(imagesData?.count ?? 0){
                            self.imagesArray.append(imagesData?[index].fileURL
                                                    ?? "")
                            self.imageCollectionView.delegate = self
                            self.imageCollectionView.dataSource = self
                            self.imageCollectionView.reloadData()
                        }
                    }
                }else{
                    self.showAlert(title: "Error", message: errorMessage ?? "")
                }
            })
        }
    }
    
    //MARK: - load video links and thumbnials on videoCollection
    func loadVideos(){
        self.artistImage = viewModel.artistData?.getArtistImageOrReturnDefault()
        let videoLinks = artistImage?.videoLinks?.split(separator: ",").map(String.init)
        self.videosArray = videoLinks ?? []
        
        
        self.videoCollectionView.delegate = self
        self.videoCollectionView.dataSource = self
        self.videoCollectionView.reloadData()
        
    }
    
    //MARK: - Artist profile update
    
    func updateArtistInfo(){
        if DataManager.getLanguage == Language.arabic.rawValue{
            
            self.artistDetailsCard.artistNameLabel.text = self.artistInfo?.stageName_ar
            
        }else{
            artistDetailsCard.artistNameLabel.text = self.artistInfo?.stageName
        }
        
        
        artistDetailsCard.ratingView.rating = self.artistData?.rating ?? 0.0
        DataManager.ratingData = self.artistData?.rating ?? 0.0
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            artistBiography.text = self.artistInfo?.biography_ar
        }else{
            artistBiography.text = self.artistInfo?.biography
        }
        
        let dummyImage = "placeholder_main"
        
        let artistIntro = self.artist_intro ?? []
        
        if artistIntro.isEmpty{
            artistDetailsCard.artistImageView.image = UIImage(named: dummyImage)
            artistDetailsCard.showhidVideo()
        }else{
            Utils.setImageTo(imageView: artistDetailsCard.artistImageView, imageName: artistIntro[0].thumbnail ?? "",placeholderImage: dummyImage)
            artistDetailsCard.videoID = artistIntro[0].video ?? ""
            
            artistDetailsCard.showVideoPlayerView(video: artistIntro[0].video ?? "")
        }
        
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            let spics = self.talent?.speciality_ar?.components(separatedBy: ",") ?? []
            self.specialitiesDataSource = spics
        }else{
            let spics = self.talent?.speciality?.components(separatedBy: ",") ?? []
            self.specialitiesDataSource =  spics
        }
    }
    
    
    
    @IBAction func btnQuestionsCLick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReviewCLick(_ sender: Any) {
        let viewController = Utils.getViewController(storyboard: StoryboardId.moreStoryboard, identifier: StoryboardId.reviewsContainerControllerId, viewController: ReviewContainerViewController.self)
        viewController.JustReview = true
        viewController.showAddReviewScreen = false
        viewController.bookingId = self.artistInfo?.userID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - continue with booking artist
    @IBAction func btnContinueCLick(_ sender: Any) {
        
        if DataManager.getUserLog == "guest"
        {
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
        }
        else{
            
            if numberOfBandMember.txtField.text == ""
            {
                self.showAlert(title: "", message: Utils.localizedText(text: "please mention number of band members"))
                return
            }
            
            if typeOfInstruments.txtField.text == ""
            {
                self.showAlert(title: "", message: Utils.localizedText(text: "please mention types of instruments"))
                return
            }
            
            
             if doyoureventneedSpeaker.txtField.text == ""
             {
                 self.showAlert(title: "", message: Utils.localizedText(text: "please type yes or no if you need a speaker"))
                 return
             }
            
            if DataManager.requestedPlaces == ""
            {
                self.showAlert(title: "", message: Utils.localizedText(text: "Please select a requested place"))
                return
            }
            
            if packageInfo?.isRange == "2" && self.totalEventPrice == 0
            {
                self.showAlert(title: "", message: Utils.localizedText(text: "please add play time"))
                return
            }
            
            claimBooking()
        }
    }
    
    func claimBooking() {
        self.viewModel.cliamBooking(param: ["artist_id":self.artistId ?? 0,"package_id":self.packageInfo?.id ?? 0]) { isSuccess, messageError in
            if isSuccess{
                customBookingV2.sharedInstance.userType = (self.artistData?.role_id == 3) ? "Entertainer" : "Artist"
                debugPrint(BookingNow.sharedInstance.userType)
                
                customBookingV2.sharedInstance.goToSing = (self.imgSingYes.image?.pngData()==UIImage.init(named: "check_box_checked")?.pngData()) ? "1" : "0"
                
                customBookingV2.sharedInstance.artist_id = self.artistInfo?.userID ?? 0
                
                customBookingV2.sharedInstance.bandMembersCount = Int(self.numberOfBandMember.txtField.text ?? "0") ?? 0
                
                customBookingV2.sharedInstance.instrumentType = self.typeOfInstruments.txtField.text ?? ""
                
                customBookingV2.sharedInstance.addInfo = self.doyoureventneedSpeaker.txtField.text ?? ""
                
                let rangeType = self.packageInfo!.isRange ?? ""
                if rangeType.elementsEqual("2"){
                    customBookingV2.sharedInstance.eventPrice =  self.totalEventPrice
                }else{
                    customBookingV2.sharedInstance.eventPrice =  self.packageInfo?.eventPrice ?? 0
                }
                
                customBookingV2.sharedInstance.playTime = self.selectPlaytime
                customBookingV2.sharedInstance.requested_place = self.selectedPlace
                
                debugPrint(customBookingV2.sharedInstance)
                
                let vc = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.artistLocationViewControllerId, viewController: SetLocationViewController.self)
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.showAlert(title: "Error", message: messageError ?? "")
            }
        }
    }
    
    
    //MARK: - load artist package information
    func loadPackageData(){
        
        guard ((self.artistData?.packages.count) ?? 0 > 0) else {
            return
        }
        self.packageInfo = self.artistData?.packages[0]
        debugPrint(self.packageInfo.debugDescription)
        
        var datasource: [String] = []
        
//        if packageInfo?.isRange == "0"{
//            let playtime = packageInfo?.playTime ?? 0
//
//            if playtime > 1{
//                self.playTime.text = Utils.localizedArabicNumber(stringV:packageInfo?.playTime?.clean ?? "0") + " " + Utils.localizedText(text: packageInfo?.timeType ?? "")
//            }
//            else{
//                self.playTime.text = Utils.localizedArabicNumber(stringV:String(packageInfo?.playTime?.clean ?? "0")) + " " + Utils.localizedText(text: String((packageInfo?.timeType ?? "").dropLast()))
//            }
//            view.layoutSubviews()
//            playtimeDropdownHeightConstraint.constant = 0
//            //                playtimStackView.isHidden = false
//            playtimeDropDown.isHidden = true
//            view.layoutSubviews()
//            view.layoutIfNeeded()
//        }
//        else if packageInfo?.isRange == "1"{
//            playtimeDropdownHeightConstraint.constant = 0
//            //                playtimStackView.isHidden = false
//            playtimeDropDown.isHidden = true
//            view.layoutSubviews()
//            view.layoutIfNeeded()
//
//            self.playTime.text = Utils.localizedArabicNumber(stringV:String(packageInfo?.playTimeFrom ?? 0)) + " - "+Utils.localizedArabicNumber(stringV:String(packageInfo?.playTimeTo ?? 0)) + " " + Utils.localizedText(text: packageInfo?.timeType ?? "")
//
//        }else if packageInfo?.isRange == "2"{
            view.layoutSubviews()
            playtimeDropdownHeightConstraint.constant = 80
            playtimeDropDown.isHidden = false
            //                playtimStackView.isHidden = true
            view.layoutSubviews()
            view.layoutIfNeeded()
            let perhour:Int = packageInfo?.perHour ?? 1
            for i in (0..<12) {
                datasource.append("\(i + 1)"+((i > 0) ? " Hours":" Hour"))
            }
        //}
        
        playtimeDropDown.dropDownDataSource = datasource
        playtimeDropDown.dropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            debugPrint(item)
            
            self!.calculateEventPrice(index: index + 1, item: item)
            self!.selectPlaytime = index + 1
        }
        
        
        
        self.places = packageInfo?.events.components(separatedBy: ",")
        
        if DataManager.getLanguage == Language.english.rawValue{
            lblGenre.text = talent?.geners ?? ""
            let eventprice = self.packageInfo!.eventPrice ?? 0
            
            lblPrice.text = (eventprice.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", eventprice) : "\(eventprice)")+" "+Utils.localizedText(text: "SAR")
        }
        else{
            lblGenre.text = talent?.geners_ar ?? ""
            let eventprice = self.packageInfo!.eventPrice ?? 0
            
            lblPrice.text = (eventprice.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", eventprice) : "\(eventprice)")+" "+Utils.localizedText(text: "SAR")
            lblPrice.font = UIFont(name: "Almarai-Bold", size: 18)
        }
        debugPrint(artistData)
        
        //updateArtistInfo()
    }
    
    // MARK: - get request places list
    var places : [String]?{
        didSet{
            var placesLocalized: [String] = []
            guard !(places?.isEmpty ?? true) else {
                return
            }
            if DataManager.getLanguage == Language.arabic.rawValue{
                for item in places! {
                    placesLocalized.append(Utils.localizedText(text: item))
                }
                preferPlaces.dropDownDataSource =  placesLocalized ?? []
            }else{
                preferPlaces.dropDownDataSource =  self.places ?? []
            }
        }
    }
    // calculate playtime if rateType is Fixed
    func calculateEventPrice(index:Int,item:String){
        
        self.playtimeDropDown.textInputFeild.text = item
        let eventPrice = ((packageInfo?.eventPrice)! * Double(index))
        self.totalEventPrice = (packageInfo?.eventPrice)! * Double(index)
        if DataManager.getLanguage == Language.english.rawValue{
            lblPrice.text = (eventPrice.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", eventPrice) : "\(eventPrice)")+" "+Utils.localizedText(text: "SAR")
        }
        else{
            lblPrice.text = (eventPrice.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", eventPrice) : "\(eventPrice)")+" "+Utils.localizedText(text: "SAR")
            lblPrice.font = UIFont(name: "Almarai-Bold", size: 18)
        }
        
    }
}

//MARK: - Video, Image Collectionview delegate
extension ArtistPackageViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        if collectionView == videoCollectionView{
            count = self.videosArray.count
        }else if collectionView == imageCollectionView{
            count = self.imagesArray.count
        }else if collectionView == specialitiesCollectionView {
            count = self.specialitiesDataSource?.count ?? 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == videoCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.videoCellIdentifier.rawValue, for: indexPath) as! VideoCollectionViewCell
            
            cell.configureCellWithImageNVideo(url: self.videosArray[indexPath.row])
            return cell
            
        }else if collectionView == imageCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.imageCellIdentifier.rawValue, for: indexPath) as! ImagesCollectionViewCell
            
            cell.configureCellWithImage(url: imagesArray[indexPath.row])
            return cell
            
        } else if collectionView == specialitiesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.specialitiesCellIdentifer.rawValue, for: indexPath) as! specialityCollectionViewClass
            
            cell.configureCellUI(lableTitle: self.specialitiesDataSource?[indexPath.item] ?? "")
            
            cell.sizeToFit()
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == videoCollectionView {
            return CGSize(width: 150, height: 100)
        }else if collectionView == imageCollectionView{
            return CGSize(width: 150, height: 100)
        }
        else{
            if DataManager.getLanguage == Language.arabic.rawValue{
                let str:String = specialitiesDataSource?[indexPath.item] ?? ""
                return CGSize(width: str.size(withAttributes: [NSAttributedString.Key.font : UIFont.init(name: "Almarai-Bold", size: 14)]).width + 10, height: 30)
            }
            else{
                let str:String = specialitiesDataSource?[indexPath.item] ?? ""
                return CGSize(width: str.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]).width + 10, height: 30)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageCollectionView{
            let vc = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: StoryboardId.fullScreenImageViewControllerId, viewController: FullScreenImageViewViewController.self)
            
            vc.dataSource = self.imagesArray
            vc.photoIndex = indexPath.row
            vc.contentType = .images
            self.present(vc, animated: true, completion: nil)
        }
        else if collectionView == videoCollectionView {
            let vc = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: StoryboardId.fullScreenImageViewControllerId, viewController: FullScreenImageViewViewController.self)
            
            if self.artistDetailsCard.videoPlayerView.isPlaying{
                self.artistDetailsCard.videoPlayerView.isPlaying = false
                self.artistDetailsCard.videoPlayerView.player?.pause()
            }
            
            vc.dataSource = self.videosArray
            vc.photoIndex = indexPath.row
            vc.contentType = .videos
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var edges: UIEdgeInsets = UIEdgeInsets()
        if collectionView == specialitiesCollectionView{
            edges = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
        else{
            edges = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        }
        return edges
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        var spaceSize: CGFloat = 0.0
        
        if collectionView == specialitiesCollectionView{
            spaceSize = CGFloat(5)
        }
        else{
            spaceSize = 20
        }
        return spaceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var spaceSize: CGFloat = 0.0
        if collectionView == specialitiesCollectionView{
            spaceSize = CGFloat(5)
        }
        else{
            spaceSize = 20
        }
        return spaceSize
    }
}



