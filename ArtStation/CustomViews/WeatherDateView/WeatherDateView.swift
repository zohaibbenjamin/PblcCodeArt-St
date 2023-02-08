//
//  WeatherDateView.swift
//  ArtStation
//
//  Created by MamooN_ on 6/3/21.
//

import UIKit

protocol WeatherDateViewDelegate{
    func onBackButtonTapped()
    func onChatOptionClicked()
}

class WeatherDateView: UIView {

    static var temperature : String?
    static var date : String?
    static var userName : String?
    var delegate : WeatherDateViewDelegate?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tempDateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
    var viewIdentifier = "WeatherDateView"
    var weatherDataModel = HomePageViewModel()
    
    //MARK: - whatsAppIconView Reference
    
    @IBOutlet weak var ChatView:UIView!
    
    
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
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            viewIdentifier = "WeatherDateView_ar"
        }
        let nib = UINib(nibName: viewIdentifier, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        
        backButton.configureButtonUI(backgroundColor: nil, borderRadius: backButton.frame.height/2, borderColor: .white, borderWidth: 2)
        
        userNameLabel.text=(DataManager.getUserData?.name ?? "").capitalized
        addSubview(contentView)
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        self.delegate?.onBackButtonTapped()
    }
    
    //MARK: - goto whatsapp chat
    @IBAction func whatsAppChatOptionClicked(_ sender:UIButton){
        self.delegate?.onChatOptionClicked()
    }
   
 func updateView()
{
if DataManager.WeatherData != nil{
    userNameLabel.text=(DataManager.getUserData?.name ?? "").capitalized
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM"
 
   // tempDateLabel.text="\(DataManager.WeatherData?.Temperature?.Metric?.Value ?? 0.0) ° \(DataManager.WeatherData?.Temperature?.Metric?.Unit ?? "") - \(dateFormatter.string(from: Date()))"
    let numberForImg = DataManager.WeatherData?.WeatherIcon ?? 1
    if numberForImg<10
    {
        imgView.sd_setImage(with:URL(string:String.init(format: "https://developer.accuweather.com/sites/default/files/0\(numberForImg)-s.png")), placeholderImage: UIImage.init(named: ""))
    }
    else
    {
        imgView.sd_setImage(with:URL(string:String.init(format: "https://developer.accuweather.com/sites/default/files/\(numberForImg)-s.png")), placeholderImage: UIImage.init(named: ""))
    }
   
}else{
    userNameLabel.text=(DataManager.getUserData?.name ?? "").capitalized
   // tempDateLabel.text="--° C"
   
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM"
   // tempDateLabel.text="--° C -  \(dateFormatter.string(from: Date()))"
   
    debugPrint(dateFormatter.string(from: Date()))
    imgView.sd_setImage(with:URL(string:String.init(format: "https://developer.accuweather.com/sites/default/files/31-s.png")), placeholderImage: UIImage.init(named: ""))
}
}

}


