//
//  ArtistPackageTableViewCell.swift
//  ArtStation
//
//  Created by Apple on 07/06/2021.
//

import UIKit

class ArtistPackageTableViewCell:UITableViewCell {
    
    //MARK:- IB Refrences
    @IBOutlet weak var packageCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var lblifSing: UILabel!
    @IBOutlet weak var lblNoOfMusican: UILabel!
    @IBOutlet weak var lblNumberOfBands: UILabel!
    @IBOutlet weak var lblNoOfInstruments: UILabel!
    @IBOutlet weak var lblTypeOfInstrument: UILabel!
    @IBOutlet weak var lblPreferedAud: UILabel!
    @IBOutlet weak var lblAdditionalInfo: UILabel!
    @IBOutlet weak var lblPlayTime: UILabel!
    
    
    var selectedPlace = ""
    
    //MARK:- Data
    let packageCollectionViewCellIdentifier = "ArtistPackageCollectionViewCell"
    var viewModel : PackageTableCellViewModel? {
        didSet{
            lblPlayTime.text = Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.playTimeFrom ?? 0)) + " - "+Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.playTimeTo ?? 0)) + " " + Utils.localizedText(text: "Hours")
            lblNoOfMusican.text = Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.musiciansCount ?? 0))
            lblNoOfInstruments.text = Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.instrumentCount ?? 0))
            lblPreferedAud.text = Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.audienceCountFrom ?? 0))+" - "+Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.audienceCountTo ?? 0))
            lblAdditionalInfo.text = (viewModel?.tableData?.addInfo)
            lblNumberOfBands.text = Utils.localizedArabicNumber(stringV:String(viewModel?.tableData?.bandMembersCount ?? 0))
            lblifSing.text = viewModel?.tableData?.goToSing == "1" ? Utils.localizedText(text: "Yes") : Utils.localizedText(text: "No")
          
            if DataManager.getLanguage == Language.arabic.rawValue{
                lblTypeOfInstrument.text = viewModel?.tableData?.instrumentType_ar?.replacingOccurrences(of: ",", with: " | ")
                lblAdditionalInfo.text = (viewModel?.tableData?.addInfo_ar ?? "")
         
            }else{
                lblTypeOfInstrument.text = (viewModel?.tableData?.instrumentType?.replacingOccurrences(of: ",", with: " | ")) ?? ""
                lblAdditionalInfo.text = (viewModel?.tableData?.addInfo)
         
            }
            places = viewModel?.tableData?.events.components(separatedBy: ",")
        }
    }
    
    var places : [String]?{
        didSet{
            packageCollectionView.reloadData()
        }
    }
    
    //MARK:- Initial UI/Data Setup
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        packageCollectionView.delegate = self
//        packageCollectionView.dataSource = self
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//
//    
//    //MARK:- Layout Subviews
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
//    }
//    
//    
    
}


//MARK:- Locations CollectionView Delegate
//extension ArtistPackageTableViewCell : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,ProtocolPlaceSelection{
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return places?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: packageCollectionViewCellIdentifier, for: indexPath) as! ArtistPackageCollectionViewCell
//        cell.delegateM = self
//        cell.configureCellUI(placeName: Utils.localizedText(text: places![indexPath.row]))
//        cell.placeNameToSend = places![indexPath.row]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 66, height: collectionView.frame.height)
//    }
    //}


