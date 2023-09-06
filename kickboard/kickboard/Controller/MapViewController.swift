import UIKit
import GoogleMaps
import SnapKit

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    // MARK: - Initialization
    private var floatingButton: UIButton!
    private var mapView: GMSMapView!
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    private let defaultLatitude: CLLocationDegrees = 37.5759
    private let defaultLongitude: CLLocationDegrees = 126.9768

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMapView()
        setupFloatingButton()
        setUpConstraints()
    }
    
    // MARK: - MapView Setup
    private func initializeMapView() {
        setupCameraPosition(latitude: defaultLatitude, longitude: defaultLongitude)
        self.view = mapView
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    // MARK: - Constraints Setup
    private func setUpConstraints() {
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view).offset(-100)
            make.trailing.equalTo(view).offset(-20)
        }
        
        //서치바 위치넣을 예정
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






