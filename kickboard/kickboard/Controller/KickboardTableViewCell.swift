//
//  KickboardTableViewCell.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/05.
//

import UIKit

class KickboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func setupUI(){
        
        numberLabel.text = "아이고 넘버"
        addressLabel.text = "아이고 주소"
    }
    
}
