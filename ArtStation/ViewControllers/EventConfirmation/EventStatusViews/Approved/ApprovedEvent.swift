//
//  ApprovedEvent.swift
//  ArtStation
//
//  Created by MamooN_ on 6/24/21.
//

import UIKit
protocol ProtocolPayNow {
    func btnPayNowClick()
    func showAlertwithMessage(string : String)
}

class ApprovedEvent: UIView {

    
    
    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var timerView: UILabel!
    @IBOutlet weak var payNowButton: UIButton!
    
    var timer : Timer?
    var timerHour = 1
    var timerMinutes = 1
    var timerSeconds = 10
    var delegatePayNow:ProtocolPayNow?
    let viewIdentifier = "ApprovedEventView"
    @IBOutlet weak var statusLabel: UILabel!
    
    
    let startTime: Date = Date()
    var duration: TimeInterval?{
        didSet{
            if duration! > 0 {
                scheduleTimer()
                
            }
            else{
                payNowButton.isEnabled = false
                statusLabel.text = Utils.localizedText( text: "Your booking has been expired")
                statusLabel.textColor = UIColor.red
                self.delegatePayNow?.showAlertwithMessage(string:"Your booking has been expired" )
            }
        }
    }
    
    let formatter = DateComponentsFormatter()
    var runningTime: TimeInterval = 0

    var time: Date = Date()
    let cal: Calendar = Calendar.current
    
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
        let nib = UINib(nibName: viewIdentifier + UIManager.ifArabiclanguage(), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
     
        
    }
    
    @IBAction func btnPayNowClick(_ sender: Any)
    {
        delegatePayNow?.btnPayNowClick()
    }
    
    func scheduleTimer(){
        formatter.allowedUnits = [.hour, .minute,.second]
        formatter.zeroFormattingBehavior = .dropLeading
        formatter.unitsStyle = .abbreviated

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
       
    }



@objc func updateCounter() {

        time = cal.date(byAdding: .second, value: 1, to: time)!
        runningTime = time.timeIntervalSince(startTime)
        debugPrint(runningTime)
        if runningTime < (duration ?? 0)  {
            if DataManager.getLanguage == Language.english.rawValue{
        timerView.text = Utils.localizedText(text: "Complete your payment in ") +  formatter.string(from: duration! - runningTime)!
            }else{
//                timerView.text =   formatter.string(from: duration! - runningTime)! + " " + Utils.localizedText(text: "Complete your payment in ")
//
                timerView.text = Utils.localizedText(text: "Complete your payment in ") + " " + formatter.string(from: duration! - runningTime)!
                    
            }
        }else{
            debugPrint("HERE")
            timer?.invalidate()
            duration = 0
        }
        
  


}
    
}
