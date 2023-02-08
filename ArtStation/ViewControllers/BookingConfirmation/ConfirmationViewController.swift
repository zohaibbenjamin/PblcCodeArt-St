//
//  ConfirmationViewController.swift
//  ArtStation
//
//  Created by Apple on 05/07/2021.
//

import UIKit

class ConfirmationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnNyEventsCLick(_ sender: Any) {
       // ArtStationTabViewController
      
        let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
        DataManager.navFOrEvents = true
        
    
        
    if let keyWindow = UIWindow.key {
        keyWindow.rootViewController = homepageViewController
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
