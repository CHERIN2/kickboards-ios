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
        
        guard let data = UserDefaults.standard.value(forKey: dummyKey) as? Data,
              let dummyData = try? PropertyListDecoder().decode([Kickboard].self, from: data) else { return }
        print(dummyData)
    }
}
