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
    
    let hoursTextField = UITextField()
    let hours: [String] = ["1", "2", "3", "4", "5"]
    var selectedHours: String = "1 시간"
    var selectedKickboard: Kickboard?
    
    var address: String = "현 위치"
    var kickboardsWithinRangeList: [Kickboard] = []
    
    let locationManager = CLLocationManager()
    
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
        setupHoursTextField()
    }
    
    func setupCurrentLocationLabel() {
        currentLocationLabel.text = address
        currentLocationLabel.numberOfLines = 0
        currentLocationLabel.lineBreakStrategy = .hangulWordPriority
        
        currentLocationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        findCurrentLocation()
    }
    
    func setupRidingTimeLabel() {
        ridingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(currentLocationLabel.snp.bottom).offset(30)
            make.leading.equalTo(currentLocationLabel.snp.leading)
        }
    }
    
    func setupHoursTextField() {
        hoursTextField.placeholder = "시간을 선택해 주세요"
        hoursTextField.layer.borderColor = UIColor.gray.cgColor
        hoursTextField.layer.borderWidth = 1
        hoursTextField.addTarget(self, action: #selector(showPickerView), for: .editingDidBegin)
        view.addSubview(hoursTextField)
        
        hoursTextField.snp.makeConstraints { make in
            make.top.equalTo(currentLocationLabel.snp.bottom).offset(30)
            make.leading.equalTo(ridingTimeLabel.snp.trailing).offset(10)
            make.trailing.equalTo(currentLocationLabel.snp.trailing)
        }
    }
    
    func setupKickboardTableView() {
        kickboardTableView.snp.makeConstraints { make in
            make.top.equalTo(ridingTimeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalTo(currentLocationLabel.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func findCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    func findKickboards(within range: Double, at location: CLLocation) {
        kickboardsWithinRangeList = []
        
        let availableKickboardList = StorageManager.getAllKickboardList().filter { $0.kickboardStatus == false }
        
        for kickboard in availableKickboardList {
            let kickboardLocation = CLLocation(latitude: kickboard.locationY, longitude: kickboard.locationX)
            let distance = location.distance(from: kickboardLocation)
            
            if distance <= range {
                kickboardsWithinRangeList.append(kickboard)
            }
        }
    }
    
    @objc func showPickerView() {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        hoursTextField.inputView = pickerView
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneButtonTapped))
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        hoursTextField.inputAccessoryView = toolBar
        
        hoursTextField.text = selectedHours
    }
    
    @objc func cancelButtonTapped() {
        hoursTextField.text = nil
        hoursTextField.resignFirstResponder()
    }
    
    @objc func doneButtonTapped() {
        hoursTextField.resignFirstResponder()
    }
}

extension RegistraionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "현 위치에서 500미터 반경 안에 있는 킥보드"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kickboardsWithinRangeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kickboard = kickboardsWithinRangeList[indexPath.row]
        
        let cell = kickboardTableView.dequeueReusableCell(withIdentifier: "KickboardTableViewCell", for: indexPath) as! KickboardTableViewCell
        cell.setupNumberLabel(wiht: kickboard.number)
        cell.setupAddressLabel(latitude: kickboard.locationY, longitude: kickboard.locationX)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if hoursTextField.text == "" {
            showAlert(title: "필수항목", message: "시간을 입력해 주세요")
        } else {
            showActionSheet(title: "대여 하시겠습니까?") { [self] completion in
                if completion {
                    registerKickboard(&self.kickboardsWithinRangeList[indexPath.row], isReturn: true)
             
                    findCurrentLocation()
                    
                    DispatchQueue.main.async {
                        self.kickboardTableView.reloadData()
                    }
                }
            }
        }
    }
}


extension RegistraionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(hours[row]) 시간"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHours = "\(hours[row]) 시간"
        hoursTextField.text = selectedHours
        hoursTextField.resignFirstResponder()
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
        
        findKickboards(within: 500, at: fakeLocation)
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
