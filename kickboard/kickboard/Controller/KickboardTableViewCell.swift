//
//  KickboardTableViewCell.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/05.
//

import UIKit
import SnapKit

class KickboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func setupUI(){
        numberLabel.text = "아이고 넘버"
        addressLabel.text = "아이고 주소"
        
        setupNumberLabel()
        setupAddressLabel()
    }
    
    func setupNumberLabel() {
        numberLabel.text = "1 : "
        
        numberLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        })
    }
    
    func setupAddressLabel() {
        addressLabel.text = "서울특별시 종로구 청와대로 1길 청와대 경복궁 위에 있고 지붕이 파란색인 그 집의 주소를 말하고 싶습니다"
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakStrategy = .hangulWordPriority
        
        addressLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalTo(numberLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
        })
    }
}
