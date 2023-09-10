//
//  Utility.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/07.
//

import UIKit

extension UIViewController {
    
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
    
    //true 반납
    //false 사용 등록
    //파라미터 및 함수명 변경해야함
    func  registerKickboard(_ kickboard: inout Kickboard, isReturn: Bool) {
        guard let user = StorageManager.fetchUserIsLogined() else { return }
        
        let record = UserRideRecord(userID: user.userID, kickboardNumber: kickboard.number)
        
        if isReturn {
            
        } else {
            kickboard.userID = user.userID
        }
        
        StorageManager.updateUserKickboardStatus()
        StorageManager.updateKickboard(kickboard)
        StorageManager.insertUserRideRecord(record)
    }
}
