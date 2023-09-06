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
    
    func findCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        /*
         guard let location = locations.last else { return }
         
         이 코드를 사용해서 현재 위치를 받아오겠지만, kickboard 더미 데이터가 광화문 근처에 있으므로 확인을 위해
         광화문의 위도와 경도(fakeLocation)를 사용해서 확인하기로 함
         */
        
        let fakeLocation = CLLocation(latitude: 37.5741, longitude: 126.9768)
        findAddress(at: fakeLocation) { (address) in
            if let address = address {
                DispatchQueue.main.async {
                    self.currentLocationLabel.text = "현재 위치: \(address)"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("에러: \(error.localizedDescription)")
    }
    
    func findAddress(at location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let placemark = placemarks?.first {
                
                guard let locality = placemark.locality,
                      let thoroughfare = placemark.thoroughfare,
                      let subThoroughfare = placemark.subThoroughfare else { return }
                
                let address = "\(locality) \(thoroughfare) \(subThoroughfare)"
                completion(address)
                
                if let error = error {
                    print("에러: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
}
