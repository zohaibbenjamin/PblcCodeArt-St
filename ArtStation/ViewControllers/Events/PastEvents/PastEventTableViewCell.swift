//
//  PastEventTableViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 6/22/21.
//

import UIKit

protocol PastEventTableCellDelegate{
    func onAddReviewTapped(eventId id : Int)
    func onViewDetailsTapped(booking : Booking)
}
class PastEventTableViewCell: UITableViewCell {

    @IBOutlet weak var addReviewButton: UIButton!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    //MARK:- IB Refrences
    @IBOutlet weak var viewDetailsButton: UIButton!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var packageTypeLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var musicTypeLabel: UILabel!
    
    //MARK:- Data
    var delegate : PastEventTableCellDelegate?
    var viewModel : PastEventTableCellViewModel?{
        didSet{
            if DataManager.getLanguage == Language.arabic.rawValue{
              
                artistNameLabel.text = viewModel?.booking.package.artist?.artistInfo?[0].stageName_ar
                musicTypeLabel.text = viewModel?.booking.package.artist?.categories?.name_ar
                priceLabel.text =   (viewModel?.booking.amount.clean ?? "") +  Utils.localizedText(text: " SAR")
                priceLabel.font = UIFont(name: "Almarai-Bold", size: 18)
             
            }
            else{
                priceLabel.text =    Utils.localizedText(text: "SAR ") + (viewModel?.booking.amount.clean ?? "")
                artistNameLabel.text = viewModel?.booking.package.artist?.artistInfo?[0].stageName
                musicTypeLabel.text = viewModel?.booking.package.artist?.categories?.name
            }
            orderNumLabel.text = Utils.localizedText(text: "Booking#") + String(viewModel?.booking.id ?? -999)
            let bookingStatus = BookingStatus(rawValue: viewModel?.booking.status ?? "") ?? BookingStatus.unknown
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
            if viewModel?.booking.package.artist?.artistImages != nil && !(viewModel?.booking.package.artist?.artistImages?.isEmpty ?? false){
                Utils.setImageTo(imageView: artistImageView, imageName: viewModel?.booking.package.artist?.artistImages?[0].coverImage ?? "", placeholderImage: "")
            }
            statusLabel.text = Utils.localizedText(text: Utils.bookingStatusString[bookingStatus] ?? "")
           
            switch BookingStatus(rawValue: viewModel?.booking.status ?? ""){
            case .completed:
                statusLabel.text = Utils.localizedText(text: "Completed")
                statusLabel.textColor = UIColor(named: "booking_paid_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_waiting_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text: "View Details"), for: .normal)
           
            case .rejected:
                statusLabel.text = Utils.localizedText(text: "Rejected")
                buttonHeightConstraint.constant = 0
                addReviewButton.isHidden = true
                statusLabel.textColor = UIColor(named: "booking_canceled_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_canceled_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text: "Rejected"), for: .normal)
                viewDetailsButton.isEnabled = false
                
   
            case .cancelled:
                statusLabel.text = Utils.localizedText(text: "Cancelled")
                addReviewButton.isHidden = true
                buttonHeightConstraint.constant = 0
                statusLabel.textColor = UIColor(named: "booking_canceled_color")
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_canceled_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text: "Cancelled"), for: .normal)
                viewDetailsButton.isEnabled = false
   
    
            case .expired:
          
                addReviewButton.isHidden = true
                buttonHeightConstraint.constant = 0
                statusLabel.text = Utils.localizedText(text: "Expired")
                statusLabel.textColor = UIColor.red
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_canceled_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
                viewDetailsButton.setTitle(Utils.localizedText(text: "Expired"), for: .normal)
                viewDetailsButton.isEnabled = false
            default:
              
                statusLabel.textColor = UIColor(named: "booking_waiting_color")
                buttonHeightConstraint.constant = 0
                addReviewButton.isHidden = true
                statusLabel.text = ""
                orderNumLabel.text = ""
                viewDetailsButton.isEnabled = false
                viewDetailsButton.configureButtonUI(backgroundColor: UIColor(named: "booking_waiting_button_color"), fontColor: UIColor.white, borderRadius: viewDetailsButton.frame.height/2, borderColor: nil, borderWidth: 0)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addReviewButton.configureButtonUI(backgroundColor: UIColor(named: "add_review_button_color"), fontColor: UIColor.white, borderRadius: 17, borderColor: nil, borderWidth: 0)
        addReviewButton.setTitle(Utils.localizedText(text: "Add Review"), for: .normal)
        artistImageView?.layer.cornerRadius = 10
        artistImageView?.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onViewDetialsButtonTapped(_ sender: Any) {
        if let booking = viewModel?.booking{
            self.delegate?.onViewDetailsTapped(booking: booking)}
    }
    @IBAction func onAddReviewTapped(_ sender: Any) {
        
        if let bookingId = viewModel?.booking.package.artist?.artistImages?[0].userID{
        self.delegate?.onAddReviewTapped(eventId: bookingId)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addReviewButton.isHidden = false
        buttonHeightConstraint.constant = 50
        viewDetailsButton.isEnabled = true
    }
}

class PastEventTableCellViewModel{
    var booking : Booking
    
    init(booking : Booking){
        self.booking = booking
    }
}
