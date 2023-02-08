//
//  NavBarViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/16/21.
//

import UIKit

protocol NavigationStackDelegate{
    func onControllerPushed()
    func navigationViewAppear(controllerCount : Int)
}

class NavBarViewController: UINavigationController{

    var stackDelegate : NavigationStackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        if DataManager.getLanguage == Language.arabic.rawValue{
//            view.semanticContentAttribute = .forceRightToLeft
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.stackDelegate?.navigationViewAppear(controllerCount: self.children.count)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        stackDelegate?.onControllerPushed()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
       let vc =  super.popViewController(animated: true)
       return vc
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
