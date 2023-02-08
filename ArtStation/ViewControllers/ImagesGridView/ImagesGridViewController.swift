//
//  ImagesGridViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/16/21.
//

import UIKit
import youtube_ios_player_helper

enum GridContentType{
    case images
    case videos
}

class ImagesGridViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewVideoMain: UIView!
    @IBOutlet weak var nextPhotoBtnImage:UIImageView!
    @IBOutlet weak var previusePhotoBtnImage:UIImageView!
    @IBOutlet weak var nextPhotoBtn:UIButton!
    @IBOutlet weak var prePhotoBtn:UIButton!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var titleText:UILabel!
    @IBOutlet weak var titleImage:UIImageView!
    
    var contentType : GridContentType?
    var dataSource : [String]?
    let cellIdentifier = "image_grid_cell"
    var photoIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.isHidden = true
        closeButton.configureButtonUI(backgroundColor: nil, borderRadius: 10, borderColor: .white, borderWidth: 2)
        closeButton.setTitle(Utils.localizedText(text: "Close"), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch contentType {
        case .images:
            self.titleText.text = Utils.localizedText(text:"Images")
            self.titleImage.image = UIImage(named: "picture")
        case .videos:
            self.titleText.text = Utils.localizedText(text:"Videos")
            self.titleImage.image = UIImage(named: "movie")
            break
        default:
            break
        }
    }
    
    
    @IBAction func nextPhoto(_ sender:UIButton){
        self.nextPhotoinList()
    }
    
    @IBAction func previusePhoto(_ sender:UIButton){
        self.previousPhotoinList()
    }
    

    @IBAction func onCloseButtonTapped(_ sender: Any) {
        if imageView.isHidden && viewVideoMain.isHidden{
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        ytPlayerView.stopVideo()
        self.imageView.isHidden = true
        self.viewVideoMain.isHidden = true
        nextPhotoBtnImage.isHidden = true
        nextPhotoBtn.isHidden = true
        previusePhotoBtnImage.isHidden = true
        prePhotoBtn.isHidden = true
    }
}


extension ImagesGridViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImagesGridCollectionViewCell
      
        switch contentType {
        case .images:
            cell.configureCellWithImage(url: dataSource![indexPath.row])
        case .videos:
            cell.configureCellWithImageNVideo(url: dataSource![indexPath.row])
            break
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch contentType {
        case .images:
            return CGSize(width: collectionView.frame.width/2.05, height: collectionView.frame.width/2.05)
        case .videos:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/2.05)
            
        default:
            return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch contentType{
        case .videos:
            let vc = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: StoryboardId.fullScreenImageViewControllerId, viewController: FullScreenImageViewViewController.self)
            
            vc.dataSource = self.dataSource
            vc.photoIndex = indexPath.row
            vc.contentType = .videos
            self.present(vc, animated: true, completion: nil)
        case .images:
            let vc = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: StoryboardId.fullScreenImageViewControllerId, viewController: FullScreenImageViewViewController.self)
            
            vc.dataSource = self.dataSource
            vc.photoIndex = indexPath.row
            vc.contentType = .images
            self.present(vc, animated: true, completion: nil)
        
        default:
            debugPrint("Default")
        }
   
        
    }
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
    
    func nextPhotoinList(){
        let count = (dataSource?.count ?? 0)
        if self.photoIndex < count - 1{
        self.photoIndex += 1
            Utils.setImageTo(imageView: imageView, imageName: dataSource![self.photoIndex], placeholderImage: "")
        }
        updatenextprebtns()
    }
    
    func previousPhotoinList(){
        if self.photoIndex > 0{
            self.photoIndex -= 1
            Utils.setImageTo(imageView: imageView, imageName: dataSource![self.photoIndex], placeholderImage: "")
        }
        updatenextprebtns()
    }
    
    func updatenextprebtns(){
        if dataSource?.count ?? 0 > 0{
            let count = dataSource?.count ?? 0
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
