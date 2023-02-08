//
//  ProfileCard.swift
//  ArtStation
//
//  Created by MamooN_ on 12/16/21.
//

import UIKit
import Cosmos
import AVKit

class ProfileCard: UIView, VideoPlayerViewDelegate {
    func playerStatusChanged(status: Bool) {
        
    }
    
    func didStartedPlaying() {
        if videoPlayerView.isHidden{
            showhidVideo()
        }
    }
    
    
    
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var playPauseimg: UIImageView!
    @IBOutlet weak var soundOnOffimg: UIImageView!
    @IBOutlet weak var closeVideoimg: UIImageView!
    
    @IBOutlet weak var playPausebtn: UIButton!
    @IBOutlet weak var soundOnOffbtn: UIButton!
    @IBOutlet weak var closeVideobtn: UIButton!
    
    var videoID: String = ""
    
    @IBAction func playPause(_ sender: UIButton){
        
        guard let player = self.videoPlayerView.player else{ return }
        self.videoPlayerView.isPlaying.toggle()
        if !self.videoPlayerView.isPlaying{
            self.videoPlayerView.player?.pause()
            self.playPauseimg.image = UIImage(named: "playButton")
        }else if self.videoPlayerView.isPlaying{
            self.videoPlayerView.player?.play()
            self.playPauseimg.image = UIImage(named: "pauseButton")
        }
        print("pause")
    }
    
    
    @IBAction func muteUnmute(_ sender: UIButton){
        
        guard let player = self.videoPlayerView.player else{ return }
        player.isMuted.toggle()
        self.videoPlayerView.isMuted = player.isMuted
        if self.videoPlayerView.isMuted{
            self.soundOnOffimg.image = UIImage(named: "muteButton")
        }else{
            self.soundOnOffimg.image = UIImage(named: "unmuteButton")
        }
    }
    
    
    @IBAction func closebutton(_ sender: UIButton){
        showhidVideo()
    }
    
    func showhidVideo(){
        self.videoPlayerView.isHidden.toggle()
        self.playPausebtn.isHidden.toggle()
        self.playPauseimg.isHidden.toggle()
        self.soundOnOffbtn.isHidden.toggle()
        self.soundOnOffimg.isHidden.toggle()
        
        if videoPlayerView.isHidden{
            self.closeVideoimg.image = UIImage(named: "reloadimg")
            self.videoPlayerView.player?.pause()
            self.playPauseimg.image = UIImage(named: "playButton")
            self.soundOnOffimg.image = UIImage(named: "muteButton")
            
        }else if !videoPlayerView.isHidden{
            self.closeVideoimg.image = UIImage(named: "xButton")
            self.showVideoPlayerView(video: self.videoID)
            if self.videoPlayerView.isPlaying{
                self.playPauseimg.image = UIImage(named: "pauseButton")
                self.videoPlayerView.player?.play()
            }
            else{
                self.playPauseimg.image = UIImage(named: "playButton")
                self.videoPlayerView.player?.pause()
            }
            
            if !videoPlayerView.isMuted{
                self.soundOnOffimg.image = UIImage(named: "unmuteButton")
                self.videoPlayerView.player?.isMuted = videoPlayerView.isMuted
            }else{
                self.soundOnOffimg.image = UIImage(named: "muteButton")
                self.videoPlayerView.player?.isMuted = videoPlayerView.isMuted
            }
        }
    }
    
    
    
    
    //MARK: - show client side video
    
    func showVideoPlayerView(video: String){
        videoPlayerView.clipsToBounds = true
        videoPlayerView.layer.cornerRadius = 16
        
        var queuePlayer: AVQueuePlayer!
        
        guard let videoURL = URL(string:"\(ConfigurationManager.shared.getBaseURLV())videoStreaming?video=\(video)") ?? URL(string: "") else {
            return
        }
        
        let asset: AVAsset = AVAsset(url:videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        queuePlayer.isMuted = false
        videoPlayerView.playerLayer.player = queuePlayer
        videoPlayerView.playerLayer.videoGravity = .resizeAspectFill
        videoPlayerView.playerLayer.player?.actionAtItemEnd = .advance
        //videoPlayerView.setLooper(item: playerItem)
        self.videoPlayerView.player?.play()
        self.videoPlayerView.isPlaying = true
        
        if self.videoPlayerView.isPlaying{
            self.playPauseimg.image = UIImage(named: "pauseButton")
            self.videoPlayerView.player?.play()
        }
        else{
            self.playPauseimg.image = UIImage(named: "playButton")
            self.videoPlayerView.player?.pause()
        }
        
        if !videoPlayerView.isMuted{
            self.soundOnOffimg.image = UIImage(named: "unmuteButton")
            self.videoPlayerView.player?.isMuted = videoPlayerView.isMuted
        }else{
            self.soundOnOffimg.image = UIImage(named: "muteButton")
            self.videoPlayerView.player?.isMuted = videoPlayerView.isMuted
        }
        
        //        if videoPlayerView.isHidden && videoPlayerView.isPlaying{
        //            showhidVideo()
        //        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: queuePlayer.currentItem)
        
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: nil)
        
    }
    
    @objc func playerDidFinishPlaying(note: Notification) {
        print("Video Finished")
        self.showhidVideo()
    }
    
    var viewIdentifier: String = "ProfileCard"
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var artistPriceLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var videoLink : String? = ""{
        didSet{
            showVideoPlayerView(video: videoLink ?? "")
        }
    }
    
    var ImageLinke: UIImage? = UIImage(named: "") {
        didSet{
            self.artistImageView.image = ImageLinke
        }
    }
    
    //MARK:- Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView(){
        if DataManager.getLanguage == Language.arabic.rawValue{
            self.viewIdentifier = "ProfileCard_ar"
        }
        
        let nib = UINib(nibName: viewIdentifier, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        layer.cornerRadius = 16
        artistImageView.layer.cornerRadius = 16
        self.videoPlayerView.delegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                self.videoPlayerView.delegate?.didStartedPlaying()
                debugPrint("calledddddddddddddddddd")
                break
                // Player item is ready to play.
            case .failed:
                break
                // Player item failed. See error.
            case .unknown:
                break
                // Player item is not yet ready.
            default: break
            }
        }
    }
}
