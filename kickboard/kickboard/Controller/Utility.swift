//
//  Utility.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/07.
//

import UIKit
import GoogleMaps

extension UIViewController {
    
    //MARK: -  ActionSheet
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
    
    //MARK: - 화면 가운데 팝업 알람창
    func showAlert(title: String, message: String?, completion: ((Bool) -> Void)? = nil) {
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            completion?(true)
        }
        
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actionSheetController.addAction(cancel)
        actionSheetController.addAction(action)
        
        present(actionSheetController, animated: true)
    }
    
    //MARK: - 킥보드 대여하기, 반납하기 공통 함수
    //status true = 사용 대여하기,
    //status false = 미사용 반납하기
    func switchKickboardStatus(_ kickboard: inout Kickboard, to status: Bool) {
        guard var user = StorageManager.fetchUserIsLogined() else { return }
//        var kickBoard = StorageManager.getKickboard(byNumber: newRideRecord.kickboardNumber)
        
        user.kickboardStatus = status
        kickboard.kickboardStatus = status
        
        StorageManager.updateUserKickboardStatus()
        StorageManager.updateKickboard(kickboard)
        
        if status {
            kickboard.userID = user.userID
            
            let newRideRecord = UserRideRecord(userID: user.userID, kickboardNumber: kickboard.number)
            StorageManager.insertUserRideRecord(newRideRecord)
        }
    }
}
