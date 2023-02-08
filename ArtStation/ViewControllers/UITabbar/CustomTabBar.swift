//
//  CustomTabBar.swift
//  ArtStation
//
//  Created by MamooN_ on 6/2/21.
//

import UIKit
import UIKit

class CustomTabBar: UITabBar{
 
    override func awakeFromNib() {
              super.awakeFromNib()
              layer.masksToBounds = true
              layer.cornerRadius = 25
              barTintColor = .white
              layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    
    var prominentButtonCallback: (()->())?
        
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard let items = items, items.count>0 else {
                return super.hitTest(point, with: event)
            }
            
            let middleItem = items[2]
            
            
            let middleExtra = middleItem.imageInsets.top
            let middleWidth = bounds.width/CGFloat(items.count)
            let middleRect = CGRect(x: (bounds.width-middleWidth)/2, y: middleExtra, width: middleWidth, height: abs(middleExtra))
            if middleRect.contains(point) {
                prominentButtonCallback?()
                return nil
            }
            return super.hitTest(point, with: event)
        }
}
