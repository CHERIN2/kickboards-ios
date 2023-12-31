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
        
        let userID = StorageManager.fetchUserIsLogined()?.userID
        
        initializeMapView()
        placeKickboardMarkers()
        setupFloatingButton()
        setupSearchBar()
        setUpConstraints()
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
        
        mapView.clear()
        let kickboards = StorageManager.getAllKickboardList()
        
        for kickboard in kickboards {
            let kickboardMarker = GMSMarker()
            kickboardMarker.position = CLLocationCoordinate2D(latitude: kickboard.locationY, longitude: kickboard.locationX)
            kickboardMarker.title = "\(kickboard.number)"
            if kickboard.kickboardStatus {
                if let originalImage = UIImage(named: "redDot"),
                let resizedImage = originalImage.resize(to: CGSize(width: 20, height: 20)) {
                 kickboardMarker.icon = resizedImage
             }
            } else {
                if let originalImage = UIImage(named: "greenDot"),
                let resizedImage = originalImage.resize(to: CGSize(width: 20, height: 20)) {
                 kickboardMarker.icon = resizedImage
             }
            }
            kickboardMarker.map = mapView
        }
    }
    
    //MARK: - MapView Action Sheet (대여하기)
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        guard let title = marker.title, let kickboardNumber = Int(title) else { return true }
        guard let kickboard = StorageManager.getKickboard(byNumber: kickboardNumber) else { return true }
        guard !kickboard.kickboardStatus else { showAlert(title: "오류!", message: "사용중인 킥보드입니다!"); return true }
        var rentedKickboard = kickboard
        
        // 1. 액션시트 띄우기
        self.showActionSheet(title: "\(kickboard.number)번 킥보드 🛴") { [weak self] completion in
            if completion {
                //확인버튼 눌렸을 때 실행하는 클로저
                // 2. 현재 유저가 킥보드 사용중인지 확인
                if let loggedUser = StorageManager.fetchUserIsLogined(), loggedUser.kickboardStatus {
                    self?.showAlert(title: "오류!", message: "이미 다른 킥보드를 사용 중입니다!")
                    return
                }
                
                // 대여하기 공통함수 삽입
                self?.switchKickboardStatus(&rentedKickboard, to: true)
                self?.placeKickboardMarkers()
            }
        }
        return true
    }
    
    //MARK: - MapView Action Sheet (반납하기)
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        guard let loggedUser = StorageManager.fetchUserIsLogined(), loggedUser.kickboardStatus else {
            showAlert(title: "오류!", message: "킥보드 미사용 중입니다!")
            return
        }
        
        guard let rideRecord = StorageManager.fetchUserRideRecord(for: loggedUser.userID),
              var rentedKickboard = StorageManager.getKickboard(byNumber: rideRecord.kickboardNumber) else {
            showAlert(title: "오류!", message: "대여한 킥보드 정보를 찾을 수 없습니다!")
            return
        }
        
        showActionSheet(title: "반납하시겠습니까?") { _ in
            self.switchKickboardStatus(&rentedKickboard, to: false)
            rentedKickboard.locationX = coordinate.longitude
            rentedKickboard.locationY = coordinate.latitude
            StorageManager.updateKickboard(rentedKickboard)
            self.placeKickboardMarkers()
        }
    }

    // MARK: - Constraints Setup
    private func setUpConstraints() {
            
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view).offset(-100)
            make.trailing.equalTo(view).offset(-20)
            
            searchBar.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                make.left.right.equalTo(view).inset(20)
                make.height.equalTo(44)
            }
        }
    }
    
    // MARK: - SearchBar setup
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Location"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.clear
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.cornerRadius = 8.0
          }
        view.addSubview(searchBar)
        
        searchBar.searchTextField.addTarget(self, action: #selector(searchBarTapped), for: .touchUpInside)
    }
    
    @objc func searchBarTapped() {
        searchBar.becomeFirstResponder()
    }
    
    //MARK: - FlotingButton Setup
    private func setupFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton.setImage( UIImage(systemName: "scope"), for: .normal)
        floatingButton.backgroundColor = .clear
        floatingButton.tintColor = .black
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
    
    // MARK: - Cmera Position
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
        let currentMarker = GMSMarker()
        setupCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        currentMarker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        if let originalImage = UIImage(named: "blueDot"),
        let resizedImage = originalImage.resize(to: CGSize(width: 20, height: 20)) {
            currentMarker.icon = resizedImage
     }
        currentMarker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
    }
}

//MARK: - SearchBar Delegate
extension MapViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
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
