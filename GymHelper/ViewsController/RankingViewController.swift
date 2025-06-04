import UIKit
import FirebaseFirestore
import AVKit

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var rankings: [[String: Any]] = []

    let exerciseOptions = ["스쿼트", "데드리프트", "벤치프레스"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchRanking(for: exerciseOptions[0]) // 초기값
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let selectedExercise = exerciseOptions[sender.selectedSegmentIndex]
        fetchRanking(for: selectedExercise)
    }

    func fetchRanking(for exercise: String) {
        let db = Firestore.firestore()
        db.collection("workouts")
            .whereField("exercise", isEqualTo: exercise)
            .order(by: "weight", descending: true) // 내림차순으로 가져옴
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ 랭킹 가져오기 실패: \(error)")
                    return
                }

                self.rankings = snapshot?.documents.map { $0.data() } ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath)
        let item = rankings[indexPath.row]

        let email = item["email"] as? String ?? "익명"
        let weight = item["weight"] as? Int ?? 0

        cell.textLabel?.text = "\(indexPath.row + 1)위: \(email)"
        cell.detailTextLabel?.text = "중량: \(weight)kg"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = rankings[indexPath.row]

        guard let urlString = item["videoURL"] as? String,
              let url = URL(string: urlString) else {
            showAlert(message: "영상 URL을 불러올 수 없습니다.")
            return
        }

        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
            player.play()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

}

