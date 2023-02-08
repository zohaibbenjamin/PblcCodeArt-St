//
//  FormTextInput.swift
//  ArtStation
//
//  Created by MamooN_ on 5/29/21.
//

import UIKit

protocol FormTextInputDelegate{
    
    func onTextUpdated(updatedText : String)
    func onFocusGained()
    func onFocusLost()
    
}

@IBDesignable class FormTextInput: UIView, UITextFieldDelegate {

    
    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textInputFeild: UITextField!
  
 
    //MARK:- DATA
    let viewIdentifier = "FormTextInputView"
    var delegate : FormTextInputDelegate?
    
    
    //MARK:- IB Properties
    @IBInspectable
    var placeHolderText : String = "" {
        didSet{
            textInputFeild.attributedPlaceholder = NSAttributedString(string: placeHolderText,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
        }
    }
    @IBInspectable
    var inputText : String = ""{
        didSet{
            self.textInputFeild.text = inputText
        }
    }
    @IBInspectable
    var isSecureText : Bool = false{
        didSet{
            textInputFeild.isSecureTextEntry = isSecureText
        }
    }
    @IBInspectable
    var isKeyboardRestrictedOption: Bool = false{
        didSet{
            textInputFeild.keyboardType = isKeyboardRestrictedOption ? .asciiCapable : .alphabet
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
            
        let nib = UINib(nibName: viewIdentifier, bundle: nil)
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
            
        textInputFeild.delegate = self
        addSubview(contentView)
            
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    
        
}
