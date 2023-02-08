//
//  LaunchViewController.swift
//  ArtStation
//
//  Created by Apple on 01/06/2021.
//

import UIKit
import AVKit
import Firebase

class LaunchViewController:  UIViewController {
    
    var timer = Timer()
    
    @IBOutlet weak var videoPlayerView:VideoPlayerView!
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
//        timer.invalidate() // just in case this button is tapped multiple times
//        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: false)
        // UserDefaults.standard.set("true", forKey: UserDefaultsKeys.isUserLoggedIn.rawValue)
        // Do any additional setup after loading the view.
     
        setNeedsStatusBarAppearanceUpdate()
        showVideoPlayerView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        .lightContent
    }
    
    @objc func timerAction()
    {
        //checkVersion()
        //self.navigateToRelatedView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("ios_landing_page", parameters: nil)
        showVideoPlayerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func navigateToRelatedView()
    {
        
        let valueFromUserDefaults=UserDefaults.standard.object(forKey: DataManager.userLogKey) as? String ?? ""
        
        if ( valueFromUserDefaults=="true"||valueFromUserDefaults=="guest") /*UserDefaults.standard.object(forKey: "log") as? String ?? "" == "true"*/
        {
            
            
            let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
            let userDetails = DataManager.getUserData!
            if DataManager.getLoginType == "social" && (userDetails.city == "0" || userDetails.phone == "0"){
                if DataManager.getLanguage == Language.arabic.rawValue{
                    homepageViewController.openWithIndex = 1
                }else{
                    homepageViewController.openWithIndex = 3
                    
                }
            }
            
            if let keyWindow = UIWindow.key {
                keyWindow.rootViewController = homepageViewController
            }
        }
        else
        {
            
            
            let initialViewController = Utils.getViewController(storyboard: StoryboardId.onBoardingStoryboard, identifier: "navReg", viewController: UINavigationController.self)
            
            
            if let keyWindow = UIWindow.key {
                keyWindow.rootViewController = initialViewController
            }
        }
    }
    
    func showVideoPlayerView(){
        let videoURL: NSURL = Bundle.main.url(forResource: "logoAnimation", withExtension: "mp4")! as NSURL
        var queuePlayer: AVQueuePlayer!
        let asset: AVAsset = AVAsset(url:videoURL as URL)
        let playerItem = AVPlayerItem(asset: asset)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        queuePlayer.isMuted = true
        videoPlayerView.playerLayer.player = queuePlayer
        videoPlayerView.playerLayer.videoGravity = .resizeAspectFill
        videoPlayerView.playerLayer.player?.actionAtItemEnd = .pause
        videoPlayerView.player!.play()
        videoPlayerView.isPlaying = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: queuePlayer.currentItem)
    }
    
    @objc func playerDidFinishPlaying(note: Notification) {
        print("Video Finished")
        self.navigateToRelatedView()
    }
}

enum launchAnimationStatus {
    case isPlaying
    case paused
    case complete
}

