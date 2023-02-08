//
//  PackageTableViewCell.swift
//  ArtStation
//
//  Created by MamooN_ on 6/3/21.
//

import UIKit

protocol PackageTableViewCellDelegate{
    func onPackageSeleted(index : Int)
}


class PackageTableViewCell: UITableViewCell {

  
    //MARK:- IB Refrences
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectPackageButton: UIButton!
    //@IBOutlet weak var packageCollectionView: UICollectionView!
    
    @IBOutlet weak var headingView: UIView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var numOfAudienceLabel: UILabel!
    @IBOutlet weak var numberOfMusicainLabel: UILabel!
    @IBOutlet weak var numOfBandMembersLabel: UILabel!
    @IBOutlet weak var areTheyGoingToSingLabel: UILabel!
    
    var index: Int?
    //MARK:- Data
    
    var places : [String]?{
        didSet{
           // packageCollectionView.reloadData()
        }
    }
    
    var delegate : PackageTableViewCellDelegate?
    let packageCollectionViewCellIdentifier = "package_collectionView_cell"
    var viewModel:PackageTableCellViewModel?{
        didSet{
            debugPrint("ViewModel Update")
            
            headingLabel.text = Utils.localizedText(text: "Package") + " " + String(index! + 1)
            areTheyGoingToSingLabel.text = viewModel?.tableData?.goToSing == "0" ? Utils.localizedText(text: "No") : Utils.localizedText(text: "Yes")
            numberOfMusicainLabel.text = Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.musiciansCount ?? 0))
            numOfBandMembersLabel.text = Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.bandMembersCount ?? 0))
           // numOfAudienceLabel.text = Utils.localizedArabicNumber(stringV: String(viewModel?.tableData?.audienceCountFrom ?? 0))+" - "+Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.audienceCountTo ?? 0))
            
            
            if DataManager.getLanguage == Language.english.rawValue{
                priceRangeLabel.text =  Utils.localizedText(text: "SAR ") + String(viewModel?.tableData?.eventPrice ?? 0)
                
            }
            else{
                priceRangeLabel.text =   String(viewModel?.tableData?.eventPrice ?? 0) + Utils.localizedText(text: " SAR")
                priceRangeLabel.font = UIFont(name: "Almarai-Bold", size: 16)
            }
            
            places = viewModel?.tableData?.events.components(separatedBy: ",")
                
            //debugPrint(places,"PLACES")
           
           
            
        }
    }
    
    //MARK:- Initial UI/Data Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       selectPackageButton.configureButtonUI(backgroundColor: .systemPink, fontColor: .white, borderRadius: selectPackageButton.frame.height/2, borderColor: nil)

//       packageCollectionView.delegate = self
//      packageCollectionView.dataSource = self
        
      
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    
    @IBAction func onPackageSelected(_ sender: Any) {

            self.delegate?.onPackageSeleted(index: viewModel?.rowId ?? -1)
    }
    
    
    //MARK:- Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    
        headingView.setGradientBackground(colorStart:UIColor(red: 255, green: 241, blue: 201, alpha: 1), colorEnd: UIColor(red: 255, green: 228, blue: 201, alpha: 0))
    }
    
    
    
    
}


//MARK:- Locations CollectionView Delegate 
extension PackageTableViewCell : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint(places,"PLACES")
        debugPrint(places?.count,"PLACES COUNT")
        return places?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: packageCollectionViewCellIdentifier, for: indexPath) as! PackageCollectionViewCell
    
        cell.configureCellUI(buttonTitle: Utils.localizedText(text: places![indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: collectionView.frame.height)
    }
    
  

}


enum CellHeadings : String{
    
    case firstPackage = "First Package"
    case secondPackage = "Second Package"
    case thirdPackage = "Third Package"
    case fourthPackage = "Fourth Package"
    case fifthPackage = "Fifth Package"
    
    init?(id : Int) {
           switch id {
           case 1:
               self = .firstPackage
           case 2:
               self = .secondPackage
           case 3:
               self = .thirdPackage
           case 4:
            self = .fourthPackage
           case 5 :
            self = .fifthPackage
           default:
               return nil
           }
       }
    
}
