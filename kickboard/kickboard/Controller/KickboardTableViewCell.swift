//
//  KickboardTableViewCell.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/05.
//

import UIKit
import SnapKit
import CoreLocation

class KickboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func setupNumberLabel(wiht number: Int) {
        numberLabel.text = "\(number) : "
        
        numberLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        })
    }
    
    func setupAddressLabel(latitude: Double, longitude: Double) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        findAddress(at: location) { (address) in
            if let address = address {
                DispatchQueue.main.async {
                    self.addressLabel.text = "\(address)"
                }
            }
        }

        addressLabel.numberOfLines = 0
        addressLabel.lineBreakStrategy = .hangulWordPriority
        
        addressLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalTo(numberLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
        })
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
