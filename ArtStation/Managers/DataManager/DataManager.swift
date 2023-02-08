//
//  DataManager.swift
//  ArtStation
//
//  Created by MamooN_ on 5/28/21.
//

import Foundation


struct DataManager{
    
    //MARK:- Keys
    static let homeCardVideoPlayerOnboardingKey = "homepageVideoPlayerOnboardingKey"
    static let languagesKey = "app_language"
    static let userLogKey = "isUserLogged"
    static let userDataKey = "user_data_key"
    static let userAuthKey = "auth_key"
    static let userFCMTokenKey = "userFCMToken"
    static let deviceTokenKey = "deviceTokenKey"
    static let allowPushKey = "allowPushKey"
    static let vatKey = "vatKey"
    static let appleIDEmailKey = "apple_id_email"
    static let appleIDNameKey = "apple_id_name"
    static var requestedPlaces = ""
    static var CityForHomeDataKey = ""
    static var requestPlaceToBeSent = ""
    static var CategoryTypeSelection = ""
    static var loginTypeKey = "login_type"
    static var cachedCityDataKey = "cached_city_key"
    //MARK:- Data
    static var WeatherData:WeatherDataResponse?
    static var ArtistCards:HomeArtistCardApiResponse?
    static var ratingData:Double?
    static var navFOrEvents = false
    static var setCityForHomeData : Int?{
        didSet{
            UserDefaults.standard.setValue(setCityForHomeData, forKey: DataManager.CityForHomeDataKey)
        }
    }
    
    static var getCityForHomeData : Int?{
          get {
            UserDefaults.standard.object(forKey: DataManager.CityForHomeDataKey) as? Int ?? 0
          }
     }
    
    static var setAppleIdEmail : String?{
        didSet{
            UserDefaults.standard.setValue(setAppleIdEmail, forKey: DataManager.appleIDEmailKey)
        }
    }
    
    static var getAppleIdEmail : String?{
          get {
            UserDefaults.standard.object(forKey: DataManager.appleIDEmailKey) as? String
          }
     }
    
    
    static var setLoginType : String?{
        didSet{
            UserDefaults.standard.setValue(setLoginType, forKey: DataManager.loginTypeKey)
        }
    }
    
    static var getLoginType : String?{
          get {
            UserDefaults.standard.object(forKey: DataManager.loginTypeKey) as? String
          }
     }
    
    
    static var setAppleIdName : String?{
        didSet{
            UserDefaults.standard.setValue(setAppleIdName, forKey: DataManager.appleIDNameKey)
        }
    }
    
    static var getAppleIdName : String?{
          get {
            UserDefaults.standard.object(forKey: DataManager.appleIDNameKey) as? String
          }
     }
    
    
    
    static var setLanguage : String?{
        didSet{
            UserDefaults.standard.setValue(setLanguage, forKey: DataManager.languagesKey)
        }
    }
    
    static var getLanguage : String{
          get {
            UserDefaults.standard.object(forKey: DataManager.languagesKey) as? String ?? Language.english.rawValue
         }
     }
    
    static var setVAT : String?{
        didSet{
            UserDefaults.standard.setValue(setVAT, forKey: DataManager.vatKey)
        }
    }
    
    static var getVAT : String{
          get {
             UserDefaults.standard.object(forKey: DataManager.vatKey) as? String ?? "NotFound"
         }
     }
    
    
    static var setNotificationFlag : Bool?{
        didSet{
            UserDefaults.standard.setValue(setNotificationFlag, forKey: DataManager.allowPushKey)
        }
    }
    
    static var getNotificationFlag : Bool{
          get {
             UserDefaults.standard.object(forKey: DataManager.allowPushKey) as? Bool ?? true
         }
     }
    
    
    static var setDeviceToken : String?{
        didSet{
            UserDefaults.standard.setValue(setDeviceToken, forKey: DataManager.deviceTokenKey)
        }
    }
    
    static var getDeviceToken : String?{
          get {
             UserDefaults.standard.object(forKey: DataManager.deviceTokenKey) as? String ?? ""
         }
     }
    
    
    static var setFCMToken : String?{
        didSet{
            UserDefaults.standard.setValue(setFCMToken, forKey: DataManager.userFCMTokenKey)
        }
    }
    
    static var getFCMToken : String?{
          get {
             UserDefaults.standard.object(forKey: DataManager.userFCMTokenKey) as? String ?? ""
         }
     }
    
    
    static var setUserAuth : String?{
        didSet{
            UserDefaults.standard.setValue(setUserAuth, forKey: DataManager.userAuthKey)
        }
    }
    
    static var getUserAuth : String?{
          get {
             UserDefaults.standard.object(forKey: DataManager.userAuthKey) as? String ?? ""
         }
     }
    
    static var setUserLog : String?{
        didSet{
            UserDefaults.standard.setValue(setUserLog, forKey: DataManager.userLogKey)
        }
    }
    
    
   static var getUserLog : String?{
         get {
            UserDefaults.standard.object(forKey: DataManager.userLogKey) as? String ?? "false"
        }
    }
    
    
    static var appLanguage : String?{
        didSet{
            let defaults = UserDefaults.standard
            defaults.setValue(appLanguage, forKey: DataManager.languagesKey)
        }
    }
    
    
    
    static var setCachedCityData: [City]?{
        didSet
            {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(setCachedCityData)
                {
                    let defaults = UserDefaults.standard
                    let key = cachedCityDataKey
                    defaults.set(encoded, forKey: key)
                }
            }
    }
    
    static var getCachedCityData : [City]?{
            get
            {
                if let cachedResponse = UserDefaults.standard.object(forKey: DataManager.cachedCityDataKey) as? Data {
                    let decoder = JSONDecoder()
                    if let cityData = try? decoder.decode([City].self, from: cachedResponse) {
                      return  cityData
                    }
                }
                return nil
            }
        }
    
    
    static var setUserData : User?{
      
           didSet
               {
                   let encoder = JSONEncoder()
                   if let encoded = try? encoder.encode(setUserData)
                   {
                       let defaults = UserDefaults.standard
                       let key = userDataKey
                       defaults.set(encoded, forKey: key)
                   }
               }
            }
            
    static var getUserData : User?{
            get
            {
                if let cachedResponse = UserDefaults.standard.object(forKey: DataManager.userDataKey) as? Data {
                    let decoder = JSONDecoder()
                    if let userData = try? decoder.decode(User.self, from: cachedResponse) {
                      return  userData
                    }
                }
                return nil
            }
        }
    
    
    
    static var setHomepageVideoOnboarding : Bool?{
        didSet{
            UserDefaults.standard.setValue(setHomepageVideoOnboarding, forKey: DataManager.homeCardVideoPlayerOnboardingKey)
        }
    }
    
    static var getHomepageVideoOnboarding : Bool{
          get {
             UserDefaults.standard.object(forKey: DataManager.homeCardVideoPlayerOnboardingKey) as? Bool ?? false
         }
     }
    
    
    static var setPackageSelection = true
    }

import SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
