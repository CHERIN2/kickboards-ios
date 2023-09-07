//
//  ViewController.swift
//  kickboard
//
//  Created by 체린 on 9/4/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dummyData = StorageManager.getAllKickboardList()
        print(dummyData)
    }
}
