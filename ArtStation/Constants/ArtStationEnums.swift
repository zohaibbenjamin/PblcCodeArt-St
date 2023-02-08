//
//  ArtStationEnums.swift
//  ArtStation
//
//  Created by MamooN_ on 6/8/21.
//

import Foundation

enum LoginType : String{
    case social = "social"
    case normal = "normal"
    case other = "other"
}
enum UserType : String{
    case user = "user"
    case artist = "artist"
    case other = "other"
    case entertainer = "entertainer"
}
enum Category : Int{
    case user = 0
    case artist = 1
    case other = -1
}
enum OtpType : String{
    case signUp = "signup"
    case forgotPassword = "forgot"
}
