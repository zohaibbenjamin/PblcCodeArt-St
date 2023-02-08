//
//  CustomDatePicker.swift
//  ArtStation
//
//  Created by MamooN_ on 6/1/21.
//

import UIKit

protocol CustomDatePickerDelegate{
    func onCalenderIconTapped()
}
@IBDesignable
class CustomDatePicker: UIView {

    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textInputFeild: UITextField!
    
    
    var delegate : CustomDatePickerDelegate?
    let viewIdentifier = "CustomDatePickerView"
    
    @IBInspectable
    var placeHolderText : String = "" {
        didSet{
            textInputFeild.attributedPlaceholder = NSAttributedString(string: placeHolderText,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
    
    
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
        let nib = UINib(nibName: viewIdentifier+UIManager.ifArabiclanguage(), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        if DataManager.getLanguage == "ar"
        {
            textInputFeild.textAlignment = .right
            let yourTextField = UITextField()
            let customFont:UIFont = UIFont.init(name: "Almarai-Regular", size: 16.0)!
            textInputFeild.font = customFont
            yourTextField.font = customFont
        }
        else
        {
            textInputFeild.textAlignment = .left
            let yourTextField = UITextField()
            let customFont:UIFont = UIFont.init(name: "Poppins-Medium", size: 16.0)!
            yourTextField.font = customFont
        }
        addSubview(contentView)
    }

    @IBAction func onCalenderIconTapped(_ sender: Any) {
        self.delegate?.onCalenderIconTapped()
    }
}
