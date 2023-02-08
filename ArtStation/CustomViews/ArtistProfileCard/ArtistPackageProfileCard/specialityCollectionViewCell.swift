//
//  specialityCollectionViewCell.swift
//  ArtStation
//
//  Created by Andpercent on 21/01/2022.
//

import UIKit

class specialityCollectionViewClass: UICollectionViewCell {

    @IBOutlet weak var specialityLable: UILabel!
    @IBOutlet weak var view:UIView!
    
    //MARK:- Configures Cell UI
    func configureCellUI(lableTitle : String){
         let str = lableTitle
         specialityLable.text = lableTitle
         specialityLable.sizeToFit()
         specialityLable.textAlignment = .center
         view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "booking_canceled_button_color")?.cgColor
         view.layer.cornerRadius =  self.frame.height/2
        view.layer.opacity = 0.9
    }
}
