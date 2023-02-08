//
//  ReviewContainerViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/28/21.
//

import UIKit

class ReviewContainerViewController: UIViewController {

    @IBOutlet weak var addReviewButton: UIButton!
    @IBOutlet weak var upComingEventsLabel: UILabel!
    @IBOutlet weak var collectionViewContainer: UIView!
    
    @IBOutlet weak var allReviewsBottomView: UIView!
    @IBOutlet weak var upCommingEventBottomView: UIView!
    @IBOutlet weak var pastEventsView: UIView!
    @IBOutlet weak var pastEventsLabel: UILabel!
    @IBOutlet weak var upcomingEventsView: UIView!
    @IBOutlet weak var constVIew: NSLayoutConstraint!
    
    @IBOutlet weak var topReviewView: UIView!
    
    var JustReview=false
    var showAddReviewScreen : Bool = true
    var bookingId : Int?
    
    var upComingEventViewController : AddReviewTableViewController?
    var pastEventViewController : AllReviewsTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateView(lable: pastEventsLabel, bottomView: allReviewsBottomView, status: false)
        // Do any additional setup after loading the view.
        upComingEventViewController = Utils.getViewController(storyboard: StoryboardId.moreStoryboard, identifier: StoryboardId.addReviewsViewControllerID, viewController: AddReviewTableViewController.self)
        upComingEventViewController?.bookingId = bookingId
        pastEventViewController = Utils.getViewController(storyboard: StoryboardId.moreStoryboard, identifier: StoryboardId.allReviewsViewControllerId, viewController: AllReviewsTableViewController.self)
        pastEventViewController?.bookingId = bookingId
        
        if JustReview
        {
            constVIew.constant = 0
            topReviewView.isHidden = true
        }
        else
        {
            constVIew.constant = 52
            topReviewView.isHidden = false
        }
        if showAddReviewScreen{
            embed(upComingEventViewController!, inView: collectionViewContainer)
        }else{
            embed(pastEventViewController!,inView: collectionViewContainer)
        }
    }
    

    @IBAction func onUpcomingEventsTapped(_ sender: Any) {
        pastEventViewController?.view.removeFromSuperview()
        updateView(lable: upComingEventsLabel, bottomView: upCommingEventBottomView, status: true)
        updateView(lable: pastEventsLabel, bottomView: allReviewsBottomView, status: false)
        embed(upComingEventViewController!, inView: collectionViewContainer)
    }
    @IBAction func onPastEventsTapped(_ sender: Any) {
        upComingEventViewController?.view.removeFromSuperview()
        updateView(lable: pastEventsLabel, bottomView: allReviewsBottomView, status: true)
        updateView(lable: upComingEventsLabel, bottomView: upCommingEventBottomView, status: false)
        embed(pastEventViewController!, inView: collectionViewContainer)
    }
    
    func updateView(lable : UILabel,bottomView : UIView,status : Bool){
        // Comment
        if !status{
            bottomView.isHidden = true
            lable.textColor = UIColor.gray.withAlphaComponent(0.5)
        }else{
            bottomView.isHidden = false
            lable.textColor = UIColor(named: "tabbar_item_tint")!
        }
        
    }
}
