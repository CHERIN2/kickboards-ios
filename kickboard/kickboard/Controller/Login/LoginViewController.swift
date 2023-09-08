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
        let login = User (userID: typeIDField.text!, password: typePWField.text ?? "", kickboardStatus: false)
        StorageManager().fetchUser()
        // saveUser == fetchUser
        
        guard let userIDEmpty = typeIDField.text, !userIDEmpty.isEmpty,
              let userPWEmpty = typePWField.text, !userPWEmpty.isEmpty else {
            showAlert2(message: "모든 입력란을 작성하세요")
            return
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
