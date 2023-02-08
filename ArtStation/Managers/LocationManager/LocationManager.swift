//
//  LocationManager.swift
//  ArtStation
//
//  Created by Apple on 15/06/2021.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol LocationManagerDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
   
    
    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    
    
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    static var userLocation: CLLocation?
    var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
       // locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
        self.initialize()
    }
    
    func currentStatus()->String
    {
    if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
        
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        @unknown default:
            return "restricted"
        }
    } else {
        return "notEnabled"
    }
    }
    
    func initialize()
    {
        if (UserDefaults.standard.object(forKey: "USERLOCATION") != nil) {
            
        let data:NSData = UserDefaults.standard.object(forKey: "USERLOCATION") as! NSData
        LocationManager.userLocation=NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? CLLocation
        }
    }
    
    func setUserLocation(_ userLocation: CLLocation)
    {
        LocationManager.userLocation=userLocation
        let data:NSData = NSKeyedArchiver.archivedData(withRootObject: userLocation) as NSData
        UserDefaults.standard.set(data, forKey: "USERLOCATION")
        
    }
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    
    func getAuthorizationStatus() -> CLAuthorizationStatus?{
        return locationManager?.authorizationStatus
    }
    
    
    func checkAuthorization() -> Bool{
        if CLLocationManager.locationServicesEnabled(){
            
            switch CLLocationManager.authorizationStatus(){
            
            case .notDetermined,.restricted,.denied:
                return false
            case .authorizedAlways,.authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        }
        return false
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last(current) location
        currentLocation = location
        
        // use for real time update location
        setUserLocation(location)
        updateLocation(location)
    }
    
    
    func requestForLocationPermission(){
        
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            debugPrint("Successfull")
            locationManager?.startUpdatingLocation()
        
        case .denied:
            debugPrint("Denied")
        default:
            debugPrint("Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        updateLocationDidFailWithError(error as NSError)
    }
    
    // Private function
    fileprivate func updateLocation(_ currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    fileprivate func updateLocationDidFailWithError(_ error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    func getAddressFromLocation( Address : @escaping ( _ returnAddress :String)->Void)
     {
         var currentAddress = String()
         let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate((LocationManager.userLocation?.coordinate)!) { response , error in
            if let address = response?.firstResult() {
                debugPrint("UserCoordinates",LocationManager.userLocation?.coordinate)
                let lines = address.lines! as [String]
                
                //currentAddress = lines.joinWithSeparator("\n")
                currentAddress=lines.joined(separator: "\n")
                
                Address(currentAddress)
                
            }
        }
    }
}
