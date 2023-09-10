//
//  Utility.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/07.
//

import UIKit
import GoogleMaps

extension UIViewController {
    
    //MARK: -  알림창
    
    func showActionSheet(title: String, completion: @escaping (Bool) -> Void) {
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            completion(true)
        }
        
        let actionSheetController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        actionSheetController.addAction(cancel)
        actionSheetController.addAction(action)
        
        present(actionSheetController, animated: true)
    }

    func showAlert(title: String, message: String?) {
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        let action = UIAlertAction(title: "확인", style: .default)
        
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actionSheetController.addAction(cancel)
        actionSheetController.addAction(action)
        
        present(actionSheetController, animated: true)
    }
    
   //MARK: - 화면 가운데 팝업 알람창
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: - 대여하기
    //true 반납
    //false 사용 등록
    //파라미터 및 함수명 변경해야함
    func  registerKickboard(_ kickboard: inout Kickboard) {
        guard let user = StorageManager.fetchUserIsLogined() else { return }
        
        let record = UserRideRecord(userID: user.userID, kickboardNumber: kickboard.number)
    
        StorageManager.updateUserKickboardStatus()
        StorageManager.updateKickboard(kickboard)
        StorageManager.insertUserRideRecord(record)


    }
    
    //MARK: - 반납하기
    func returnKickboard(for coordinate: CLLocationCoordinate2D) {
        if let user = StorageManager.fetchUserIsLogined(), let rideRecord = StorageManager.fetchUserRideRecord(for: user.userID) {
            let currentlyRentedKickboardNumber = rideRecord.kickboardNumber
            
            print(":::::: 반납한 유저: \(user.userID)")
            print(":::::: 반납한 킥보드: \(currentlyRentedKickboardNumber)")
            
            if let rentedKickboard = StorageManager.getKickboard(byNumber: currentlyRentedKickboardNumber) {
                var updatedKickboard = rentedKickboard
                updatedKickboard.kickboardStatus = false
                updatedKickboard.locationX = coordinate.longitude
                updatedKickboard.locationY = coordinate.latitude
                StorageManager.updateKickboard(updatedKickboard)
            }
            
            var updatedUser = user
            updatedUser.userKickboardStatus = false
            StorageManager.updateUserKickboardStatus()
        }
    }
}

