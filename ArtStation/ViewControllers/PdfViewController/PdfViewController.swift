//
//  PdfViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 7/13/21.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController {

    //MARK:- Data
    let pdfView = PDFView()
    var invoiceUrl : String?
    
    //MARK:- IB Refrences
    @IBOutlet weak var backButton: UIButton!
  
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- onBackButtonTapped
    @IBAction func onBackButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- sets up initial ui
    func setupUI(){
        backButton.configureButtonUI(backgroundColor: nil,fontColor: UIColor(named: "tabbar_item_tint")!, borderRadius: backButton.frame.height/2, borderColor: UIColor(named: "tabbar_item_tint"), borderWidth: 2)
        let pdfUrl = URL(string: invoiceUrl ?? "")!
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.sendSubviewToBack(pdfView)
        
        let pdfDocument = PDFDocument(url: pdfUrl)
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = pdfDocument
        pdfView.autoScales = true
     
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
