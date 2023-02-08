//
//  SelectLanguage.swift
//  ArtStation
//
//  Created by MamooN_ on 5/20/21.
//

import UIKit
import SwiftUI

enum Language : String{
    case english = "en"
    case arabic = "ar"
}

protocol ChangeLanguageDelegate{
    func onLanguageChanged()
}

class SelectLanguage: UIView {
    
    //MARK:- IB Refrences
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
 
    //MARK:- Data
    let viewIdentifier = "SelectLanguageView"
  
    var delegate : ChangeLanguageDelegate?
    
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
        englishButton.layer.cornerRadius = englishButton.frame.height/2
        arabicButton.layer.cornerRadius = arabicButton.frame.height/2
        addSubview(contentView)
        DataManager.getLanguage == Language.english.rawValue ? updateButtonViews(selectedButton: englishButton, unselectedButton: arabicButton) : updateButtonViews(selectedButton: arabicButton, unselectedButton: englishButton)
    }
   
    
    //MARK:- English Button Tapped
    @IBAction func onEnglishButtonTapped(_ sender: Any) {
        DataManager.appLanguage = Language.english.rawValue
        updateButtonViews(selectedButton: englishButton, unselectedButton: arabicButton)
        delegate?.onLanguageChanged()
    }
    
    //MARK:- Arabic Button Tapped
    @IBAction func onArabicButtonTapped(_ sender: Any) {
        DataManager.appLanguage = Language.arabic.rawValue
        updateButtonViews(selectedButton: arabicButton, unselectedButton: englishButton)
        delegate?.onLanguageChanged()
    }
    
    //MARK:- UpdateButtonViews
    func updateButtonViews(selectedButton : UIButton,unselectedButton: UIButton){
        selectedButton.backgroundColor = UIColor.white
        selectedButton.setTitleColor(UIColor.orange, for: .normal)
        unselectedButton.backgroundColor = .none
        unselectedButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    
}
