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
}
