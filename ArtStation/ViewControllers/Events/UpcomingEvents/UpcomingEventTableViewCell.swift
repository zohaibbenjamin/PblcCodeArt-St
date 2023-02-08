//
//  UpcomingEventTableViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 6/22/21.
//

import UIKit

protocol UpcomingEventTableCellDelegate{
    func onDetailsButtonTapped(booking : Booking)
}
class UpcomingEventTableViewCell: UITableViewCell {

    
    //MARK:- IB Refrences
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var viewDetailsButton: UIButton!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var packageTypeLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var musicTypeLabel: UILabel!
    //MARK:- Data
    var delegate : UpcomingEventTableCellDelegate?
    var viewModel : UpcomingEventTableCellViewModel?{
        didSet{
            
            debugPrint("Data",viewModel?.booking.startDate ?? "")
            var timePostFix = "PM"
            var hour = Int(viewModel?.booking.startTime.prefix(2) ?? "12")
            if hour! <= 12{
                timePostFix = "AM"
            }else{
                hour! -= 12
            }
            var dateLabelString = (Utils.changeDateFormatTo(from: "yyyy-MM-dd", to: "dd-MMM", date: viewModel?.booking.startDate ?? "") + ", " + String(hour!) + (viewModel?.booking.startTime.dropFirst(2).dropLast(3) ?? ""))
            dateLabelString += " " + timePostFix
            dateLabel.text = dateLabelString
            orderNumLabel.text = Utils.localizedText(text: "Booking#") + String(viewModel?.booking.id ?? -999)
            
            if DataManager.getLanguage == Language.arabic.rawValue{
                
                artistNameLabel.text = viewModel?.booking.package.artist?.artistInfo?[0].stageName_ar
                musicTypeLabel.text = viewModel?.booking.package.artist?.categories?.name_ar
                priceLabel.text =   (viewModel?.booking.amount.clean ?? "") +  Utils.localizedText(text: " SAR")
                priceLabel.font = UIFont(name: "Almarai-Bold", size: 18)
             
              }
            else{
                priceLabel.text =   Utils.localizedText(text: "SAR ") + (viewModel?.booking.amount.clean ?? "")
             
                artistNameLabel.text = viewModel?.booking.package.artist?.artistInfo?[0].stageName
                musicTypeLabel.text = viewModel?.booking.package.artist?.categories?.name
       
            
            }
        
            let imgarray = viewModel?.booking.package.artist?.artistImages ?? nil
            if !(imgarray!.isEmpty){
                Utils.setImageTo(imageView: artistImageView, imageName:imgarray?[0].coverImage ?? "picture" , placeholderImage: "picture")
            }
           
            
            let bookingStatus = BookingStatus(rawValue: viewModel?.booking.status ?? "") ?? BookingStatus.unknown
            statusLabel.text = Utils.localizedText(text: Utils.bookingStatusString[bookingStatus] ?? "")
           
            switch BookingStatus(rawValue: bookingStatus.rawValue){
            
            case .waitingForApproval:
                statusLabel.text = Utils.localizedText(text: "Waiting for approval")
              
                statusLabel.textColor = UIColor(named: "booking_waiting_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_waiting_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
               
                viewDetailsButton.setTitle(Utils.localizedText(text: "View Details"), for: .normal)
            case .approved:
                if viewModel?.booking.paid == "YES"{
                    statusLabel.text = Utils.localizedText(text: "Enjoy your Event")
                   
                    statusLabel.textColor = UIColor(named: "booking_paid_color")
                    viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_paid_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                    viewDetailsButton.setTitle(Utils.localizedText(text: "View Details"), for: .normal)
                    viewDetailsButton.isEnabled = true
                }else{
                    statusLabel.text = Utils.localizedText(text: "Approved")
                   
                    statusLabel.textColor = UIColor(named: "booking_approved_color")
                    viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_approved_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                    viewDetailsButton.setTitle(Utils.localizedText(text: "Pay Now"), for: .normal)
                    viewDetailsButton.isEnabled = true
                }
              
            case .paid:
                statusLabel.textColor = UIColor(named: "booking_paid_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_paid_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text:"View Details"), for: .normal)
                viewDetailsButton.isEnabled = true
            case .rejected:
                statusLabel.textColor = UIColor(named: "booking_canceled_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_canceled_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text:"Rejected"), for: .normal)
                viewDetailsButton.isEnabled = false
            case .unknown:
                statusLabel.textColor = UIColor(named: "booking_waiting_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_waiting_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text:"View Details"), for: .normal)
                viewDetailsButton.isEnabled = false
            case .cancelled:
            
            statusLabel.textColor = UIColor(named: "booking_canceled_color")
            viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_canceled_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text: "Cancelled"), for: .normal)
                viewDetailsButton.isEnabled = false
            case .reschedule:
                statusLabel.text = Utils.localizedText(text: "Waiting for approval")
               
                statusLabel.textColor = UIColor(named: "booking_waiting_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_waiting_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
               
                viewDetailsButton.setTitle(Utils.localizedText(text:"View Details"), for: .normal)
            case .expired:
                statusLabel.text = Utils.localizedText(text:"Expired")
             
                statusLabel.textColor = UIColor.red
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_canceled_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text:"Expired"), for: .normal)
                viewDetailsButton.isEnabled = false
            case .completed:
                statusLabel.text = Utils.localizedText(text:"Paid")
               
                statusLabel.textColor = UIColor(named: "booking_paid_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_paid_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text:"View Details"), for: .normal)
                viewDetailsButton.isEnabled = true
            default:
                break
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artistImageView?.layer.cornerRadius = 10
        artistImageView?.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewDetailsButton.isEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onViewDetailsTapped(_ sender: Any) {
        if let booking = viewModel?.booking{
            self.delegate?.onDetailsButtonTapped(booking : booking)}
    }
}

class UpcomingEventTableCellViewModel{
    var booking : Booking
    
    init(booking : Booking){
        self.booking = booking
    }
}

enum BookingStatus : String{
    case waitingForApproval = "waiting"
    case approved = "approved"
    case paid = "paid"
    case rejected = "rejected"
    case cancelled = "canceled"
    case unknown = "unknown"
    case reschedule = "reschedule"
    case expired = "expired"
    case completed = "completed"
}


