import UIKit
import FirebaseAuth

class MyPageViewController: UIViewController {
    @IBOutlet weak var loginEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
                loginEmailLabel.text = user.email ?? "이메일 없음"
            } else {
                loginEmailLabel.text = "로그인 상태가 아님"
            }
    }
    
    
}
