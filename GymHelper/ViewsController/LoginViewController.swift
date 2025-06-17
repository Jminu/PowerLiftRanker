import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "loginImage")
    }
    
    // 로그인 버튼 터치 시
    @IBAction func LoginBtnTouched(_ sender: UIButton) {
        guard let email = idField.text, !email.isEmpty,
                  let password = pwField.text, !password.isEmpty else {
                showAlert(message: "이메일과 비밀번호를 입력해주세요.")
                return
            }

            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.showAlert(message: "로그인 실패: \(error.localizedDescription)")
                } else {
                    self.moveToNextView()
                }
            }
    }
    
    // 회원가입 버튼 터치 시
    @IBAction func RegisterBtnTouched(_ sender: UIButton) {
        guard let email = idField.text, !email.isEmpty,
                  let password = pwField.text, !password.isEmpty else {
                showAlert(message: "이메일과 비밀번호를 모두 입력해주세요.")
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.showAlert(message: "회원가입 실패: \(error.localizedDescription)")
                } else {
                    self.showAlert(message: "회원가입 성공! 이제 로그인 해주세요.")
                }
            }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    func moveToNextView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MainView")
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
}
