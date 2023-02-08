//
//  ArtistPackageCollectionViewCell.swift
//  ArtStation
//
//  Created by Apple on 07/06/2021.
//

import UIKit

protocol ProtocolPlaceSelection {
    func callMain(v:String)
}

class ArtistPackageCollectionViewCell:UICollectionViewCell {
    
    //MARK:- IB Refrences
    @IBOutlet weak var placeButton: UIButton!
    var delegateM:ProtocolPlaceSelection?
    var stringName = ""
    var placeNameToSend: String?
    //MARK:- Configures Cell UI
    func configureCellUI(placeName : String){
        stringName = placeName
       
   
        if DataManager.requestedPlaces == placeName
        {
           // placeButton.setTitle(placeName, for: .normal)
            placeButton.setTitle(placeName, for: .normal)
            placeButton.isSelected = true
            placeButton.configureButtonUI(backgroundColor: UIColor.init(named: "booking_waiting_button_color"), fontColor: .white, borderRadius: placeButton.frame.height/2, borderColor: UIColor.gray, borderWidth: 1)
           
        }
        else
        {
            
            placeButton.configureButtonUI(backgroundColor: .white, fontColor: UIColor.init(named: "booking_waiting_button_color")!, borderRadius: placeButton.frame.height/2, borderColor:  UIColor.gray, borderWidth: 1)
            placeButton.isSelected = false
            placeButton.setTitle(placeName, for: .normal)
        }
        
    }
    
    @IBAction func btnClick(_ sender: Any) {
        DataManager.requestPlaceToBeSent = placeNameToSend!
        DataManager.requestedPlaces = stringName
        delegateM?.callMain(v: stringName)
        
        debugPrint(stringName,placeNameToSend!)
    }
    
    
    
}
