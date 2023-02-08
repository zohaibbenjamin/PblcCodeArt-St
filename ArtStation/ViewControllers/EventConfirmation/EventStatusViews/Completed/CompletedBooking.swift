//
//  CompletedBooking.swift
//  ArtStation
//
//  Created by MamooN_ on 6/24/21.
//

import UIKit


protocol CompletedBookingDelegate{
    func onInvoiceTapped()
    func onContractTapped()
}

class CompletedBooking: UIView {

    
    //MARK:- IBRefrences
    @IBOutlet var contentView: UIView!
 
    var delegate : CompletedBookingDelegate?
    let viewIdentifier = "CompletedBookingView"
    
    @IBOutlet weak var paidButton: CardView!
    
    @IBOutlet weak var invoiceButton: UIButton!
    @IBOutlet weak var contractButton: UIButton!
    //MARK:- Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    @IBAction func onContractTapped(_ sender: Any) {
        debugPrint("Contract")
        self.delegate?.onContractTapped()
    }
    
    @IBAction func onInvoiceTapped(_ sender: Any) {
        debugPrint("Invoice")
        delegate?.onInvoiceTapped()
    }
    func initSubviews() {
        let nib = UINib(nibName: viewIdentifier + UIManager.ifArabiclanguage(), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        
       // contractButton.configureButtonUI(backgroundColor: UIColor(named: "tabbar_item_tint"), fontColor: UIColor.white, borderRadius: 17, borderColor: nil, borderWidth: 0)
        invoiceButton.configureButtonUI(backgroundColor: UIColor(named: "invoice_button_color"), fontColor: UIColor.white, borderRadius: 17, borderColor: nil, borderWidth: 0)
        
    }

}
