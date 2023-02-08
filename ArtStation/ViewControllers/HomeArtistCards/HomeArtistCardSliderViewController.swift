//
//  HomeArtistCardSliderViewController.swift
//  ArtStation
//
//  Created by Apple on 07/06/2021.
//

import UIKit
import SwiftUI
import AVKit

class HomeArtistCardSliderViewController: UIViewController, ProtocolShowDetailArtist,ProtocolAddRemoveFavouriteArtist,onDeleteButtonClickedOnFavouriteArtistCell {
    
    
    func navigatetoArtistbyId(artistId: Int) {
        pushToNextCOntroller(artistId: String(artistId), roll_id: nil)
    }
    
    func removeFromFavouriteArtistList(artist: FavouriteArtistModel, index: Int) {
        self.UnpinArtist(id: artist.artist_id, role_id: (artist.artists?.role_id)!, categoryId: artist.category_id, index: index)
    }
    
    func addToFavouriteArtistList(id: Int, categoryId: Int, name: String?, role_id: Int) {
        if DataManager.getUserLog == "guest"
        {
            Utils.showAlertWithIntroNavigation(title: "", info: Utils.localizedText(text: "Please signup / login to continue using Art Station"), viewController: self, throughNavController: self.navigationController)
        }
        else{
            self.pinArtist(id:id, name: name!, categoryId: categoryId, role_id: role_id)
        }
    }
    
    func showDetailOfArtist(dataObj: GetArtistDetailApiResponse) {
        pushToNextCOntroller(artistId: dataObj.id?.description ?? "0",roll_id: dataObj.role_id)
    }
    
    
    func UnpinArtist(id: Int,role_id:Int,categoryId:Int,index:Int){
        
        viewModel.pinArtist(param: ["artist_id": id,
                                    "category_id":categoryId,"role_id":role_id]) { issucess, message in
            if issucess{
                self.viewModel.favouriteArtistList?.remove(at: index)
                self.favouriteArtistCollectionView.reloadData()
            }
        }
    }
    
    func pinArtist(id: Int,name:String,categoryId:Int,role_id:Int) {
        if ((self.viewModel.favouriteArtistList?.count ?? 0) <= 4){
            let count = self.viewModel.favouriteArtistList?.count ?? 0
            for i in (0..<count)  {
                if self.viewModel.favouriteArtistList?[i].artist_id == id{
                    self.showAlert(title: "Error", message: Utils.localizedText(text: "Artist is already in Pinned List"))
                    return
                }
            }
//            var params:Dictionary = Dictionary<String, Any>()
//            params["artist_id"] = id
//            params["categoryId"] = categoryId
//            params["role_id"] = role_id ?? 2
            
            
           // ["artist_id": id,"category_id":categoryId,"role_id":role_id]
            viewModel.pinArtist(param: ["artist_id":id,"category_id":categoryId,"role_id":role_id]) { issucess, message in
                    if issucess{
                       
                        self.viewModel.favouriteArtistList?.append(FavouriteArtistModel(id: 0, artist_id: id, category_id: categoryId, user_id: 0, artists: favourit_artist_Info(id: 0, role_id: role_id, artist_info: [Pinedartist(id: id, stageName: name, stageName_ar: name)])))
                        
                        self.favouriteArtistCollectionView.reloadData()
                    }
                }
        }else{
            self.showAlert(title: "Error", message: Utils.localizedText(text: "You have reached your maximum Pinned limit"))
        }
    }
    
    
    var childView: UIHostingViewControllerCustom?
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var viewForCards: UIView!
    
    @IBOutlet weak var closeHelperbutton:UIButton!
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var cardsScreeTitle:UILabel!
    
    
    @IBOutlet weak var favouriteArtistCollectionView:UICollectionView!
    let favouriteArtistCollectionCellIdentifer = "FavouriteArtistCollectionViewCell"
    
    var viewModel = HomeArtistCardViewModel()
    
    var categoryID : String?
    var artistType : String?
    var categoryNameText: String = ""
    var categoryrole_id:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        // Load Favourite Artist list collectionview
        loadFavouriteXibCell()
        
        debugPrint("VideoVideo",DataManager.getHomepageVideoOnboarding)
        if !DataManager.getHomepageVideoOnboarding {
            showVideoPlayerView()
        }
        else{
            videoContainer.isHidden = true
            closeHelperbutton.isHidden = true
            apiCallForArtistCards()
        }
        
        favouriteArtistCollectionView.reloadData()
        
//        if categoryrole_id == 3{
//            cardsScreeTitle.text = "Select your favourite Entertainer here!"
//        }else{
//            cardsScreeTitle.text = "Select your favourite Artist here!"
//        }
//        
    }
    
    
    //MARK: - Favourite Artist list collectionview
    func loadFavouriteXibCell() {
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            let nib = UINib(nibName: favouriteArtistCollectionCellIdentifer+"_ar", bundle: nil)
            nib.instantiate(withOwner: self, options: nil)
            
            favouriteArtistCollectionView.register(nib, forCellWithReuseIdentifier: "FavouriteArtistCollectionViewCell")
        }else{
            let nib = UINib(nibName: favouriteArtistCollectionCellIdentifer, bundle: nil)
            nib.instantiate(withOwner: self, options: nil)
            
            favouriteArtistCollectionView.register(nib, forCellWithReuseIdentifier: "FavouriteArtistCollectionViewCell")
        }
        
        favouriteArtistCollectionView.delegate = self
        favouriteArtistCollectionView.dataSource = self
        favouriteArtistCollectionView.reloadData()
    }
    
    
    
    func showVideoPlayerView(){
        
        videoContainer.clipsToBounds = true
        videoContainer.layer.cornerRadius = 16
        
        let videoURL: NSURL = Bundle.main.url(forResource: "swipeupdown2", withExtension: "mp4")! as NSURL
       // let videoURL: NSURL = Bundle.main.url(forResource: "swipeupdown", withExtension: "mp4")! as NSURL
        
        
        var queuePlayer: AVQueuePlayer!
        let asset: AVAsset = AVAsset(url:videoURL as URL)
        let playerItem = AVPlayerItem(asset: asset)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        queuePlayer.isMuted = true
        videoPlayerView.playerLayer.player = queuePlayer
        videoPlayerView.playerLayer.videoGravity = .resizeAspect
        videoPlayerView.setLooper(item: playerItem)
        videoPlayerView.player!.play()
    }
    
    func pushToNextCOntroller(artistId : String,roll_id:Int?)
    {
        if roll_id != nil && roll_id == 3 {
            let viewController = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.entertainerPackagesViewControllerId, viewController: EntertainerPackageViewController.self)
            viewController.artistId = artistId
            
            
            navigationController?.pushViewController(viewController, animated: false)
        }else{
            let viewController = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.artistPackagesViewControllerId, viewController: ArtistPackageViewController.self)
            viewController.artistId = artistId
            
            navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    
    func SetupUISlider()
    {
        DemoCard.delegatePushViewCOntroller=self
        DemoCard.delegateAddRemoveArtistFavourtieList=self
        
        childView = UIHostingViewControllerCustom(rootView: ContentView())
        if let childView = childView{
            addChild(childView)
            childView.view.backgroundColor = UIColor.clear
            childView.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
            
            childView.view.frame = CGRect.init(x:0, y:0,width:self.viewForCards.bounds.width, height: self.viewForCards.bounds.height)
            childView.view.clipsToBounds=true
            self.viewForCards.addSubview(childView.view)
            //view.addSubview(childView.view)
            childView.didMove(toParent: self)
            view.bringSubviewToFront(videoContainer)
        }
    }
    
    func SetupUI()
    {
        categoryName.text = categoryNameText
        
    }
    @IBAction func onCardSelected(_ sender: Any) {
        
        pushToNextCOntroller(artistId: "2", roll_id: nil)
    }
    
    @IBAction func onClosehelperAnimationTapped(_ sender:Any){
        DataManager.setHomepageVideoOnboarding = true
        videoContainer.isHidden = true
        closeHelperbutton.isHidden = true
        apiCallForArtistCards()
    }
    
    @IBAction func onCloseVideoPlayerTapped(_ sender: Any) {
        DataManager.setHomepageVideoOnboarding = true
        videoContainer.isHidden = true
        closeHelperbutton.isHidden = true
        apiCallForArtistCards()
    }
}


extension HomeArtistCardSliderViewController
{
    
    func apiCallForArtistCards() {
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
        DataManager.CategoryTypeSelection = artistType!
        viewModel.getArtists(params: ["type":artistType,"category_id":categoryID,"city_id":(DataManager.getCityForHomeData ?? 1).description]){
            success,errorString in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                
                DataManager.ArtistCards=self.viewModel.dataObj
                debugPrint(DataManager.ArtistCards?.list)
                self.SetupUISlider()
                
                self.favouriteArtistCollectionView.delegate = self
                self.favouriteArtistCollectionView.dataSource = self
                self.favouriteArtistCollectionView.reloadData()
            }else{
                self.showAlert(title: "Error", message: errorString ?? "")
            }
        }
    }
}

extension HomeArtistCardSliderViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel.favouriteArtistList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favouriteArtistCollectionCellIdentifer, for: indexPath) as! FavouriteArtistCollectionViewClass
        cell.listdelegate = self
        
        cell.configureCellUI(artist: self.viewModel.favouriteArtistList?[indexPath.item] ?? FavouriteArtistModel(id: 0, artist_id: 0, category_id: 0, user_id: 0,artists: nil), index: indexPath.item)
        
        //cell.configureCellUI(artist: (self.viewModel.favouriteArtistList[indexPth.item]), index: indexPath.item)
        cell.view.layoutSubviews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let str:String = self.viewModel.favouriteArtistList?[indexPath.item].artists?.artist_info?[0].stageName ?? ""
        return CGSize(width: str.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 8)]).width + 50, height: 30)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var edges: UIEdgeInsets = UIEdgeInsets()
        
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  CGFloat(5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var spaceSize: CGFloat = 0.0
        return CGFloat(5)
    }
}


class UIHostingViewControllerCustom:UIHostingController<ContentView>{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
