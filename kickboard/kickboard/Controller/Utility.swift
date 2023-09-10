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
    



    //MARK: - 대여하기
    //true 반납
    //false 사용 등록
    //파라미터 및 함수명 변경해야함
    func  registerKickboard(_ kickboard: inout Kickboard, isReturn: Bool) {
        
        
        
        //로그인된 유저정보, 픽한 킥보드정보, 사용기록정보 다끌고오기
        var user = StorageManager.fetchUserIsLogined()!
//        let rideRecord = StorageManager.fetchUserRideRecord(for: user.userID)!
        let newRideRecord = UserRideRecord(userID: user.userID, kickboardNumber: kickboard.number)

        var kickBoard = StorageManager.getKickboard(byNumber: newRideRecord.kickboardNumber)
        
        print(":::::: 로그인한 유저: \(user.userID)")
        
        if isReturn {
            
            // 반납하면 해야할 일
            // 1. 유저정보 userKickboardStatus -> false
            // 2. 킥보드정보 kickboardStatus -> false, 위치값 넣어주기
            
            user.kickboardStatus = false
            kickboard.kickboardStatus = false
            print(":::::: 반납한 킥보드: \(kickBoard)")

        } else {
            
            // 대여하면 해야할일
            // 1. 유저정보 userKickboardStatus -> true
            // 2. 킥보드정보 kickboardStatus -> true, UserID -> user
            // 3. 이용기록 UserID -> user, KickboardNumber -> kickBoard
            
            user.kickboardStatus = true
            kickboard.kickboardStatus = true
            kickboard.userID = user.userID
            
            StorageManager.insertUserRideRecord(newRideRecord)

            print(":::::: 대여한 킥보드: \(kickBoard)")

        }
        StorageManager.updateUserKickboardStatus()
        StorageManager.updateKickboard(kickboard)

    }
    
}

//MARK: - 이미지 사이즈 조절
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
