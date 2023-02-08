//
//  EventContainerViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/22/21.
//

import UIKit

class EventContainerViewController: UIViewController {
    @IBOutlet weak var upComingEventsLabel: UILabel!
    @IBOutlet weak var collectionViewContainer: UIView!
    
    @IBOutlet weak var pastEventsView: UIView!
    @IBOutlet weak var pastEventsLabel: UILabel!
    @IBOutlet weak var upcomingEventsView: UIView!
    
    var upComingEventViewController : UpcomingEventTableViewController?
    var pastEventViewController : PastEventsTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        updateView(lable: pastEventsLabel, bottomView: pastEventsView, status: false)
        // Do any additional setup after loading the view.
         upComingEventViewController = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.upcomingEventsTableControllerID, viewController: UpcomingEventTableViewController.self)
        
        pastEventViewController = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: StoryboardId.pastEventsTableControllerId, viewController: PastEventsTableViewController.self)
        embed(upComingEventViewController!, inView: collectionViewContainer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ((self.parent?.parent?.parent) as! TabbarContainerViewController).weatherView.backButton.isHidden = true
    }
    

    @IBAction func onUpcomingEventsTapped(_ sender: Any) {
        pastEventViewController?.view.removeFromSuperview()
        
        updateView(lable: upComingEventsLabel, bottomView: upcomingEventsView, status: true)
        updateView(lable: pastEventsLabel, bottomView: pastEventsView, status: false)
        embed(upComingEventViewController!, inView: collectionViewContainer)
    }
    @IBAction func onPastEventsTapped(_ sender: Any) {
        upComingEventViewController?.view.removeFromSuperview()
        updateView(lable: pastEventsLabel, bottomView: pastEventsView, status: true)
        updateView(lable: upComingEventsLabel, bottomView: upcomingEventsView, status: false)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventContainerViewController : PastEventTableCellDelegate,UpcomingEventTableCellDelegate{
    func onViewDetailsTapped(booking: Booking) {
       
        let viewController = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: "EventConfirmationNavigationController", viewController: UINavigationController.self)
        let child = viewController.children.first as! EventConrimationViewController
      
        switch BookingStatus(rawValue: booking.status){
        case .completed:
            child.eventStatus = .Complete
        case .expired:
            child.eventStatus = .expired
        default:
            break
        }
        
        child.booking = booking
        child.showBottomContainer = false
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    
    func onDetailsButtonTapped(booking: Booking) {
        let viewController = Utils.getViewController(storyboard: StoryboardId.eventStoryboardName, identifier: "EventConfirmationNavigationController", viewController: UINavigationController.self)
        let child = viewController.children.first as! EventConrimationViewController
      
        switch BookingStatus(rawValue: booking.status){
        
        case .waitingForApproval:
            child.eventStatus = .notApproved
        case .approved:
            if booking.paid == "NO"{
                child.eventStatus = .approved
            }else{
            child.eventStatus = .Complete
            }
        case .paid:
            child.eventStatus = .Complete
        case .rejected:
            break
        case .unknown:
            break
      
        case .cancelled:
            break
        case .reschedule:
            break
        case .expired:
            child.eventStatus = .expired
        case .completed:
            child.eventStatus = .Complete
        case .none:
            break
        }
        viewController.modalPresentationStyle = .fullScreen
        child.booking = booking
        self.present(viewController, animated: true, completion: nil)
    }
    
    func onAddReviewTapped(eventId id: Int) {
        let viewController = Utils.getViewController(storyboard: StoryboardId.moreStoryboard, identifier: StoryboardId.reviewsContainerControllerId, viewController: ReviewContainerViewController.self)
        viewController.bookingId = id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showArtistProfile(artistId : String){
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistProfileStoryboard, identifier: StoryboardId.artistProfieViewControllerId, viewController: ArtistProfileViewController.self)
        viewController.artistId = artistId
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func showArtistPackageProfile(artistId : String){
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.artistPackagesViewControllerId, viewController: ArtistPackageViewController.self)
        viewController.artistId = artistId
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func showEntertainerPackageProfile(entertainerID: String){
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.entertainerPackagesViewControllerId, viewController: EntertainerPackageViewController.self)
        viewController.artistId = entertainerID
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func showRescheduleScreen(booking : Booking){
        if let artistId = booking.package.artist?.artistImages?[0].userID{
        let viewController = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.artistLocationViewControllerId, viewController: SetLocationViewController.self)
        viewController.isOpenendToReschedule = true
        viewController.bookingTebeRescheduled = booking
            BookingNow.sharedInstance.artist_id = artistId
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else{
            debugPrint("ERROR")
        }
    }
    
}
