//
//  ImagesGridCollectionViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 6/16/21.
//

import UIKit



class ImagesGridCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var playbuttonDisplay:UIImageView! // just for showing videos for user interface
    
    func configureCellWithImage(url : String){
        
        Utils.setImageTo(imageView: artistImageView, imageName: url, placeholderImage: "")
        
    }
    
    func configureCellWithImageNVideo(url : String){
        debugPrint(url)
        self.playbuttonDisplay.isHidden = false
        let videoId = url.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
        let urlImg = "https://img.youtube.com/vi/\(videoId)/0.jpg"
        artistImageView.contentMode = .scaleToFill
        Utils.setImageDirect(imageView: artistImageView, imageName: urlImg, placeholderImage: "")
    }
}
