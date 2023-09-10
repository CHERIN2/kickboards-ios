import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - initalization
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var useingKick: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var recordTableView: UITableView!
    
    var loginedID: String = ""
    var usedKick: [Kickboard] = []
    var record: [UserRideRecord] = []
    
    //MARK: - UI set
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        guard let userIsLogine = StorageManager.fetchUserIsLogined() else { return }
        loginedID = userIsLogine.userID
        
        usedKick = StorageManager.getAllKickboardList().filter { $0.userID == loginedID }
        
        record = StorageManager.getAllUserRideRecord().filter { $0.userID == loginedID }
        recordTableView.reloadData()
        
        setupUserID()
        setupUseingKick()
        setupLogoutButton()
    }
    
    func setupUserID() {
        userID.text = "사용자 ID : \(loginedID)"
        userID.textColor = .black
    }
    
    func setupUseingKick() {
        
        guard let number = usedKick.last?.number else {
            useingKick.text = "현재 사용중인 킥보드가 없습니다"
            return
        }
        
        useingKick.text = "현재 사용중인 킥보드 :  \(number) 번"

        useingKick.textColor = .darkGray
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
        return record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordTableView.dequeueReusableCell(withIdentifier: "usedKickCell", for: indexPath) as! MyPageTableViewCell
        cell.setupCell(number: record[indexPath.row].kickboardNumber)
        return cell
    }
}
