//
//  FormDropDownAuth.swift
//  ArtStation
//
//  Created by M.Rafi on 6/1/21.
//

import UIKit
import DropDown

protocol onDropDownGainFocaus{
     func didgainFocaus()
}


@IBDesignable
class FormDropDownPackage: UIView {

    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
    @IBOutlet var dividerView: UIView!
    let viewIdentifier = "FormDropDownViewPackage"
    @IBOutlet weak var dropdownAncherImageview:UIImageView!
    @IBOutlet weak var DropDownTitle:UILabel!
    
    @IBOutlet weak var textInputFeild: UITextField!
    @IBOutlet weak var separatorConstraints: NSLayoutConstraint!
    
    var delegate: onDropDownGainFocaus?
    var holdingController : UIViewController?
    var dropDown : DropDown = DropDown()
    var dropDownDataSource : [String] = []{
        didSet{
            dropDown.dataSource = dropDownDataSource
        }
    }
    
    @IBInspectable
    var setDividerColor:UIColor = UIColor.white{
        didSet{
            dividerView.backgroundColor = setDividerColor
        }
    }
    
    @IBInspectable
    var setTitle:String = ""{
        didSet{
            DropDownTitle.text = setTitle
            layoutSubviews()
            layoutIfNeeded()
        }
    }
    
    
    @IBInspectable
    var anchorImage:UIImage = UIImage(named: "ic_keyboard_arrow_right_24px") ?? UIImage.init(systemName: "arrowtriangle.down.fill") as! UIImage{
        didSet{
            dropdownAncherImageview.image = anchorImage
            layoutSubviews()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var selectOptionColor:UIColor = UIColor.white{
        didSet{
            textInputFeild.textColor = selectOptionColor
            layoutSubviews()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var separatorHeight:CGFloat = 1{
        didSet{
            self.separatorConstraints.constant = separatorHeight
            layoutSubviews()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var viewBorderWidth:CGFloat = 0{
        didSet{
            self.contentView.layer.borderWidth = viewBorderWidth
            layoutSubviews()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var viewBorderRadius:CGFloat = 0{
        didSet{
            self.contentView.layer.cornerRadius = viewBorderRadius
            layoutSubviews()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var viewBorderColor:UIColor = UIColor.clear{
        didSet{
            self.contentView.layer.borderColor = viewBorderColor.cgColor
            layoutSubviews()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var placeHolderText : String = "" {
        didSet{
            textInputFeild.attributedPlaceholder = NSAttributedString(string: placeHolderText,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            layoutSubviews()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var placecHolderTextColor: UIColor = UIColor.white{
        didSet{
            textInputFeild.attributedPlaceholder = NSAttributedString(string: placeHolderText,attributes: [NSAttributedString.Key.foregroundColor: placecHolderTextColor])
            layoutSubviews()
            layoutIfNeeded()
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
            let customFontDropDown:UIFont = UIFont.init(name: "Almarai-Regular", size: 12.0)!
           
            textInputFeild.font = customFont
            yourTextField.font = customFont
            dropDown.textFont = customFontDropDown
        }
        else
        {
            textInputFeild.textAlignment = .left
            let yourTextField = UITextField()
            let customFont:UIFont = UIFont.init(name: "Poppins-Medium", size: 16.0)!
            let customFontDropDown:UIFont = UIFont.init(name: "Poppins-Medium", size: 12.0)!
           
            yourTextField.font = customFont
            dropDown.textFont = customFontDropDown
            
        }
        
        addSubview(contentView)
        dropDown.anchorView = self
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textInputFeild.text = item
        }
        
        if DataManager.getLanguage == Language.arabic.rawValue{
      
            dropDown.customCellConfiguration =  { (index, item, cell) in
            cell.optionLabel.textAlignment = .right
        }}
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
    }

    @IBAction func dropDownIconTapped(_ sender: Any) {
        textInputFeild.resignFirstResponder()
        if dropDown.isHidden {
            delegate?.didgainFocaus()
            dropDown.show()
            self.holdingController?.view.endEditing(true)
            self.holdingController?.resignFirstResponder()
            
        }else{
            dropDown.hide()
        }
    }
    
    func setDataForDropDown(from list : [String]? = nil,fromApi :(()->Void)? = nil){
        if let listData = list{
            dropDown.dataSource = listData
        }
        fromApi?()
    }
    
    
}
