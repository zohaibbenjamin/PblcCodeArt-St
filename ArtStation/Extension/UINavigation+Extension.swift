//
//  UINavigation+Extension.swift
//  ArtStation
//
//  Created by Apple on 05/07/2021.
//

import Foundation
import UIKit
extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
    
    func popToRootView() {
          let homepageViewController = Utils.getViewController(storyboard: StoryboardId.tabBarStoryBoardId, identifier: StoryboardId.tabBarContainerControllerId, viewController: TabbarContainerViewController.self)
          
      
          
      if let keyWindow = UIWindow.key {
          keyWindow.rootViewController = homepageViewController
      }
    }
}
