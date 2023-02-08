//
//  ArtStationForceUpdateAlert.swift
//  ArtStation
//
//  Created by Andpercent on 04/04/2022.
//

import Foundation
import UIKit


class ArtStationForceUpdateAlertView:UIView{
    
    enum ForceupdateAlertType{
        case Forceupdate
        case optionalupdate
    }
    var onOkButtonTapped: (() -> Void)?
    var message: String?{
        didSet{
            self.messageLabel.text = Utils.localizedText(text: message ?? "")
        }
    }
    
    var alertType: ForceupdateAlertType?{
        didSet{
            switch alertType {
            case .Forceupdate:
                setupAlertView()
            case .optionalupdate:
                setupoptionUpdate()
            case .none:
                break
            }
        }
    }
    
    
    @IBOutlet weak var oKButton: UIButton!
    @IBOutlet weak var noThnks:UIButton!
    
    @IBOutlet weak var alertContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var contentView: UIView!
    var viewIdentifier = "ForceAlertView"
    
    //MARK:- Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    @IBAction func onOkTapped(_ sender: Any) {
        onOkButtonTapped?()
        removeFromSuperview()
    }
    
    @IBAction func onNothanksTapped(_ sender:Any){
        removeFromSuperview()
    }
    
    func initSubviews() {
      
        let nib = UINib(nibName: viewIdentifier, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        UIManager.makeShadow(view: alertContainerView)
        oKButton.layer.cornerRadius = oKButton.frame.size.height/2
        noThnks.layer.cornerRadius = noThnks.frame.size.height/2
        addSubview(contentView)
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            oKButton.setTitle(Utils.localizedText(text: "OK"), for: .normal)
            
            self.messageLabel.font = UIFont(name: "Almarai-Bold", size: 16)
            
            self.oKButton.titleLabel?.font = UIFont(name: "Almarai-Bold", size: 14)
        }
    }
    
    func setupAlertView(){
        
    }
    
    func setupoptionUpdate(){
        self.noThnks.isHidden = false
//        alertContainerView.backgroundColor = UIColor(named: "ErrorAlertBackgroundColor")!
    }

}
