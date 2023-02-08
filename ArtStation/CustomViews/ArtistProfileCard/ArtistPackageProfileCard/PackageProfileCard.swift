//
//  PackageProfileCard.swift
//  ArtStation
//
//  Created by Andpercent on 24/12/2021.
//

import UIKit
import Cosmos
import AVKit
import Foundation

protocol specialityCollectionDelegate {
    func didSetDataSource(data:[String])
}

class PackageProfileCard: UIView,VideoPlayerViewDelegate {
    
    

    var specialitiesDataSource: [String]?
    
    @IBOutlet weak var spacilitiesCollectionView:UICollectionView!
    @IBOutlet weak var spacilitiesCollectionViewHeightConstraints: NSLayoutConstraint!
    
    var specialityDelegate: specialityCollectionDelegate?
    
    let cellId: String = "specialityCollectionViewCell"
    
    
    func didStartedPlaying() {
        if videoPlayerView.isHidden{
            showhidVideo()
        }
    }
    
    func playerStatusChanged(status: Bool) {
        if status{
            self.playPauseimg.image = UIImage(named: "pauseButton")
            //self.videoPlayerView.player?.play()
        }
        else if !status{
            self.playPauseimg.image = UIImage(named: "playButton")
            //self.videoPlayerView.player?.pause()
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
        
        if self.videoPlayerView.isPlaying{
            self.videoPlayerView.player?.pause()
            self.videoPlayerView.isPlaying.toggle()
            self.playPauseimg.image = UIImage(named: "playButton")
        }else{
            self.videoPlayerView.player?.play()
            self.playPauseimg.image = UIImage(named: "pauseButton")
            self.videoPlayerView.isPlaying.toggle()
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
            self.videoPlayerView.isPlaying = false
            self.soundOnOffimg.image = UIImage(named: "muteButton")
            
        }else if !videoPlayerView.isHidden{
            self.closeVideoimg.image = UIImage(named: "xButton")
            self.showVideoPlayerView(video: self.videoID)
            self.videoPlayerView.isPlaying = true
            self.videoPlayerView.player?.play()
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
            self.showhidVideo()
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
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: queuePlayer.currentItem)
        
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: nil)
    }
    
    @objc func playerDidFinishPlaying(note: Notification) {
        print("Video Finished")
        self.showhidVideo()
    }
    
    var viewIdentifier: String = "PackageProfileCard"
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var artistNameLabel:UILabel!
    

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
    
    override func awakeFromNib() {
        //let nibName = UINib(nibName: cellId, bundle:nil)
        //self.spacilitiesCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
    }
    
    
    func initView(){
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            self.viewIdentifier = "PackageProfileCard_ar"
        }
        let nib = UINib(nibName: viewIdentifier, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        contentView.frame = bounds
        addSubview(contentView)
        
        layer.cornerRadius = 16
        artistImageView.layer.cornerRadius = 16
        self.videoPlayerView.delegate = self
        self.videoPlayerView.view.isUserInteractionEnabled = false
        //self.specialityDelegate = self
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
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

//extension PackageProfileCard: UICollectionViewDelegate,UICollectionViewDataSource,specialityCollectionDelegate,UICollectionViewDelegateFlowLayout{
//    func didSetDataSource(data: [String]) {
//        specialitiesDataSource = data
//        spacilitiesCollectionView.dataSource = self
//        spacilitiesCollectionView.delegate = self
//        spacilitiesCollectionView?.contentInsetAdjustmentBehavior = .always
//        spacilitiesCollectionView.reloadData()
//        let height:CGFloat = spacilitiesCollectionView.collectionViewLayout.collectionViewContentSize.height
//        spacilitiesCollectionViewHeightConstraints.constant = height
//
//
//
//        self.layoutIfNeeded()
//        self.layoutSubviews()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return specialitiesDataSource?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! specialityCollectionViewClass
//
//        cell.configureCellUI(lableTitle: (specialitiesDataSource?[indexPath.item])!)
//        cell.sizeThatFits(CGSize(width: 50, height: 30))
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let str:String = specialitiesDataSource?[indexPath.item] ?? ""
//
//        return CGSize(width: str.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]).width + 20, height: 30)
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(10)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(10)
//    }
//}
