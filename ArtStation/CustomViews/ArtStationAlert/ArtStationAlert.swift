//
//  ArtStationAlert.swift
//  ArtStation
//
//  Created by MamooN_ on 12/9/21.
//

import UIKit

class ArtStationAlert: UIView {

    enum AlertType{
        case alert
        case error
    }
    var onOkButtonTapped: (() -> Void)?
    var message: String?{
        didSet{
            self.messageLabel.text = Utils.localizedText(text: message ?? "")
        }
    }
    
    var alertType: AlertType?{
        didSet{
            switch alertType {
            case .alert:
                setupAlertView()
            case .error:
                setupErrorView()
            case .none:
                break
            }
        }
    }
    
    @IBOutlet weak var oKButton: UIButton!
    @IBOutlet weak var alertContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var contentView: UIView!
    var viewIdentifier = "AlertView"
    
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
    
    func initSubviews() {
      
        let nib = UINib(nibName: viewIdentifier, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        UIManager.makeShadow(view: alertContainerView)
        oKButton.layer.cornerRadius = oKButton.frame.size.height/2
        addSubview(contentView)
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            oKButton.setTitle(Utils.localizedText(text: "OK"), for: .normal)
            
            self.messageLabel.font = UIFont(name: "Almarai-Bold", size: 16)
            
            self.oKButton.titleLabel?.font = UIFont(name: "Almarai-Bold", size: 14)
        }
    }
    
    func setupAlertView(){
        
    }
    
    func setupErrorView(){
        alertContainerView.backgroundColor = UIColor(named: "ErrorAlertBackgroundColor")!
    }

}
