//
//  CardView.swift
//  ArtStation
//
//  Created by MamooN_ on 6/3/21.
//

import UIKit

class CardViewV2: UIView {

    var cornersSelected : CACornerMask = []
    @IBInspectable
    var topLeftCornerRadius : Float = 0{
        didSet{
            layer.cornerRadius = CGFloat(topLeftCornerRadius)
            cornersSelected.insert(CACornerMask.layerMinXMinYCorner)
            layer.maskedCorners = cornersSelected
        }
    }
    
    @IBInspectable
    var topRightCornerRadius : Float = 0{
        didSet{
            layer.cornerRadius = CGFloat(topRightCornerRadius)
            cornersSelected.insert(.layerMaxXMinYCorner)
            layer.maskedCorners = cornersSelected
        }
    }
    
    @IBInspectable
    var bottomLeftcornerRadius : Float = 0{
        didSet{
            layer.cornerRadius = CGFloat(bottomLeftcornerRadius)
            cornersSelected.insert(CACornerMask.layerMinXMaxYCorner)
            layer.maskedCorners = cornersSelected
        }
    }
    
    @IBInspectable
    var bottomRightcornerRadius : Float = 0{
        didSet{
            layer.cornerRadius = CGFloat(bottomRightcornerRadius)
            cornersSelected.insert(.layerMaxXMaxYCorner)
            layer.maskedCorners = cornersSelected
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
      
    }

}
