
//  ConfigurationManager.swift
//  TabibGroup_Swift
//
//  Created by Tahir Pasha on 04/11/2020.
//

import Foundation

class ConfigurationManager
{
    enum Configuration: String
    {
        case staging = "Debug"
        case production = "Release"
    }
    
    // MARK: Shared instance
    static let shared = ConfigurationManager()
    
    // MARK: Properties
    private let configurationKey = "Configuration"
    private let configurationDictionaryName = "Configuration"
    private let BaseURLV = "BaseURLV"
    private let BaseURLVOffers = "BaseURLVOffers"
    private let BaseURLGuest = "BaseUrlGuest"
    private let BaseURLEndpoint = "BaseURLEndpoint"
    private let BaseURLImage = "BaseURLImage"
    private let BaseURLAudio = "BaseURLAudio"
    private let BaseURLPayfortSDK = "BaseURLPayfortSDK"
    private let payFortEnvirementSetting = "PayfortEnvironment"
    
    
    let activeConfiguration: Configuration
    private let activeConfigurationDictionary: NSDictionary
    
    // MARK: Lifecycle
    init ()
    {
        debugPrint("Initializing")
        let bundle = Bundle(for: ConfigurationManager.self)
        guard let rawConfiguration = bundle.object(forInfoDictionaryKey: configurationKey) as? String,
              let activeConfiguration = Configuration(rawValue: rawConfiguration),
              let configurationDictionaryPath = bundle.path(forResource: configurationDictionaryName, ofType: "plist"),
              let configurationDictionary = NSDictionary(contentsOfFile: configurationDictionaryPath),
              let activeEnvironmentDictionary = configurationDictionary[activeConfiguration.rawValue] as? NSDictionary
        else
        {
            fatalError("Configuration Error")
        }
        self.activeConfiguration = activeConfiguration
        self.activeConfigurationDictionary = activeEnvironmentDictionary
    }
    
    // MARK: Methods
    private func getActiveVariableValue<V>(forKey key: String) -> V
    {
        guard let value = activeConfigurationDictionary[key] as?  V else
        {
            fatalError("No value satysfying requirements")
        }
        return value
    }
    
    func isRunning(in configuration: Configuration) -> Bool
    {
        return activeConfiguration == configuration
    }
    
    func getPayfortEnviroment() -> KPayFortEnviroment
    {
        let backendUrlString: String = getActiveVariableValue(forKey: payFortEnvirementSetting)
        debugPrint(backendUrlString,"PayfortEnvironment")
        if backendUrlString=="KPayFortEnviromentProduction"
        {
            return KPayFortEnviromentProduction
        }
        else
        {
            return KPayFortEnviromentSandBox
        }
    }
    
    
    func getBaseURLPayfortSDK() -> URL
    {
            let backendUrlString: String = getActiveVariableValue(forKey: BaseURLPayfortSDK)
            guard let backendUrl = URL(string: backendUrlString)
            else
            {
                fatalError("Backend URL missing")
            }
            return backendUrl
    }
    
    func getBaseURLV() -> URL
    {
       
        if UserDefaults.standard.object(forKey: DataManager.userLogKey) as? String ?? ""=="guest"
        {
            let backendUrlString: String = getActiveVariableValue(forKey: BaseURLGuest)
            guard let backendUrl = URL(string: backendUrlString)
            else
            {
                fatalError("Backend URL missing")
            }
            return backendUrl
        }
        else
        {
            let backendUrlString: String = getActiveVariableValue(forKey: BaseURLV)
            guard let backendUrl = URL(string: backendUrlString)
            else
            {
                fatalError("Backend URL missing")
            }
            return backendUrl
        }
       
    }
    
    
    func getGuestUrl() -> URL
    {
        let backendUrlString: String = getActiveVariableValue(forKey: BaseURLGuest)
        guard let backendUrl = URL(string: backendUrlString)
        else
        {
            fatalError("Backend URL missing")
        }
        return backendUrl
    }
    
    func getBaseURLVOffers() -> URL
    {
        let backendUrlString: String = getActiveVariableValue(forKey: BaseURLVOffers)
        guard let backendUrl = URL(string: backendUrlString)
        else
        {
            fatalError("Backend URL missing")
        }
        return backendUrl
    }
    
    func getBaseURLEndpoint() -> URL
    {
        let backendUrlString: String = getActiveVariableValue(forKey: BaseURLEndpoint)
        guard let backendUrl = URL(string: backendUrlString)
        else
        {
            fatalError("Backend URL missing")
        }
        return backendUrl
    }
    
    func getBaseURLImage() -> URL
    {
        let backendUrlString: String = getActiveVariableValue(forKey: BaseURLImage)
        guard let backendUrl = URL(string: backendUrlString)
        else
        {
            fatalError("Backend URL missing")
        }
        return backendUrl
    }
    
    func getBaseURLAudio() -> URL
    {
        let backendUrlString: String = getActiveVariableValue(forKey: BaseURLAudio)
        guard let backendUrl = URL(string: backendUrlString)
        else
        {
            fatalError("Backend Url missing")
        }
        return backendUrl
    }
}
