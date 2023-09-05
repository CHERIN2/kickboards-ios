import UIKit
import GoogleMaps
import SnapKit


//MARK: - Initilization
class MapViewController: UIViewController {

    private var floatingButton: UIButton!
    private var mapView: GMSMapView!
    private var camera: GMSCameraPosition!
    private var locationManager: CLLocationManager!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPosition()
        self.view = mapView
        mapView.delegate = self
        setupFloatingButton()
    }
}


//MARK: - FloatingButton
extension MapViewController {
    
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
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view).offset(-100)
            make.trailing.equalTo(view).offset(-20)
        }
    }

    @objc private func floatingButtonTapped() {
        print("플로팅 버튼 눌림")
    }
}

//MARK: - Camera Position
extension MapViewController: GMSMapViewDelegate, CLLocationManagerDelegate {
    
    //위도 경도 변수 추후 할당
    private func setupCameraPosition() {
        
        
        camera = GMSCameraPosition()
        camera = GMSCameraPosition.camera(withLatitude: 37.58, longitude:126.98, zoom: 15)
        mapView = GMSMapView(frame: .zero, camera: camera)

    }
    
    // Current Location 권한 획득
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         if status == .authorizedWhenInUse {
             locationManager.startUpdatingLocation()
             mapView.isMyLocationEnabled = true
             mapView.settings.myLocationButton = true
         }
     }
    
    
    
    
}










