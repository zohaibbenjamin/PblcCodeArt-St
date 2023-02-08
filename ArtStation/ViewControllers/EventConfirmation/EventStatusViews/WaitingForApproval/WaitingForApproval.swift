//
//  WaitingForApproval.swift
//  ArtStation
//
//  Created by MamooN_ on 6/24/21.
//

import UIKit

class WaitingForApproval: UIView {

    
    
    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
 
    let viewIdentifier = "WaitingForApprovalView"
    
    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var containerView: CardView!
    
    //MARK:- Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: viewIdentifier + UIManager.ifArabiclanguage(), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
