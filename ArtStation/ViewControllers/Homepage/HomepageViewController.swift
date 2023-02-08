//
//  HomepageViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/2/21.
//

import UIKit


class HomepageViewController: UIViewController,HompepageCollectionViewDelegate, SelectCityDelegate,UIScrollViewDelegate {
    
    
    @IBOutlet weak var btnSwiper: UIButton!
    
    var pageNum = 1
    var noOfResults = 20
    //MARK:- Data
    var currentItem = 0
    let cellIdentifierSinger = "homepage_collectionView_cell_singer"
    let cellIdentifierDj = "homepage_collectionView_cell_dj"
    var collectionViewDataSource = [MusicArtistCategory]()
    var videoPlayerItems : [VideoPlayerView] = []
    
    //MARK:- IB Refrences
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var nextButtonImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    var callingFromButton = false
    
    
    var homePageViewModel = HomePageViewModel()
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        DataManager.setPackageSelection = true
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldNavToEvents),name:NSNotification.Name(rawValue: "shouldNavToEvents"), object: nil)
        //
        //
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        //            swipeRight.direction = .right
        //            self.btnSwiper.addGestureRecognizer(swipeRight)
        //
        //            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        //            swipeLeft.direction = .left
        //            self.btnSwiper.addGestureRecognizer(swipeLeft)
        
        if DataManager.getUserLog=="guest"
        {
            if DataManager.getCityForHomeData==0
            {
                DataManager.setCityForHomeData = 1
            }
        }
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.collectionViewDataSource = []
        self.collectionView.reloadData()
    }
    
    //    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    //
    //        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
    //
    //            switch swipeGesture.direction {
    //            case .right:
    //              //  print("Swiped::::::::::::::::::::::::::::::::::::::::::::::::: right")
    //                //back
    //                if currentItem > 0
    //                {
    //                currentItem -= 1
    //                collectionView.scrollToItem(at: IndexPath.init(row: currentItem, section: 0), at: .centeredHorizontally, animated: true)
    //                collectionView.scrollRectToVisible(CGRect(x: collectionView.frame.width * CGFloat(currentItem), y: 0, width: collectionView.frame.width, height: collectionView.frame.height), animated: true)
    //                updatePageControl()
    //                }
    //            case .down:
    //                print("Swiped:::::::::::::::::::::::::::::::::::::::::::::::::  down")
    //            case .left:
    //                //  print("Swiped:::::::::::::::::::::::::::::::::::::::::::::::::  left")
    //                //next
    //                if currentItem == collectionViewDataSource.count-1
    //                {
    //                    return
    //                }
    //                if currentItem < collectionViewDataSource.count{
    //                    currentItem += 1
    //                    collectionView.scrollToItem(at: IndexPath.init(row: currentItem, section: 0), at: .centeredHorizontally, animated: true)
    //
    //                    collectionView.scrollRectToVisible(CGRect(x: collectionView.frame.width * CGFloat(currentItem), y: 0, width: collectionView.frame.width, height: collectionView.frame.height), animated: true)
    //                    updatePageControl()
    //                }
    //            case .up:
    //                print("Swiped:::::::::::::::::::::::::::::::::::::::::::::::::  up")
    //            default:
    //                break
    //            }
    //        }
    //    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // homePageViewModel.resetData()
        //homePageViewModel.getVat()
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height), animated: false)
        apiCallForArtistCategories(cityId: DataManager.getCityForHomeData ?? 1)
        let tabBarController = (self.parent?.parent?.parent as! TabbarContainerViewController)
        tabBarController.delegate = self
        tabBarController.setupCityButton()
        
    }
    
    //MARK:- Delegate Method to update Categories
    func citySelected(id: Int) {
        debugPrint(id)
        DataManager.setCityForHomeData = id
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height), animated: false)
        apiCallForArtistCategories(cityId: id)
    }
    
    //MARK:- Setup Initial UI
    func setupUI(){
        collectionView.delegate = self
        collectionView.backgroundColor = .none
        updateButtonImageView(status: false,button : backButton, imageView: backButtonImage)
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = collectionViewDataSource.count
    }
    
    
    @objc func shouldNavToEvents()
    {
        self.tabBarController?.selectedIndex = 1
    }
    
    //MARK:- BackButtonTapped
    @IBAction func onBackButtonTapped(_ sender: Any) {
        
        if currentItem > 0
        {
            currentItem -= 1
            collectionView.scrollToItem(at: IndexPath.init(row: currentItem, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.scrollRectToVisible(CGRect(x: collectionView.frame.width * CGFloat(currentItem), y: 0, width: collectionView.frame.width, height: collectionView.frame.height), animated: true)
            updatePageControl()
            //  scrollViewDidEndDecelerating(collectionView)
        }
        
    }
    
    //MARK:- NextButtonTapped
    @IBAction func onNextButtonTapped(_ sender: Any) {
        
        
        if currentItem < collectionViewDataSource.count{
            currentItem += 1
            collectionView.scrollToItem(at: IndexPath.init(row: currentItem, section: 0), at: .centeredHorizontally, animated: true)
            
            collectionView.scrollRectToVisible(CGRect(x: collectionView.frame.width * CGFloat(currentItem), y: 0, width: collectionView.frame.width, height: collectionView.frame.height), animated: true)
            updatePageControl()
            //scrollViewDidEndDecelerating(collectionView)
        }
    }
    
    //MARK:- Updates Page Control
    func updatePageControl(){
        
        pageControl.currentPage = currentItem
        
        if collectionViewDataSource.count==1
        {
            updateButtonImageView(status: false, button: nextButton, imageView: nextButtonImage)
            updateButtonImageView(status: false, button: backButton, imageView: backButtonImage)
        }
        else
            if currentItem == 0{
                updateButtonImageView(status: false, button: backButton, imageView: backButtonImage)
                updateButtonImageView(status: true, button: nextButton, imageView: nextButtonImage)
                
            }else if currentItem == collectionViewDataSource.count - 1 {
                updateButtonImageView(status: false, button: nextButton, imageView: nextButtonImage)
                updateButtonImageView(status: true, button: backButton, imageView: backButtonImage)
                
            }else{
                updateButtonImageView(status: true, button: backButton, imageView: backButtonImage)
                updateButtonImageView(status: true, button: nextButton, imageView: nextButtonImage)
            }
        
    }
    
    
    
    //MARK:- Updates BackButton Views
    func updateButtonImageView(status : Bool,button : UIButton,imageView : UIImageView){
        button.isEnabled = status
        if status{
            imageView.alpha = 1
        }else{
            imageView.alpha = 0.5
        }
    }
    
    func onArtistSelected(category: String, artistyType: String,categoryName: String,categoryrole_id:Int) {
        // push card vc here
        
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistCardStoryboard, identifier: StoryboardId.artistCardViewControllerId, viewController: HomeArtistCardSliderViewController.self)
        
        
        viewController.categoryNameText = categoryName
        viewController.artistType = artistyType
        viewController.categoryID = category
        viewController.categoryrole_id = categoryrole_id
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
    
}


//MARK:- CollectionView Delegate
extension HomepageViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let viewModel = HomepageCollectionViewCellViewModel(data: collectionViewDataSource[indexPath.item])
        
        if viewModel.cellData.artistType != "both"{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifierDj, for: indexPath) as! HomepageCollectionViewCellDJ
            cell.viewModel = viewModel
            cell.delegate = self
            
            debugPrint("VideoData",(viewModel.cellData.video ?? "") + "     " + (viewModel.cellData.type ?? "") )
            
            if let videoId = viewModel.cellData.video,viewModel.cellData.video != "null",viewModel.cellData.type != "image"{
                Utils.playVideo(playerView: cell.videoPlayerView, videoURL: "\(ConfigurationManager.shared.getBaseURLV())videoStreaming?video=\(videoId)")
                debugPrint("VideoStartedPlaying")
            }else{
                cell.videoPlayerView.isHidden = true
            }
            
            if viewModel.cellData.role_id == 3{
                cell.categoryHeadLineQuestion.text = Utils.localizedText(text:"What kind of entertainer are you looking for?")
            }else{
                cell.categoryHeadLineQuestion.text = Utils.localizedText(text: "What kind of musicians are you looking for?")
            }
            
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifierSinger, for: indexPath) as! HomepageCollectionViewCell
            
            cell.viewModel = viewModel
            cell.delegate = self
            debugPrint("VideoData",(viewModel.cellData.video ?? "") + "     " + (viewModel.cellData.type ?? ""))
            if let videoId = viewModel.cellData.video,viewModel.cellData.video != "null",viewModel.cellData.type != "image"{
                debugPrint("PlayingVideo",videoId)
                
                Utils.playVideo(playerView: cell.videoPlayerView, videoURL: "\(ConfigurationManager.shared.getBaseURLV())videoStreaming?video=\(videoId)")
            }
            else{
                cell.videoPlayerView.isHidden = true
            }
            
            if viewModel.cellData.role_id == 3{
                cell.categoryHeadlineQuestion.text =  Utils.localizedText(text: "What kind of entertainer are you looking for?")
                cell.bandButton.setTitle(Utils.localizedText(text: "Group"), for: .normal)
            }else{
                cell.categoryHeadlineQuestion.text = Utils.localizedText(text: "What kind of musicians are you looking for?")
                cell.bandButton.setTitle(Utils.localizedText(text: "Band"), for: .normal)
            }

            return cell
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomepageCollectionViewCellDJ{
            cell.videoPlayerView.player?.pause()
            //  cell.videoPlayerView.
            cell.videoPlayerView.isPlaying = false
        }else if let cell = cell as? HomepageCollectionViewCell{
            cell.videoPlayerView.player?.pause()
            cell.videoPlayerView.isPlaying = false
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        currentItem = visibleIndexPath?.row ?? 0
        updatePageControl()
    }
    
    
    func apiCallForArtistCategories(cityId : Int) {
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: "")
        homePageViewModel.getHomeData(cityId: cityId, paginationParams : PaginationParams(page: pageNum, per_page: noOfResults),params: [String : Any]()){
            success,errorString in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                self.collectionViewDataSource = self.homePageViewModel.dataObj
                debugPrint(self.collectionViewDataSource.count)
                self.currentItem = 0
                self.collectionView.reloadData()
                self.updatePageControl()
            }else{
                self.showAlert(title: "Error", message: errorString ?? "")
            }
        }
    }
}

extension HomepageViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


