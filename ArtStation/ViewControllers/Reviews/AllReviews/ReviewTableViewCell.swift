//
//  ReviewTableViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 6/28/21.
//

import UIKit
import Cosmos
class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewContainerView: CardView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reivewContentLabel: UILabel!
    @IBOutlet weak var reviewRating: CosmosView!
    
    
    var viewModel : ReviewTableCellViewModel?{
        didSet{
            
            userNameLabel.text = viewModel?.review.users.name
            reivewContentLabel.text = viewModel?.review.comment
//            
//            if let comment =  viewModel?.review.comment{
//                if Utils.containsArabic(text: comment) {
//                reivewContentLabel.contentMode = .right
//            }else {
//                reivewContentLabel.contentMode = .left
//            }
//            }
            reviewRating.rating = Double(viewModel?.review.rating ?? "") ?? 0.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       UIManager.makeShadow(view: reviewContainerView)
  
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class ReviewTableCellViewModel{
    
    private(set) var review : Review
    
    init(review : Review){
        self.review = review
    }
}
