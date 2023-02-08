//
//  PackageCollectionViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 6/3/21.
//

import UIKit

class PackageCollectionViewCell: UICollectionViewCell {
    
    //MARK:- IB Refrences
    @IBOutlet weak var placeButton: UIButton!
    
    
    //MARK:- Configures Cell UI
    func configureCellUI(buttonTitle : String){
        placeButton.configureButtonUI(backgroundColor: .white, fontColor: UIColor.init(named: "booking_waiting_button_color")!, borderColor: nil)
        placeButton.setTitle(buttonTitle, for: .normal)
        
    }
    
    
}
