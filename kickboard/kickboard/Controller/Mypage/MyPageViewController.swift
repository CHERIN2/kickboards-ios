import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - initalization
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var useingKick: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var recordTableView: UITableView!
    
    var id: String = ""
    var usedKick: [UserRideRecord] = []
    
    //MARK: - UI set
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userIsLogine = StorageManager.fetchUserIsLogined() else { return }
        id = userIsLogine.userID
        
        usedKick = StorageManager.getAllUserRideRecord().filter { $0.userID == id }
        
        setupUserID()
        setupUseingKick()
        setupTable()
        setupLogoutButton()
    }
    
    func setupUserID() {
        userID.text = "사용자 ID : \(id)"
        userID.textColor = .black
    }
    
    func setupUseingKick() {
        if usedKick.isEmpty {
            useingKick.text = "현재 사용중인 킥보드가 없습니다"
        } else {
            useingKick.text = "현재 사용중인 킥보드 :  \(String(usedKick[0].kickboardNumber)) 번"
        }
        
        useingKick.textColor = .darkGray
    }
    
    func setupTable() {
        recordTableView.delegate = self
        recordTableView.dataSource = self
    }
    
    func setupLogoutButton() {
        logOutButton.tintColor = .lightGray
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "킥보드 사용 이력"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedKick.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordTableView.dequeueReusableCell(withIdentifier: "usedKickCell", for: indexPath) as! MyPageTableViewCell
        cell.setupCell(number: usedKick[indexPath.row].kickboardNumber)
        return cell
    }
}
