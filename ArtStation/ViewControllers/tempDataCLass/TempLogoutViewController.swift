//
//  TempLogoutViewController.swift
//  ArtStation
//
//  Created by Apple on 16/06/2021.
//

import UIKit

class TempLogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.setUserLog="false"
        DataManager.setUserAuth=""
        DataManager.setUserData=nil
        let mainStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "navReg") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = initialViewController
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
