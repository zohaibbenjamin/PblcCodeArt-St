//
//  HomepageCollectionViewCellDJ.swift
//  ArtStation
//
//  Created by MamooN_ on 6/16/21.
//

import UIKit

class HomepageCollectionViewCellDJ: UICollectionViewCell,VideoPlayerViewDelegate {
    func playerStatusChanged(status: Bool) {
        
    }
    
    //MARK:- IB Refrences
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var cellBackgroundImage: UIImageView!
    @IBOutlet weak var buttonContainer: UIStackView!
    @IBOutlet weak var categoryHeadLineQuestion:UILabel!
    @IBOutlet weak var musicianTypeLabel: UILabel!
    @IBOutlet weak var bookNowButton: UIButton!
    let dJButton = UIButton()
    var delegate : HompepageCollectionViewDelegate?
    
    @IBOutlet weak var playButtonImageView: UIImageView!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    //MARK:- Data
    var viewModel : HomepageCollectionViewCellViewModel?{
        didSet{
            
            if DataManager.getLanguage == Language.arabic.rawValue{
                musicianTypeLabel.text = viewModel?.cellData.name_ar
            }
            else{
            musicianTypeLabel.text = viewModel?.cellData.name
            }
            let type = viewModel?.cellData.type
           
            
            
            let backgroundImage = viewModel?.cellData.type == "image" ? viewModel?.cellData.image : viewModel?.cellData.thumbnail
            cellBackgroundImage.sd_setImage(with:URL(string:String.init(format: "%@%@",ConfigurationManager.shared.getBaseURLImage().absoluteString,backgroundImage ?? "")), placeholderImage: UIImage.init(named: "placeholder_main"))
                configureUIForCell()

        }
    }
    
    //MARK:- PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        videoPlayerView.player?.pause()
        videoPlayerView.player = nil
        videoPlayerView.playerLayer.player = nil
    }
    
    @IBAction func playPauseButton(_ sender: Any) {
        debugPrint("Here")
        if videoPlayerView.isPlaying{
            DispatchQueue.main.async{
                self.videoPlayerView.isHidden = true
                self.videoPlayerView.player?.pause()
                self.playButtonImageView.image = UIImage(named: "play_circle")
            }
        }else{
            DispatchQueue.main.async{
                self.videoPlayerView.isHidden = false
                self.videoPlayerView.player?.play()
                self.playButtonImageView.image = UIImage(named: "pause_circle")}
        }
        videoPlayerView.isPlaying.toggle()
    }
    @IBAction func onBookNowTapped(_ sender: Any) {
        
        let cateogoryName = (DataManager.getLanguage == Language.arabic.rawValue ? viewModel?.cellData.name_ar : viewModel?.cellData.name) ?? ""
        self.delegate?.onArtistSelected(category: String(viewModel?.cellData.id ?? -1), artistyType: (viewModel?.cellData.artistType ?? ""),categoryName: cateogoryName, categoryrole_id: viewModel?.cellData.role_id ?? 0)
        
    }
    //MARK:- Configure Singer View
    func configureUIForCell(){
        videoPlayerView.delegate = self
        if videoPlayerView.isPlaying{
            playButtonImageView.image = UIImage(named: "play_circle")
        }else{
            playButtonImageView.image = UIImage(named: "pause_circle")
        }
        playButtonImageView.isHidden = true
        playPauseButton.isEnabled = false
        bookNowButton.configureButtonUI(backgroundColor: nil, borderRadius: 10, borderColor: .white, borderWidth: 2)
        contentView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onCellTapped(){
        if viewModel?.cellData.type != "image"{
        playButtonImageView.isHidden.toggle()
            playPauseButton.isEnabled = !playButtonImageView.isHidden}
    }
    
    func didStartedPlaying() {
        playButtonImageView.isHidden = false
        playPauseButton.isEnabled = true
    }

}





