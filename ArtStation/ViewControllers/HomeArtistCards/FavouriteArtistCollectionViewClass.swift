//
//  FavouriteArtistCollectionViewCell.swift
//  ArtStation
//
//  Created by Andpercent on 24/01/2022.
//

import UIKit

protocol onDeleteButtonClickedOnFavouriteArtistCell {
    func removeFromFavouriteArtistList(artist:FavouriteArtistModel,index:Int)
    func navigatetoArtistbyId(artistId:Int)
}

class FavouriteArtistCollectionViewClass: UICollectionViewCell {
    
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var mtitle:UILabel!
    
    
    var artistData: Pinedartist = Pinedartist(id: 0, stageName: "", stageName_ar: "")
    
    var index:Int = -1
    var role_id:Int = -1
    
    var favouriteArtist: FavouriteArtistModel?
    
    var listdelegate: onDeleteButtonClickedOnFavouriteArtistCell?
    
    @IBAction func deleteButton(_sender:UIButton){
        self.listdelegate?.removeFromFavouriteArtistList(artist: self.favouriteArtist!,index: index)
    }
    
    @IBAction func delegateNavigateButton(_ sender: UIButton){
        self.listdelegate?.navigatetoArtistbyId(artistId: self.favouriteArtist!.artist_id)
    }
    
    
    override func awakeFromNib() {
        
    }
    //MARK:- Configures Cell UI
    func configureCellUI(artist : FavouriteArtistModel,index:Int){
        
        guard (artist.artists != nil) else {
            return  
        }
        
        self.favouriteArtist = artist
        self.index = index
        self.role_id = artist.artists?.role_id ?? 0
        mtitle.text = ""
        self.favouriteArtist = FavouriteArtistModel(id: 0, artist_id: artist.artist_id, category_id: artist.category_id, user_id: artist.user_id, artists: favourit_artist_Info(id: 0, role_id: artist.artists?.role_id ?? 0, artist_info: artist.artists?.artist_info))
        
       
         if DataManager.getLanguage == Language.arabic.rawValue{
             mtitle.text = artist.artists?.artist_info?[0].stageName_ar
         }else{
             mtitle.text = artist.artists?.artist_info?[0].stageName
         }
       
        mtitle.sizeToFit()
        mtitle.textAlignment = .center
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius =  self.frame.height/2
       // view.layoutSubviews()
        //self.layoutSubviews()
        //self.invalidateIntrinsicContentSize()
    }
}
