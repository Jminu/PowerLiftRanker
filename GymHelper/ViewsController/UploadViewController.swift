import UIKit
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UploadViewController: UIViewController, PHPickerViewControllerDelegate {
    let exerciseOptions = ["스쿼트", "데드리프트", "벤치프레스"]
    
    
    @IBOutlet weak var exerciseSegment: UISegmentedControl!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var videoLabel: UILabel!
    
    var selectedVideoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectVideoBtnTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration()
                config.filter = .videos
                config.selectionLimit = 1

                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let result = results.first else { return }

            result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                guard let url = url else { return }

                // 임시 경로로 복사 (보존용)
                let fileName = UUID().uuidString + ".mov"
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

                do {
                    try FileManager.default.copyItem(at: url, to: tempURL)
                    DispatchQueue.main.async {
                        self.selectedVideoURL = tempURL
                        self.videoLabel.text = "선택된 영상: \(fileName)"
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.videoLabel.text = "영상 복사 실패"
                    }
                }
            }
        }
    
    @IBAction func uploadBtnTouched(_ sender: UIButton) {
            let exercise = exerciseOptions[exerciseSegment.selectedSegmentIndex]

            guard let weightText = weightField.text, let weight = Int(weightText) else {
                showAlert(message: "중량을 정확히 입력하세요.")
                return
            }
        
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "로그인된 사용자를 찾을 수 없습니다.")
            return
        }
        
        guard let videoURL = selectedVideoURL else {
            showAlert(message: "영상을 선택해주세요")
            return
        }
        
        // Firebase Storage에 업로드
            let storageRef = Storage.storage().reference()
            let videoName = "\(UUID().uuidString).mov"
            let videoRef = storageRef.child("videos/\(videoName)")
        
        videoRef.putFile(from: videoURL, metadata: nil) { metadata, error in
                if let error = error {
                    self.showAlert(message: "영상 업로드 실패: \(error.localizedDescription)")
                    return
                }

                // 업로드 성공 시, 다운로드 URL 가져오기
                videoRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        self.showAlert(message: "URL 가져오기 실패")
                        return
                    }

                    // Firestore에 저장할 데이터 구성
                    let data: [String: Any] = [
                        "exercise": exercise,
                        "weight": weight,
                        "uid": user.uid,
                        "email": user.email ?? "unknown",
                        "videoURL": downloadURL.absoluteString,
                        "timestamp": Timestamp(date: Date())
                    ]

                    let db = Firestore.firestore()
                    db.collection("workouts").addDocument(data: data) { error in
                        if let error = error {
                            self.showAlert(message: "업로드 실패: \(error.localizedDescription)")
                        } else {
                            self.showAlert(message: "업로드 성공! ✅") {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let mainVC = storyboard.instantiateViewController(withIdentifier: "MainView")
                                mainVC.modalPresentationStyle = .fullScreen
                                self.present(mainVC, animated: true)
                            }

                        }
                    }
                }
            }

            print("""
            ✅ 업로드 정보
            - 운동: \(exercise)
            - 중량: \(weight)
            """)
        }
    
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }

}
