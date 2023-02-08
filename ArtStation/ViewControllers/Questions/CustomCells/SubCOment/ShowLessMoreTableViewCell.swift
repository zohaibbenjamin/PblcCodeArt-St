//
//  ShowLessMoreTableViewCell.swift
//  ArtStation
//
//  Created by Apple on 28/06/2021.
//

import UIKit

protocol ProtocolShowLessComent {
    func hideAllComments()
}

class ShowLessMoreTableViewCell: UITableViewCell {

    var delegateHideComent:ProtocolShowLessComent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnSHowLess(_ sender: Any) {
        delegateHideComent?.hideAllComments()
    }
    
}
