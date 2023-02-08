//
//  VideoPlayerView.swift
//  ArtStation
//
//  Created by MamooN_ on 4/16/21.
//

import UIKit
import AVKit
import AVFoundation
import Combine

protocol VideoPlayerViewDelegate{
    func didStartedPlaying()
    func playerStatusChanged(status:Bool)
}

class VideoPlayerView: UIView {
    
    var delegate: VideoPlayerViewDelegate?
    let view = UIView()
    let imageView = UIImageView()
    var playerLooper : AVPlayerLooper?
    var isObserving = false
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    var isPlaying = false{
        didSet{
            delegate?.playerStatusChanged(status: isPlaying)
        }
    }
    var isMuted = false
    override class var layerClass: AnyClass{
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.stopAnimating()
        
    }
    
    
    var playerLayer : AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    var player : AVQueuePlayer?{
        set{
            playerLayer.player = newValue
            playerLayer.player?.actionAtItemEnd = .none
        }get{
            return playerLayer.player as? AVQueuePlayer
        }
    }
    
    func setLooper(item : AVPlayerItem){
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
        try?AVAudioSession.sharedInstance().setActive(true)
        
     
        playerLooper = AVPlayerLooper(player: player!, templateItem: item)
        isPlaying = true
        if isMuted{
            self.player?.isMuted = true
        }else{
            self.player?.isMuted = false
        }
    }
}


