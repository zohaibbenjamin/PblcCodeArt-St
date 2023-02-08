//
//  FullScreenImageViewViewController.swift
//  ArtStation
//
//  Created by Andpercent on 23/12/2021.
//

import UIKit
import youtube_ios_player_helper

class FullScreenImageViewViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewVideoMain: UIView!
    @IBOutlet weak var nextPhotoBtnImage:UIImageView!
    @IBOutlet weak var previusePhotoBtnImage:UIImageView!
    @IBOutlet weak var nextPhotoBtn:UIButton!
    @IBOutlet weak var prePhotoBtn:UIButton!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    
    var contentType : GridContentType?
    var dataSource : [String]?
    let cellIdentifier = "image_grid_cell"
    var photoIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.configureButtonUI(backgroundColor: nil, borderRadius: 10, borderColor: .white, borderWidth: 2)
        closeButton.setTitle(Utils.localizedText(text: "Close"), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.contentType == .images{
            self.viewVideoMain.isHidden = true
            self.imageView.isHidden = false
            Utils.setImageTo(imageView: imageView, imageName: dataSource![self.photoIndex], placeholderImage: "")
            updatenextprebtns()
        }else{
            let videoId = dataSource?[photoIndex].replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
                 ytPlayerView.load(withVideoId:videoId ?? "")
            
            self.viewVideoMain.isHidden = false
            self.imageView.isHidden = true
        }
    }
    
    
    @IBAction func nextPhoto(_ sender:UIButton){
        self.nextPhotoinList()
    }
    
    @IBAction func previusePhoto(_ sender:UIButton){
        self.previousPhotoinList()
    }
    

    @IBAction func onCloseButtonTapped(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        
//        ytPlayerView.stopVideo()
//        self.imageView.isHidden = true
//        self.viewVideoMain.isHidden = true
//        nextPhotoBtnImage.isHidden = true
//        nextPhotoBtn.isHidden = true
//        previusePhotoBtnImage.isHidden = true
//        prePhotoBtn.isHidden = true
    }


//extension FullScreenImageViewViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImagesGridCollectionViewCell
//
//        switch contentType {
//        case .images:
//            cell.configureCellWithImage(url: dataSource![indexPath.row])
//        case .videos:
//            cell.configureCellWithImageNVideo(url: dataSource![indexPath.row])
//            break
//        default:
//            break
//        }
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch contentType {
//        case .images:
//            return CGSize(width: collectionView.frame.width/2.05, height: collectionView.frame.width/2.05)
//        case .videos:
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/2.05)
//
//        default:
//            return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2.5)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch contentType{
//        case .videos:
//            let videoId = dataSource?[indexPath.row].replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
//            viewVideoMain.isHidden = false
//            self.closeButton.isHidden = false
//                ytPlayerView.load(withVideoId:videoId ?? "")
//          // playInYoutube(youtubeId: videoId ?? "")
//        case .images:
//            Utils.setImageTo(imageView: imageView, imageName: dataSource![indexPath.row], placeholderImage: "")
//            self.photoIndex = indexPath.row
//            self.imageView.isHidden = false
//            self.closeButton.isHidden = false
//            updatenextprebtns()
//
//        default:
//            debugPrint("Default")
//        }
   
        
   // }
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
