import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - initalization
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var loginDesciption: UILabel!
    @IBOutlet weak var loginToSiginIn: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var typeIDField: UITextField!
    @IBOutlet weak var typePWField: UITextField!
    
    // MARK: - userdefault set
    @IBAction func loginTap(_ sender: Any) {
        
        guard let userIDEmpty = typeIDField.text, !userIDEmpty.isEmpty,
              let userPWEmpty = typePWField.text, !userPWEmpty.isEmpty else {
            showAlert2(message: "모든 입력란을 작성하세요")
            return
        }
        
        let userInfo = StorageManager.fetchAllUser()
        guard let userInfo = userInfo else {
            return
        }
        
        for i in userInfo {
            if i.userID == userIDEmpty && i.password == userPWEmpty {
                
                // isLogined를 true로 바꿔주기
                // 다음 화면으로 이동
                let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false)
            }
        }
        
        func showAlert2(message: String) {
            let alert = UIAlertController(title: "입력란 확인", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UI SET
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTitle.text = "로그인하기"
        loginTitle.font = .boldSystemFont(ofSize: 20.0)
        
        loginDesciption.text = "아직 회원이 아니시라면,"
        loginDesciption.textColor = .darkGray

        loginToSiginIn.tintColor = .black
        
        loginButton.tintColor = .lightGray
        
        typeIDField.layer.borderColor = UIColor.black.cgColor
        typeIDField.placeholder = "ID를 입력해주세요"
        
        typePWField.layer.borderColor = UIColor.black.cgColor
        typePWField.placeholder = "비밀번호를 입력해주세요"
        typePWField.isSecureTextEntry = true
        
    }
}
