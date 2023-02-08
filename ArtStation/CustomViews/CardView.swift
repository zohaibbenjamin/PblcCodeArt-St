//
//  CardView.swift
//  ArtStation
//
//  Created by MamooN_ on 6/3/21.
//

import UIKit

class CardView: UIView {

    @IBInspectable
    var cornerRadius : Float = 16{
        didSet{
            layer.cornerRadius = CGFloat(cornerRadius)
            layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        }
    }
    
    
  
    
    @IBInspectable var borderColorForView : UIColor?{
        didSet{
            layer.borderColor = borderColorForView?.cgColor
        }
    }
    
    @IBInspectable var borderWidthForView : CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidthForView
        }
    }
    
    
    
    
    
    //MARK:- Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView(){
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
   
    }

}
