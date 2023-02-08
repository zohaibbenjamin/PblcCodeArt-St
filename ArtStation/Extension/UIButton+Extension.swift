//
//  UIButton+Extension.swift
//  ArtStation
//
//  Created by MamooN_ on 5/31/21.
//

import UIKit

extension UIButton{
    
    func configureButtonUI(backgroundColor : UIColor?,fontColor : UIColor = .white,borderRadius : CGFloat = 0 ,borderColor:UIColor?,borderWidth : CGFloat = 0){
        
        self.backgroundColor = backgroundColor ?? .none
        self.setTitleColor(fontColor, for: .normal)
        self.layer.borderWidth = borderWidth 
        self.layer.borderColor = borderColor?.cgColor ?? .none
        self.layer.cornerRadius = borderRadius
        
    }
}
