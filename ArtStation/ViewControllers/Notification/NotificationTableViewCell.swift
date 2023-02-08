//
//  NotificationTableViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 7/7/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationDescription: UILabel!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var containerView: CardView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //UIManager.makeShadow(view: containerView)
    }
    
    var viewModel : NotificationTableCellViewModel?{
        didSet{
            if DataManager.getLanguage == Language.english.rawValue{
            
                self.notificationTitle.text = viewModel?.notification.title
                self.notificationDescription.text = viewModel?.notification.message
                
            }else{
                
                    self.notificationTitle.text = viewModel?.notification.title_ar
                    self.notificationDescription.text = viewModel?.notification.message_ar
                
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

struct NotificationTableCellViewModel{
    let notification : PushNotificationArtStation
}
