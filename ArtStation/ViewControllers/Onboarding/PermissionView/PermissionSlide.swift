//
//  PermissionSlide.swift
//  ArtStation
//
//  Created by MamooN_ on 5/28/21.
//

import UIKit


enum PermissionType {
    case location
    case notification
}

protocol PermissionViewDelegate{
    func onAllowedPermissionTapped(permissionType: PermissionType?)
    func onDontAllowTapped(permissionType: PermissionType?)
}
class PermissionSlide: UIView {
  
    //MARK:- IB Refrences
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var permissionImageView: UIImageView!
    @IBOutlet weak var permissionDescriptionLabel: UILabel!
    @IBOutlet weak var permissionTitleLabel: UILabel!
    @IBOutlet weak var permissionContentContainer: UIView!
   

    //MARK:- Data
    var delegate: PermissionViewDelegate?
    let viewIdentifier = "PermissionView"
    var permissionType : PermissionType?{
        didSet{
         
        }
    }
    
    //MARK:- Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    //MARK:- Initilialize Views
    func initSubviews() {
        let nib = UINib(nibName: viewIdentifier + UIManager.ifArabiclanguage(), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        permissionContentContainer.layer.cornerRadius = 10
        addSubview(contentView)
    }
    
    //MARK:- Setup Container
    func setupPermissionView(withImage image: UIImage,title: String,permissionTitle: String,description: String){
        titleLabel.text = title
        permissionImageView.image = image
        permissionTitleLabel.text = permissionTitle
        permissionDescriptionLabel.text = description
    }

    @IBAction func onAllowButtonTapped(_ sender: Any) {
        delegate?.onAllowedPermissionTapped(permissionType: permissionType)
    }
    @IBAction func onDontAllowTapped(_ sender: Any) {
        delegate?.onDontAllowTapped(permissionType: permissionType)
    }
}
