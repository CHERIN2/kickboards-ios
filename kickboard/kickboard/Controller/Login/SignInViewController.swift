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
            showAlert1(message: "공란입니다")
        } else {
            var allUsers = StorageManager.fetchAllUser()
            let signtoin = User(userID: signinIDField.text!, password: signInPWField.text ?? "", kickboardStatus: false, isLogined: false)
            allUsers?.append(signtoin)
            guard let allUsers = allUsers else { return }
            StorageManager.saveUser(user: allUsers)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    func showAlert1(message: String) {
        let alert = UIAlertController(title: "입력란 확인", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
