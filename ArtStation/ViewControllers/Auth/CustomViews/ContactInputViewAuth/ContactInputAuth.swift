//
//  ContactInputAut.swift
//  ArtStation
//
//  Created by MamooN_ on 5/31/21.
//

import UIKit


@IBDesignable
class ContactInputAuth: UIView,UITextFieldDelegate {


    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textInputFeild: UITextField!
  
 
    
    
    //MARK:- DATA
    let viewIdentifier = "ContactInputViewAuth"
    
    
    //MARK:- IB Properties
    @IBInspectable
    var placeHolderText : String = "" {
        didSet{
            self.textInputFeild.placeholder = placeHolderText
        }
    }
    
    @IBInspectable
    var inputText : String = ""{
        didSet{
            self.textInputFeild.text = inputText
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
        textInputFeild.attributedPlaceholder = NSAttributedString(string: "placeholder text",
                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textInputFeild.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        textInputFeild.delegate = self
        textInputFeild.keyboardType = UIKeyboardType.asciiCapableNumberPad
        
        addSubview(contentView)
    }

 
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.count ?? 0) > 0{
            textField.text = textField.text?.toPhoneNumber()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField==textInputFeild
        {
            let characterset = CharacterSet(charactersIn: "0123456789")
            
            
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
               return false
            }
            else
            {
                return true
            }
        }
        
        return true
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }

}

extension String {
public func toPhoneNumber() -> String {
    return self.replacingOccurrences(of: "(\\d{2})(\\d{3})(\\d+)", with: "$1 $2 $3", options: .regularExpression, range: nil)
}}
