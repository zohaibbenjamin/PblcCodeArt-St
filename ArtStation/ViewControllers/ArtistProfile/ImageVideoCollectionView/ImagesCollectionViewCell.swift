//
//  ImagesCollectionViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 12/16/21.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artistImageView: UIImageView!
    func configureCellWithImage(url : String){
        
        Utils.setImageTo(imageView: artistImageView, imageName: url, placeholderImage: "")
    }
}
