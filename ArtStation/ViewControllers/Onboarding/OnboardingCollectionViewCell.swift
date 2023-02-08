//
//  OnboardingCollectionViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 5/28/21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    var cellContentView : UIView?
    func configureCellUI(contentView : UIView){
        self.cellContentView = contentView
        addSubview(self.cellContentView!)
    }
    
    override func prepareForReuse() {
        cellContentView?.removeFromSuperview()
    }
    
}
