//
//  Logo.swift
//  ArtStation
//
//  Created by MamooN_ on 5/28/21.
//

import UIKit

class Logo: UIView {

    
    
    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
 
    let viewIdentifier = "LogoView"
    
    @IBOutlet weak var logoText: UILabel!
    
    //MARK:- Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: viewIdentifier, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        if DataManager.getLanguage == Language.arabic.rawValue{
            logoText.text = "احجز فنان لمناسبتك الخاصة و غيّر جو معازيمك!"
            logoText.font = UIFont.init(name: "Almarai-Bold", size: 17.0)
        }
    }
}
