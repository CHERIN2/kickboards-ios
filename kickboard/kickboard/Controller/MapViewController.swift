import UIKit
import GoogleMaps
import GooglePlaces
import SnapKit

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    // MARK: - Initialization
    private var floatingButton: UIButton!
    private var searchBar: UISearchBar!
    private var mapView: GMSMapView!
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    private let defaultLatitude: CLLocationDegrees = 37.5759
    private let defaultLongitude: CLLocationDegrees = 126.9768


    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        initializeMapView()
        placeKickboardMarkers()
        setupFloatingButton()
        setupSearchBar()
        setUpConstraints()
//        searchBar.becomeFirstResponder()
        
    }
    
    // MARK: - MapView Setup
    private func initializeMapView() {
        setupCameraPosition(latitude: defaultLatitude, longitude: defaultLongitude)
        self.view = mapView
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    // MARK: - KickBoard Marker
    private func placeKickboardMarkers() {
        for kickboard in dummyData {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: kickboard.locationY, longitude: kickboard.locationX)
            marker.title = "\(kickboard.number)"
            marker.userData = kickboard
            
            if kickboard.kickboardStatus {
                marker.icon = UIImage(systemName: "circle.fill")
            } else {
                marker.icon = UIImage(systemName: "circle")
            }
            marker.map = mapView
        }
    }
    
    
    // MARK: - Action Sheet
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let kickboard = marker.userData as? Kickboard {
            print("action sheet")
            return true
        }
        return false
    }

    
    // MARK: - Constraints Setup
    private func setUpConstraints() {
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view).offset(-100)
            make.trailing.equalTo(view).offset(-20)
            
            searchBar.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
                make.left.right.equalTo(view)
                make.height.equalTo(44)
            }
        }
    }
    
    // MARK: - SearchBar setup
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Location"
        searchBar.delegate = self
        searchBar.isUserInteractionEnabled = true
        view.addSubview(searchBar)
    }
    
    //MARK: - FlotingButton Setup
    private func setupFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton.setImage( UIImage(systemName: "scope"), for: .normal)
        floatingButton.tintColor = .black
        floatingButton.backgroundColor = .white
        floatingButton.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        floatingButton.layer.shadowOpacity = 20
        floatingButton.layer.cornerRadius = 25
        floatingButton.layer.borderColor = UIColor.black.cgColor
        floatingButton.layer.borderWidth = 1.0
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        view.addSubview(floatingButton)
    }

    
    // MARK: - FloatingButton Action
    @objc private func floatingButtonTapped() {
        print("floatingButton Tapped")
        func findCurrentLocation() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
            default:
                print("Location access not granted")
            }
        }
        findCurrentLocation()
    }
    
    // MARK: - Camera Position

    private func setupCameraPosition(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        if mapView == nil {
            mapView = GMSMapView(frame: self.view.bounds, camera: camera)
        } else {
            mapView.camera = camera
        }
    }
}

// MARK: - Find Current Location (CLLocationManagerDelegate)
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        setupCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
    }
}


//MARK: - SearchBar Delegate

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("제발1")
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("제발2")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)

    }
}

//MARK: - GMSAutocompleteViewControllerDelegate

extension MapViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        setupCameraPosition(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        searchBar.text = place.name
        dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("GMSAutocompleteViewController error")
    }
}


