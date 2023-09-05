//
//  RegistraionViewController.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/05.
//

import UIKit
import SnapKit

class RegistraionViewController: UIViewController {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var ridingTimeLabel: UILabel!
    @IBOutlet weak var kickboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kickboardTableView.dataSource = self
        kickboardTableView.delegate = self
            
        setupUI()
    }
    
    func setupUI() {
        setupCurrentLocationLabel()
        setupRidingTimeLabel()
        setupKickboardTableView()
    }
    
    func setupCurrentLocationLabel() {
        currentLocationLabel.text = "현위치 : 서울특별시 종로구 청와대로 1길 청와대 경복궁 위에 있고 지붕이 파란색인 그 집의 주소를 말하고 싶습니다"
        currentLocationLabel.numberOfLines = 0
        currentLocationLabel.lineBreakStrategy = .hangulWordPriority
        
        currentLocationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
    func setupRidingTimeLabel() {
        ridingTimeLabel.isHidden = true
        
        ridingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(currentLocationLabel.snp.bottom).offset(20)
            make.leading.equalTo(currentLocationLabel.snp.leading)
            make.trailing.equalTo(currentLocationLabel.snp.trailing)
        }
    }
    
    func setupKickboardTableView() {
        kickboardTableView.snp.makeConstraints { make in
            make.top.equalTo(ridingTimeLabel.snp.bottom).offset(20)
            make.leading.equalTo(currentLocationLabel.snp.leading)
            make.trailing.equalTo(currentLocationLabel.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension RegistraionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = kickboardTableView.dequeueReusableCell(withIdentifier: "KickboardTableViewCell", for: indexPath) as! KickboardTableViewCell
        cell.setupUI()
        return cell
    }
}
