//
//  PaymentCompletedViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/28/21.
//

import UIKit
import PDFKit

class PaymentCompletedViewController: UIViewController {

    var bookingID:Int? = -1
    
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveContractButton: UIButton!
    @IBOutlet weak var saveInvoiceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //saveContractButton.configureButtonUI(backgroundColor: UIColor(named: "tabbar_item_tint"), fontColor: UIColor.white, borderRadius: 17, borderColor: nil, borderWidth: 0)
        orderNumLabel.text = Utils.localizedText(text: "Booking#") + String(bookingID!)
        saveInvoiceButton.configureButtonUI(backgroundColor: UIColor(named: "invoice_button_color"), fontColor: UIColor.white, borderRadius: 17, borderColor: nil, borderWidth: 0)
        
    }
    

    @IBAction func onSaveInvoiceTapped(_ sender: Any) {
        debugPrint("Tapped")
        debugPrint(bookingID,"BookingID")
        if bookingID != nil{
        
        let viewModel = EventConfirmationViewModel()
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            viewModel.getInvoice(urlType: "", withId: bookingID!, onCompletionCallback: {
            success,data in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                
                self.savePdfToPhone(urlString: data ?? "", fileName: "ArtStationBooking#" + String(self.bookingID!))
         
            }else{
                self.showAlert(title: "Error", message: data ?? "" )
            }
        })
        }
    }
    
    @IBAction func onBackToMyEventTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func savePdfToPhone(urlString:String,fileName:String) {
        DispatchQueue.main.async {
                   let url = URL(string: urlString)
                   let pdfData = try? Data.init(contentsOf: url!)
                   let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                   let pdfNameFromUrl = fileName + ".pdf"
                   let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            if pdfData != nil{
            do {
                       try pdfData?.write(to: actualPath, options: .atomic)
                    let activityViewController = UIActivityViewController(activityItems: [pdfData!] , applicationActivities: nil)
                    activityViewController.excludedActivityTypes = [.airDrop,.mail,.postToWeibo,.postToVimeo,.postToFlickr,.postToTwitter,.postToFacebook,.postToTencentWeibo,.copyToPasteboard,.message]
                  
                
                activityViewController.completionWithItemsHandler =  {
                    (activity, success, items, error) in
                    if success{
                        self.navigateToPdFView(fileurl: actualPath.description)
                    }
                    else{
                        self.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                    }
                }
                
                DispatchQueue.main.async {
                    self.present(activityViewController, animated: true, completion:nil)
                }
                
                   } catch let error{
                    self.showAlert(title: "Error", message: error.localizedDescription)
                   }
            }
        }
    }
    
    func navigateToPdFView(fileurl:String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"InvoiceControllerId") as! PdfViewController
        
        vc.invoiceUrl = fileurl
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
        /*guard let url = URL(string:urlString) else { return }
              
              let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
              
              let downloadTask = urlSession.downloadTask(with: url)
              downloadTask.resume()
    
       }
    */
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
