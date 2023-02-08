//
//  HomepageCollectionViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 6/2/21.
//

import UIKit
import SDWebImage


//MARK:- Musician Type
enum ArtistType : String{
    case solo = "solo"
    case band = "band"
    case both = "both"
}
protocol HompepageCollectionViewDelegate {
    func onArtistSelected(category : String,artistyType : String,categoryName: String,categoryrole_id:Int)
}
class HomepageCollectionViewCell: UICollectionViewCell, VideoPlayerViewDelegate {
    func playerStatusChanged(status: Bool) {
        
    }
    
    
    @IBOutlet weak var playPauseButton: UIButton!
    //MARK:- IB Refrences
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var cellBackgroundImage: UIImageView!
    @IBOutlet weak var buttonContainer: UIStackView!
    @IBOutlet weak var categoryHeadlineQuestion:UILabel! // what kind of artist you ar looking for?
    @IBOutlet weak var musicianTypeLabel: UILabel!
    @IBOutlet weak var bandButton: UIButton!
    @IBOutlet weak var soloButton: UIButton!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    let dJButton = UIButton()
   
    var delegate : HompepageCollectionViewDelegate?
    
    //MARK:- Data
    var viewModel : HomepageCollectionViewCellViewModel?{
        didSet{
            
            if DataManager.getLanguage == Language.arabic.rawValue{
                musicianTypeLabel.text = viewModel?.cellData.name_ar}
            else{
            musicianTypeLabel.text = viewModel?.cellData.name
            }
            
            let backgroundImage = viewModel?.cellData.type == "image" ? viewModel?.cellData.image : viewModel?.cellData.thumbnail
            debugPrint(backgroundImage,"backgroundImage")
            cellBackgroundImage.sd_setImage(with:URL(string:String.init(format: "%@%@",ConfigurationManager.shared.getBaseURLImage().absoluteString,backgroundImage ?? "")), placeholderImage: UIImage.init(named: "placeholder_main"))
            
            configureUIForCell()
        }
    }
    
    
    
    //MARK:- PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in buttonContainer.arrangedSubviews{
            view.removeFromSuperview()
        }
        videoPlayerView.player?.pause()
        videoPlayerView.player = nil
        videoPlayerView.playerLayer.player = nil
        buttonContainer.addArrangedSubview(bandButton)
        buttonContainer.addArrangedSubview(soloButton)
        
    }
    
    //MARK:- Configure Singer View
    func configureUIForCell(){
        videoPlayerView.delegate = self
        if videoPlayerView.isPlaying{
            playPauseImageView.image = UIImage(named: "play_circle")
        }else{
            playPauseImageView.image = UIImage(named: "pause_circle")
        }
        playPauseImageView.isHidden = true
        playPauseButton.isEnabled = false
        
        bandButton.configureButtonUI(backgroundColor: nil, borderRadius: 10, borderColor: .white, borderWidth: 2)
        
        soloButton.configureButtonUI(backgroundColor: nil, borderRadius: 10, borderColor: .white, borderWidth: 2)
        contentView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onCellTapped(){
            if viewModel?.cellData.type != "image"{
                playPauseImageView.isHidden.toggle()
                playPauseButton.isEnabled = !playPauseImageView.isHidden
                
            }
    }
    
    @IBAction func onSoloButtonTapped(_ sender: Any) {
        
        let cateogoryName = (DataManager.getLanguage == Language.arabic.rawValue ? viewModel?.cellData.name_ar : viewModel?.cellData.name) ?? ""
        self.delegate?.onArtistSelected(category: String(viewModel?.cellData.id ?? -1), artistyType: ArtistType.solo.rawValue, categoryName: cateogoryName, categoryrole_id: viewModel?.cellData.role_id ?? 0)
    }
    
    @IBAction func onBandButtonTapped(_ sender: Any) {
        let categoryName = (DataManager.getLanguage == Language.arabic.rawValue ? viewModel?.cellData.name_ar : viewModel?.cellData.name) ?? ""
        self.delegate?.onArtistSelected(category: String(viewModel?.cellData.id ?? -1),artistyType:viewModel?.cellData.role_id == 3 ? ArtistType.band.rawValue : ArtistType.band.rawValue, categoryName: categoryName, categoryrole_id: viewModel?.cellData.role_id ?? 0)
   
    }
    
    @IBAction func onPlayPauseButtonTapped(_ sender: Any) {
        if videoPlayerView.isPlaying{
            DispatchQueue.main.async{
                self.videoPlayerView.isHidden = true
            
                self.videoPlayerView.player?.pause()
                self.playPauseImageView.image = UIImage(named: "play_circle")
            }
        }else{
            DispatchQueue.main.async{
                self.videoPlayerView.isHidden = false
            
                self.videoPlayerView.player?.play()
                self.playPauseImageView.image = UIImage(named: "pause_circle")}
        }
        videoPlayerView.isPlaying.toggle()
    }
    
    func didStartedPlaying() {
        videoPlayerView.player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
        playPauseImageView.isHidden = false
        playPauseButton.isEnabled = true
    }
    
}


//MARK:- ViewModel Decleration
class HomepageCollectionViewCellViewModel{
    
    var cellData : MusicArtistCategory
    init(data : MusicArtistCategory){
        cellData = data
    }
}


