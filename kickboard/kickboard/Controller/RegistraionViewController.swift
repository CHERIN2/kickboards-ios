//
//  RegistraionViewController.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/05.
//

import UIKit
import SnapKit
import CoreLocation

class RegistraionViewController: UIViewController {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var ridingTimeLabel: UILabel!
    @IBOutlet weak var kickboardTableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var address: String = "현 위치"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kickboardTableView.dataSource = self
        kickboardTableView.delegate = self
        
        locationManager.delegate = self
            
        setupUI()
    }
    
    func setupUI() {
        setupCurrentLocationLabel()
        setupRidingTimeLabel()
        setupKickboardTableView()
    }
    
    func setupCurrentLocationLabel() {
        currentLocationLabel.text = address
        currentLocationLabel.numberOfLines = 0
        currentLocationLabel.lineBreakStrategy = .hangulWordPriority
        
        currentLocationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        findCurrentLocation()
    }
    
    func setupRidingTimeLabel() {
        ridingTimeLabel.isHidden = true
        
        ridingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(currentLocationLabel.snp.bottom).offset(20)
            make.leading.equalTo(currentLocationLabel.snp.leading)
            make.trailing.equalTo(currentLocationLabel.snp.trailing)
        }
    }
    
    func setupKickboardTableView() {
        kickboardTableView.snp.makeConstraints { make in
            make.top.equalTo(ridingTimeLabel.snp.bottom).offset(20)
            make.leading.equalTo(currentLocationLabel.snp.leading)
            make.trailing.equalTo(currentLocationLabel.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    //현재 위치 찾기 관련해서는 종혁님 코드랑 겹치니까 공통함수로 뺄 수 있을 것도 같다 -> 논의 필요
    func findCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension RegistraionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = kickboardTableView.dequeueReusableCell(withIdentifier: "KickboardTableViewCell", for: indexPath) as! KickboardTableViewCell
        cell.setupUI()
        return cell
    }
}

extension RegistraionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        guard let location = locations.last else { return }
        
        let fakeLocation = CLLocation(latitude: 37.5741, longitude: 126.9768)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(fakeLocation) { [self] (placemarks, error) in
            if let placemark = placemarks?.first {
                
                guard let locality = placemark.locality,
                      let thoroughfare = placemark.thoroughfare,
                      let subThoroughfare = placemark.subThoroughfare else { return }
                
                self.address = "\(locality) \(thoroughfare) \(subThoroughfare)"
                currentLocationLabel.text = "현 위치: \(self.address)"
            }
 
            if let error = error {
                print("에러: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("에러: \(error.localizedDescription)")
    }
}
