//
//  AddReviewTableViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/28/21.
//

import UIKit

class AddReviewTableViewController: UIViewController {

    @IBOutlet weak var reviewCommentTextFeild: UITextView!
    @IBOutlet weak var emojiTextLabel: UILabel!
    @IBOutlet var emojiImageViews: [UIImageView]!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet var emojiButtons: [UIButton]!
    
    
    var bookingId : Int?
    var selectedRating : Double = 5
    let viewModel : AddReviewViewModel = AddReviewViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        
        rateButton.configureButtonUI(backgroundColor: UIColor(named: "tabbar_item_tint"), fontColor: UIColor.white, borderRadius: 17, borderColor: UIColor(named: "tabbar_item_tint"), borderWidth: 0)
        
    }

    @IBAction func inLoveButtonTapped(_ sender: Any) {
        
        selectedRating = 5
        for image in emojiImageViews{
            if image.tag == 2{
                emojiImageView.image = image.image
                image.alpha = 1
                emojiTextLabel.text = Utils.localizedText(text: "In love with")
            }else{
                image.alpha = 0.5
            }
        }
        
    }
    
    @IBAction func happyButtonTapped(_ sender: Any) {
        selectedRating = 4
        for image in emojiImageViews{
            if image.tag == 3{
                
                emojiImageView.image = image.image
                image.alpha = 1
                emojiTextLabel.text = Utils.localizedText(text: "Happy with")
            }else{
                image.alpha = 0.5
            }
        }
    }
    @IBAction func sadButtonTapped(_ sender: Any) {
        selectedRating = 3
        for image in emojiImageViews{
            if image.tag == 4{
                
                emojiImageView.image = image.image
                image.alpha = 1
                emojiTextLabel.text = Utils.localizedText(text: "Sad with")
            }else{
                image.alpha = 0.5
            }
        }
    }
  
    @IBAction func angryButtonTapped(_ sender: Any) {
        selectedRating = 2
        for image in emojiImageViews{
            if image.tag == 5{
                emojiTextLabel.text = Utils.localizedText(text: "Angry with")
                emojiImageView.image = image.image
                image.alpha = 1
            }else{
                image.alpha = 0.5
            }
        }
    }
    
    
    @IBAction func onRateButtonTapped(_ sender: Any) {
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        let addReviewRequest = AddReviewApiRequest(comment: reviewCommentTextFeild.text ?? "", rating: selectedRating, packageId: bookingId ?? -1)
        viewModel.addReview(apiRequest: addReviewRequest, onCompletionCallback: {
            success,message in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                self.reviewCommentTextFeild.text = ""
                self.showAlert(title: "Success", message: message ?? "",onOkTapped: {
                    (self.parent as! ReviewContainerViewController).onPastEventsTapped(self)
                },alertType: .alert)
            }else{
                self.showAlert(title: "Alert", message: message ?? "")
            }
        })
        
    }
}
