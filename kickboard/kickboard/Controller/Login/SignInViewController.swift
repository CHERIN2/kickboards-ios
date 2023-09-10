import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    // MARK: - initalization
    @IBOutlet weak var signInTitle: UILabel!
    @IBOutlet weak var signInDesciption: UILabel!
    @IBOutlet weak var signinIDField: UITextField!
    @IBOutlet weak var signInPWField: UITextField!
    @IBOutlet weak var signINButton: UIButton!
    
    // MARK: - userdefault set
    @IBAction func signInTap(_ sender: Any) {
        if let userID = signinIDField.text, userID.isEmpty,
           let userPW = signInPWField.text, userPW.isEmpty {
            showAlert(title: "입력란", message: "모든 입력란을 작성하세요")
        } else {
            var allUsers = StorageManager.fetchAllUser()
            
            let signtoin = User(userID: signinIDField.text!, password: signInPWField.text ?? "", kickboardStatus: false, isLogined: false)
            allUsers?.append(signtoin)
            
            guard let allUsers = allUsers else { return }
            
            StorageManager.saveUser(user: allUsers)
            
            showAlert(title: "", message: "회원가입 축하합니다") { (action) in
                if action {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - UI SET
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInTitle.text = "회원가입하기"
        signInTitle.font = .boldSystemFont(ofSize: 20.0)
        
        signInDesciption.text = "여기서 우리의 킥보드와 함께해보세요"
        signInDesciption.textColor = .darkGray
        
        signINButton.tintColor = .lightGray
        
        signinIDField.layer.borderColor = UIColor.black.cgColor
        signinIDField.placeholder = "ID를 입력해주세요"
        
        signInPWField.layer.borderColor = UIColor.black.cgColor
        signInPWField.placeholder = "비밀번호를 입력해주세요"
        signInPWField.isSecureTextEntry = true
    }
}
