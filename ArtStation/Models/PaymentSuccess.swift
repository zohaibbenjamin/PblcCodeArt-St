//
//  PaymentSuccess.swift
//  ArtStation
//
//  Created by Apple on 12/07/2021.
//

import Foundation

struct PaymentSuccess: Codable {
    var promo_id : String?
    var payment_id: String
    var booking_id: String
    var amount,discount,vatAmount,vatPercent,netAmount:String
    var payment_type : String
    enum CodingKeys: String, CodingKey {
        case payment_type
        case promo_id
        case payment_id
        case booking_id
        case amount,discount,vatAmount,vatPercent,netAmount
    }
    
   
}


struct PaymentSuccessPromo: Codable {
    var promo_id:String
    var payment_id: String
    var booking_id: String
    var amount,discount,vatAmount,vatPercent,netAmount:String
    
    enum CodingKeys: String, CodingKey {
        case payment_id,promo_id
        case booking_id
        case amount,discount,vatAmount,vatPercent,netAmount
    }
}


struct Promo: Codable {
   
    let promo_code:String?
    
    enum CodingKeys: String, CodingKey {
      case promo_code
    }
}
