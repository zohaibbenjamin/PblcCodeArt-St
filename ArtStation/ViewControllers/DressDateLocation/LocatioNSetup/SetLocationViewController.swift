//
//  SetLocationViewController.swift
//  ArtStation
//
//  Created by Apple on 24/06/2021.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class SetLocationViewController: UIViewController, GMSAutocompleteViewControllerDelegate {
 
    

    var isFirstTime : Bool = true
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isOpenendToReschedule = false
    var bookingTebeRescheduled : Booking?
    var currentLat="0.00"
    var currentLong="0.000"
    var hasScheduledLocationSet = false
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtLoc: InputTextfieldWithDropDown!
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //completing 
        mapView.delegate=self
        mapView.setMinZoom(8, maxZoom: 22)
        LocationManager.sharedInstance.delegate=self
        txtLoc.imgDropDown.isHidden = true
        txtLoc.btnDropDown.isHidden = true
     
        searchBar.delegate = self
        tableDataSource = GMSAutocompleteTableDataSource()
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "SA"
    
      tableDataSource.autocompleteFilter = filter
        tableDataSource.delegate = self
        
        locationsTableView.delegate = tableDataSource
        locationsTableView.dataSource = tableDataSource
        
        if DataManager.getLanguage == Language.arabic.rawValue{
            searchBar.semanticContentAttribute = .forceRightToLeft
        }
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        debugPrint("ViewDidAppear")
        if CLLocationManager.locationServicesEnabled(){
            
            switch LocationManager.sharedInstance.getAuthorizationStatus(){
            
            case .notDetermined:
                LocationManager.sharedInstance.requestForLocationPermission()
            case .restricted,.denied:
                let alertController = UIAlertController(title: "Alert", message: "Please go to settings and turn on the location permission.", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: Utils.localizedText(text: "Settings"), style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                          return
                      }
                      if UIApplication.shared.canOpenURL(settingsUrl) {
                          UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                       }
                  }
                  let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                  alertController.addAction(cancelAction)
                  alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            case .authorizedWhenInUse,.authorizedAlways:
               break
            default:
                break
            }
            
        }else{
            showAlert(title: "Alert", message: "Allow access to your location so we can confirm nearest possible location for your event.")
        }
        
        
        
        if isOpenendToReschedule{
         setLocationAddress()
        }else{
        LocationManager.sharedInstance.startUpdatingLocation()
        }
    }
    
    @IBAction func btnCurrentLocClick(_ sender: Any) {
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    @IBAction func btnContinueClick(_ sender: Any) {
        
        if txtLoc.txtField.text == ""{
            self.showAlert(title: "Alert", message: "Please select location first")
            return
        }
        let vc = Utils.getViewController(storyboard: StoryboardId.artistPackagesStoryboard, identifier: StoryboardId.DressCalendarViewControllerId, viewController: DressCalendarViewController.self)
        
        if isOpenendToReschedule{
            vc.isOpenedToRescheduleEvent = true
            vc.bookingToReschedule = bookingTebeRescheduled
            vc.selectedLatitudeToReschedule = Double(mapView.camera.target.latitude.description)
            vc.selectedLongitudeToReschedule = Double(mapView.camera.target.longitude.description)
                vc.newAddress = txtLoc.txtField.text ?? ""
            
        }else{
           // customBookingV2.sharedInstance.lat = mapView.camera.target.latitude.description
            //customBookingV2.sharedInstance.lng = mapView.camera.target.longitude.description
            customBookingV2.sharedInstance.address = txtLoc.txtField.text ?? ""
           
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func onLocationFeildTapped(_ sender: Any) {
        
        
        // This code presents location controller on top of this view to select location when text field at the bottom is tapped
        /*
        let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self

            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                        UInt(GMSPlaceField.placeID.rawValue) |
                                                        UInt(GMSPlaceField.coordinate.rawValue)
            )
            autocompleteController.placeFields = fields
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            filter.country = "SA"
        
            autocompleteController.autocompleteFilter = filter
            present(autocompleteController, animated: true, completion: nil)
        */
 }
}


extension SetLocationViewController: LocationManagerDelegate
{
    func tracingLocation(currentLocation: CLLocation) {
        LocationManager.sharedInstance.stopUpdatingLocation()
            LocationManager.userLocation = currentLocation
            setLocationAddress()
            
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        LocationManager.sharedInstance.stopUpdatingLocation()
        LocationManager.userLocation = CLLocation.init(latitude: 0.00, longitude: 0.00)
        setLocationAddress()
    }
    
    
    func setLocationAddress()
    {
        
        var camera = GMSCameraPosition()
        if isOpenendToReschedule && !hasScheduledLocationSet{
            camera = GMSCameraPosition.camera(withLatitude:bookingTebeRescheduled?.lat ?? 0.0,longitude:bookingTebeRescheduled?.lng ?? 0.0, zoom: 16)
            hasScheduledLocationSet.toggle()
        
        }
        else{
        camera = GMSCameraPosition.camera(withLatitude:LocationManager.userLocation?.coordinate.latitude ?? 0.00,longitude:LocationManager.userLocation?.coordinate.longitude ?? 0.00, zoom: 16)
        }
            self.mapView?.animate(to: camera)
        
    }
    
}

extension SetLocationViewController:UIGestureRecognizerDelegate,GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
       
        LocationManager.sharedInstance.stopUpdatingLocation()
        LocationManager.userLocation = CLLocation.init(latitude: mapView.camera.target.latitude, longitude:  mapView.camera.target.longitude)
        LocationManager.sharedInstance.getAddressFromLocation { (Address) in
            self.txtLoc.txtField.text=Address
            
        }
        if isFirstTime{
            isFirstTime.toggle()
        }else{
            LocationManager.sharedInstance.getAddressFromLocation(Address: {
               self.searchBar.text = $0
           })
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      
        debugPrint(place.addressComponents,"PlaceInformation")
        let zoom = mapView.camera.zoom
        let camera = GMSCameraPosition.camera(withLatitude:place.coordinate.latitude,longitude:place.coordinate.longitude, zoom: zoom)
        mapView.animate(to: camera)
        dismiss(animated: true, completion: nil)
  
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

}

extension SetLocationViewController : UISearchBarDelegate{
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 || searchBar.text == nil{
            locationsTableView.isHidden = true
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }else{
            locationsTableView.isHidden = false
            tableDataSource.sourceTextHasChanged(searchText)}
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("SearchBarText \(searchBar.text ?? "")")
    }

    
}


extension SetLocationViewController: GMSAutocompleteTableDataSourceDelegate {
  func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    // Turn the network activity indicator off.
    // Reload table data.
    locationsTableView.reloadData()
  }

  func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    // Turn the network activity indicator on.
    // Reload table data.
    locationsTableView.reloadData()
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
    // Do something with the selected place.
   
    let zoom = mapView.camera.zoom
    let camera = GMSCameraPosition.camera(withLatitude:place.coordinate.latitude,longitude:place.coordinate.longitude, zoom: zoom)
    mapView.animate(to: camera)
    locationsTableView.isHidden = true
    
    self.view.endEditing(true)
    
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
    // Handle the error.
    print("Error: \(error.localizedDescription)")
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
    return true
  }
}



