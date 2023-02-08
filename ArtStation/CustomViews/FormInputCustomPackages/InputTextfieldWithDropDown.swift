//
//  InputTextfieldWithDropDown.swift
//  ArtStation
//
//  Created by Apple on 08/06/2021.
//

protocol ProtocolResignKeyboard {
    func resignFirstResp()
}

import UIKit
    
class InputTextfieldWithDropDown: UIView,UITextFieldDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgViewTrailingCOnst: NSLayoutConstraint!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var imgDropDown: UIImageView!
    var delegateResignKeyboard:ProtocolResignKeyboard?
    @IBInspectable
    var cornerRadius : Float = 16{
                didSet{
            layer.cornerRadius = CGFloat(cornerRadius)
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

    @IBAction func btnClick(_ sender: Any) {
        self.delegateResignKeyboard?.resignFirstResp()
        self.txtField.resignFirstResponder()
    }
    
    func initView(){
        
        Bundle.main.loadNibNamed("textfieldWIthDropDown"+UIManager.ifArabiclanguage(), owner: self, options: nil)
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.init(red: 194/255, green: 194/255, blue: 194/255, alpha: 1).cgColor
        
        txtField.delegate = self
        txtField.setNeedsLayout()
       // txtField.frame = CGRect.init(x: 5, y: 0, width: self.bounds.width, height:self.frame.height)
        print("item width ::::::::",self.bounds.width)
        contentView.frame = self.bounds
        addSubview(contentView)
        
        
    }
    
    @IBInspectable
    var isNumaric:Bool = false{
        didSet{
            self.txtField.keyboardType = .phonePad
            self.addDoneButtonOnKeyboard()
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default

        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))

        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)

        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()

        self.txtField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.txtField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtField.resignFirstResponder()
    }
    
    func setupCurrentSchemeOnlyLabelWithoutDrop(txtForPlaceHolder:String,txtLabel:String){
       
            btnDropDown.isHidden=true
            imgDropDown.isHidden=true
            txtField.isEnabled=false
            if txtLabel.count>0
            {
                txtField.text=txtLabel
            }
            else
            {
                txtField.placeholder=txtForPlaceHolder
            }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     //   return range.location < 10
        let maxLength = 30
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    
    func setupCurrentScheme(isOnlyTextfield:Bool,txtForPlaceHolder:String,txtLabel:String){
        if isOnlyTextfield
        {
            btnDropDown.isHidden=true
            imgDropDown.isHidden=true
            txtField.isEnabled=true
            if txtLabel.count>0
            {
                txtField.text=txtLabel
            }
            else
            {
                txtField.placeholder=txtForPlaceHolder
            }
        }
        else
        {
            btnDropDown.isHidden=false
            imgDropDown.isHidden=false
            txtField.isEnabled=false
            if txtLabel.count>0
            {
                txtField.text=txtLabel
            }
            else
            {
                txtField.placeholder=txtForPlaceHolder
            }
        }
    }

}
