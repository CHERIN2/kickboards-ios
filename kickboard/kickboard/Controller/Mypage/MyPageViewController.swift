import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - initalization
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var useingKick: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var recordTableView: UITableView!
    
    var usedKick: [Kickboard] = []
    
    //MARK: - UI set
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID.text = "사용자 ID: ??"
        userID.textColor = .black
        
        if (useingKick != nil) {
            useingKick.text = "현재 킥보드 사용중이 아님"
            useingKick.textColor = .darkGray
        } else {
            useingKick.text = "?? 사용중"
            useingKick.textColor = .darkGray
        }
        
        logOutButton.tintColor = .lightGray
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        logOutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc func logout() {
        guard let user = StorageManager.fetchUserIsLogined() else { return }
        StorageManager.updateUserIsLogined(user.userID)
        
        performSegue(withIdentifier: "LogoutSegue", sender: self)
    }
}

//MARK: - tableview cell setup
extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordTableView.dequeueReusableCell(withIdentifier: "usedKickCell", for: indexPath) as! MyPageTableViewCell
        return cell
    }
    
    
}
