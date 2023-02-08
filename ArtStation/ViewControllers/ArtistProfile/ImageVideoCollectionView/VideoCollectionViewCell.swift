//
//  VideoCollectionViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 12/16/21.
//

import UIKit
import SwiftyJSON

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageView:UIImageView!
    @IBOutlet weak var imageTitle:UILabel!
    
    func configureCellWithImageNVideo(url : String){
        debugPrint(url)
        let videoId = url.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
        let urlImg = "https://img.youtube.com/vi/\(videoId)/0.jpg"
        
        //"https://www.youtube.com/watch?v=ZuTpTO7F_ck"
        
        //https://www.youtube.com/oembed?url=youtube.com/watch?v=ZuTpTO7F_ck&format=json
        
         let urlformat = "https://www.youtube.com/oembed?url=youtube.com/watch?v="
        
        guard let videourl = URL(string: urlformat+"\(videoId)"+"&format=json") else { return  }
        
        debugPrint(videourl)
        
        
//        APIManagerBase.sharedInstance.getRequestWithAlmofairWithOut(route: videourl, parameters: Dictionary()) { data in
//            do {
//            let parsedJSON = try JSONDecoder().decode(JSON.self, from: data!)
//                debugPrint(parsedJSON)
//                self.imageTitle.text = parsedJSON["title"].description
//            }
//                catch {
//            print(error)
//                    }
//        } failure: { error in
//            
//        }
        
        ImageView.contentMode = .scaleToFill
        Utils.setImageDirect(imageView: ImageView, imageName: urlImg, placeholderImage: "")
    }
}
