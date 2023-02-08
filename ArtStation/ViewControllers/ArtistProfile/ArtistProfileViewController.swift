//
//  ArtistProfileViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/3/21.
//

import UIKit
import LiveChat
import Cosmos
import youtube_ios_player_helper


class ArtistProfileViewController: UIViewController,PackageTableViewCellDelegate{
    
    enum CollectionViewCellIdentifier: String{
        case imageCellIdentifier = "imageCellIdentifier"
        case videoCellIdentifier = "videoCellIdentifier"
    }
    
    var artistInfo : ArtistInfo?
    var artistImage : ArtistImage?
    var artist_intro: [Artist_Intro]?
    var imagesArray : [String] = []
    var videosArray : [String] = []
    
    //MARK: - Artist Profile Introducation video and image
    var IntroImage: String?
    var IntroVideo: String?
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    //MARK:- IB Refrences
    @IBOutlet weak var artistDetailsCard: ProfileCard!
    
    @IBOutlet weak var packagesContainerView: UIView!
    @IBOutlet weak var bioGraphyHeaderView: UIView!
    @IBOutlet weak var artistBiography: UILabel!
    
    @IBOutlet weak var artistCoverImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var startinPriceLabel: UILabel!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - show ImageCollectionSelected Image
    var photoIndex:Int = 0
    @IBOutlet weak var viewVideoMain: UIView!
    @IBOutlet weak var nextPhotoBtnImage:UIImageView!
    @IBOutlet weak var previusePhotoBtnImage:UIImageView!
    @IBOutlet weak var nextPhotoBtn:UIButton!
    @IBOutlet weak var prePhotoBtn:UIButton!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var viewImageselected:UIImageView!
    
    
    
    //MARK: - close Image view and video view on select collection views 
    @IBAction func closeImageCollectionSelectedImage(_ sender:UIButton){
        
        ytPlayerView.stopVideo()
        self.viewImageselected.isHidden = true
        self.viewVideoMain.isHidden = true
        nextPhotoBtnImage.isHidden = true
        nextPhotoBtn.isHidden = true
        previusePhotoBtnImage.isHidden = true
        prePhotoBtn.isHidden = true
        
        self.viewImageselected.isHidden = true
        self.closeButton.isHidden = true
    }
    
    @IBAction func nextPhoto(_ sender:UIButton){
        self.nextPhotoinList()
    }
    
    @IBAction func previusePhoto(_ sender:UIButton){
        self.previousPhotoinList()
    }
    
    
    @IBAction func viewAllImages(_ sender: UIButton){
        
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: "ImagesGridControllerId", viewController: ImagesGridViewController.self)
        
        
        viewController.contentType = .images
        viewController.dataSource = imagesArray
        self.navigationController?.pushViewController(viewController, animated: true)
    
    }
    
    @IBAction func viewAllVideos(_ sender:UIButton){
        
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: "ImagesGridControllerId", viewController: ImagesGridViewController.self)
        
    
        viewController.dataSource = self.videosArray
        viewController.contentType = .videos
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
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
    
    func loadVideos(){
        self.artistImage = viewModel.artistData?.getArtistImageOrReturnDefault()
        let videoLinks = artistImage?.videoLinks?.split(separator: ",").map(String.init)
        self.videosArray = videoLinks ?? []
        
        
        self.videoCollectionView.delegate = self
        self.videoCollectionView.dataSource = self
        self.videoCollectionView.reloadData()
        
    }
    
    var showcloseChatOptionsState:Bool = false
    
    
    @IBOutlet weak var ratingView: CosmosView!
        //MARK:- Data
    let packageTableCellIdentifier = "package_table_cell"
    let viewModel = ArtistProfileViewModel()
    var artistId : String?
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // floatingActionButton.fabDelegate = self
        debugPrint("ArtistID Sent",artistId)
        tableView.estimatedRowHeight = 427
        tableView.rowHeight = UITableView.automaticDimension
        setupUI()
    }
  

    //MARK:- Sets up initial UI
    func setupUI(){
        // Do any additional setup after loading the view.
      //  artistCoverImage.layer.cornerRadius = 10
     //   artistCoverImage.layer.masksToBounds = true
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
//    func floatyActionButton(){
//        if DataManager.getLanguage == Language.arabic.rawValue{
//
//            floatingActionButton.addItem("Whatsapp", icon: UIImage(named: "whatsappIcon"), titlePosition: .right) { flitem in
//                self.whatsappChatOptionClicked()
//            }
//        }
//        else{
//
//            floatingActionButton.addItem("Whatsapp", icon: UIImage(named: "whatsappIcon")) { flitem in
//
//                self.whatsappChatOptionClicked()
//            }
//        }
//
//        floatingActionButton.itemSize = 60
//        floatingActionButton.autoCloseOnTap = true
//        floatingActionButton.openAnimationType = .pop
//        floatingActionButton.itemSpace = 16
//        let item = floatingActionButton.items[0]
//        item.iconImageView.scalesLargeContentImage
//        item.imageSize = CGSize(width: 50, height: 50)
//        item.titleLabel.font = UIFont.systemFont(ofSize: 20)
//        floatingActionButton.rotationDegrees = 90
//    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        bioGraphyHeaderView.setGradientBackground(colorStart:UIColor(red: 255, green: 241, blue: 201, alpha: 1), colorEnd: UIColor(red: 255, green: 228, blue: 201, alpha: 0))
        getArtistProfileData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DataManager.setPackageSelection = true
        self.artistDetailsCard.videoPlayerView.player?.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
  
    func getArtistProfileData(){
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "Loading")
        let request = GetArtistDetailApiRequest(artistId: artistId ?? "-1", type: DataManager.CategoryTypeSelection)
            viewModel.getDataForArtistProfile(request: request, onCompletionHandler: {
            success,message in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                
                self.updateArtistInfo()
                self.loadImages()
                self.loadVideos()
                self.tableView.reloadData()
                
            }else{
                
                self.showAlert(title: "Error", message: message ?? "")
                
            }
        })
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if object is UITableView{
                if let newValue = change?[.newKey]{
                    let newSize = newValue as! CGSize
                    self.tableViewHeightConstraint.constant = newSize.height
                }
            }
        }
    }
    
    
    func liveChatOptionClicked() {
        LiveChat.licenseId = "12948735"
        LiveChat.email = DataManager.getUserData?.email
        LiveChat.name = DataManager.getUserData?.name
        LiveChat.presentChat()
    }
    
    
    func whatsappChatOptionClicked() {
        let whatsappURL = URL(string:"https://wa.me/+966537746799")!
        debugPrint(whatsappURL)
              if UIApplication.shared.canOpenURL(whatsappURL){

                  UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)

              }
    }
    
//    func floatyShouldOpen(_ floaty: Floaty) -> Bool {
//        return onChatIconTapped()
//    }
    
    
    func onChatIconTapped() -> Bool {
        if DataManager.getUserLog == "guest"
        {
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
            return false
        }
        else{
            return true
        }
    }
    
    func updateArtistInfo(){
        if DataManager.getLanguage == Language.arabic.rawValue{
            artistDetailsCard.artistNameLabel.text = viewModel.artistData?.artist_info[0].stageName_ar
            artistDetailsCard.artistPriceLabel.text =  String(viewModel.artistData?.startingFrom ?? 0)+" "+Utils.localizedText(text: "SAR")
            
            artistDetailsCard.artistPriceLabel.font = UIFont(name: "Almarai-Bold", size: 18)
            
        }else{
            artistDetailsCard.artistNameLabel.text = viewModel.artistData?.artist_info[0].stageName
            artistDetailsCard.artistPriceLabel.text = Utils.localizedText(text: "SAR")+" "+String(viewModel.artistData?.startingFrom ?? 0)
            
        }
        
        artistDetailsCard.ratingView.rating = viewModel.artistData?.rating ?? 0.0
        DataManager.ratingData = viewModel.artistData?.rating ?? 0.0
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            artistBiography.text = viewModel.artistData?.getArtistInfo().biography_ar
        }else{
            artistBiography.text = viewModel.artistData?.getArtistInfo().biography
        }
        
        let dummyImage = "placeholder_main"
        
        let artistIntro = viewModel.artistData?.artist_intro ?? []
        
        debugPrint(artistIntro.description)
        
        if artistIntro.isEmpty{
            artistDetailsCard.artistImageView.image = UIImage(named: dummyImage)
            artistDetailsCard.showhidVideo()
        }else{
            Utils.setImageTo(imageView: artistDetailsCard.artistImageView, imageName: viewModel.artistData?.artist_intro?[0].thumbnail ?? "",placeholderImage: "placeholder_list")
            artistDetailsCard.videoID = artistIntro[0].video ?? ""
            
            artistDetailsCard.showVideoPlayerView(video: viewModel.artistData?.artist_intro?[0].video ?? "")
        }
    }
    
    
    func onPackageSeleted(index: Int) {
        
        if DataManager.getUserLog == "guest"
        {
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
            return
        }
        
        let vc = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.artistPackagesViewControllerId, viewController: ArtistPackageViewController.self)
        
        let vm = viewModel.artistData?.artist_info[0]
        vc.artistInfo1 = vm
        vc.talent = viewModel.artistData?.artist_talent?[0]
        vc.artistInfo = viewModel.artistData?.getArtistInfo()
        vc.artistImage = viewModel.artistData?.getArtistImageOrReturnDefault()
        vc.artistPrice = String(viewModel.artistData?.startingFrom ?? 0)
        vc.packageInfo = viewModel.artistData?.packages[index]
        vc.artistData = viewModel.artistData
        vc.artist_intro = viewModel.artistData?.artist_intro
        
        self.artistImage = viewModel.artistData?.getArtistImageOrReturnDefault()
        BookingNow.sharedInstance.artist_id = viewModel.artistData?.id ?? 0
        BookingNow.sharedInstance.package_id = viewModel.artistData?.packages[index].id ?? 0
        BookingNow.sharedInstance.amount = viewModel.artistData?.packages[index].eventPrice ?? 0
        self.navigationController?.pushViewController(vc, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

//MARK:- Packages Table Delegate 
extension ArtistProfileViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.artistData?.packageCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: packageTableCellIdentifier) as! PackageTableViewCell
        cell.backgroundView = nil
        cell.backgroundColor = .clear
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.backgroundColor = .white
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.delegate = self
        let cellViewModel = PackageTableCellViewModel(cellData: viewModel.artistData?.packages[indexPath.row] ?? nil, rowId: indexPath.row)
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

extension ArtistProfileViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        if collectionView == videoCollectionView{
            count = self.videosArray.count
        }else{
            count = self.imagesArray.count
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
            
        }else{ return UICollectionViewCell() }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView == videoCollectionView ? CGSize(width: 150, height: 200) : CGSize(width: 145, height: 100)
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
            
            vc.dataSource = self.videosArray
            vc.photoIndex = indexPath.row
            vc.contentType = .videos
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: - Videocollectionview datasource load
    func playInYoutube(youtubeId: String) {
        if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: - ImageCollectionview scroll next previous
    func nextPhotoinList(){
        let count = (imagesArray.count ?? 0)
        if self.photoIndex < count - 1{
        self.photoIndex += 1
            Utils.setImageTo(imageView: self.viewImageselected, imageName: imagesArray[self.photoIndex], placeholderImage: "")
        }
        updatenextprebtns()
    }
    
    func previousPhotoinList(){
        if self.photoIndex > 0{
            self.photoIndex -= 1
            Utils.setImageTo(imageView: self.viewImageselected, imageName: imagesArray[self.photoIndex], placeholderImage: "")
        }
        updatenextprebtns()
    }
    
    func updatenextprebtns(){
        if imagesArray.count ?? 0 > 0{
            let count = imagesArray.count ?? 0
            if self.photoIndex < count - 1 {
                nextPhotoBtnImage.isHidden = false
                nextPhotoBtn.isHidden = false
            }else{
                nextPhotoBtnImage.isHidden = true
                nextPhotoBtn.isHidden = true
            }
            
            if self.photoIndex > 0 && count > 0{
                prePhotoBtn.isHidden = false
                previusePhotoBtnImage.isHidden = false
            }
            else{
                prePhotoBtn.isHidden = true
                previusePhotoBtnImage.isHidden = true
            }
        }
    }
}
