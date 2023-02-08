//
//  PaymentViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 7/13/21.
//

import Foundation

class PaymentCompletedViewModel{
    
    
    func getInvoice(withId id : Int, onCompletionCallback : @escaping (Bool,String?) -> Void){
        
        
        let api = APIManager.sharedInstance.bookingApi
        api.getInvoice(invoiceId: id, onSuccess: {
            response in
            
        }, onFailure: {
            error in
            
        })
        
    }
    
}
