//
//  Checkbox.swift
//  ArtStation
//
//  Created by MamooN_ on 6/8/21.
//

import UIKit

class Checkbox: UIButton {

    
    @IBInspectable
    var isChecked : Bool = false {
        didSet{
            if isChecked{
                setImage(UIImage(systemName: "checkmark")?.withTintColor(UIColor.systemPink),for: .normal)
            }
            else{
                setImage(nil, for: UIControl.State.normal)
            }
        }
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ConfigurePrimaryButton()
   
    }
    
    func ConfigurePrimaryButton() {
        
        self.setImage(nil, for: UIControl.State.normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigurePrimaryButton()
    }
    
   

}
