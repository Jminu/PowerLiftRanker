import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // @IBOutlet weak var loginEmailLabel: UILabel!
    // @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loginEmailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var workoutHistory: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Auth.auth().currentUser {
            loginEmailLabel.text = user.email ?? "이메일 없음"
            fetchWorkoutHistory(forUID: user.uid)
        } else {
            loginEmailLabel.text = "로그인 상태가 아님"
            workoutHistory = []
            tableView.reloadData()
        }
    }
    
    func fetchWorkoutHistory(forUID uid: String) {
        let db = Firestore.firestore()
        
        db.collection("workouts")
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ 사용자 운동기록 불러오기 실패: \(error)")
                    return
                }
                
                self.workoutHistory = snapshot?.documents.map { $0.data() } ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = workoutHistory[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath)
        
        // Cell Style: Subtitle로 설정되어 있어야 함
        let exercise = item["exercise"] as? String ?? "운동"
        let weight = item["weight"] as? Int ?? 0
        let timestamp = item["timestamp"] as? Timestamp
        let date = timestamp?.dateValue() ?? Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let dateStr = formatter.string(from: date)
        
        cell.textLabel?.text = "\(exercise) - \(weight)kg"
        cell.detailTextLabel?.text = dateStr
        
        return cell
    }
}

