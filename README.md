# 3대 측정기 iOS 애플리케이션 소개

**3대 측정기**는 스쿼트, 데드리프트, 벤치프레스 세 가지 주요 운동의 기록을 입력하고, 영상으로 인증하며, 다른 사용자들과 랭킹을 비교할 수 있는 iOS 기반 피트니스 기록 앱입니다. Firebase를 기반으로 로그인, 영상 저장, 운동 기록, 랭킹 시스템이 통합되어 있습니다.

## 시연 영상

https://youtu.be/ZQXDd9HElAY

## 주요 기능

1. **회원가입 및 로그인**

   * Firebase Authentication을 이용한 이메일 기반 로그인 및 회원가입 기능
   * 입력 검증 및 로그인 실패 안내 팝업 제공

2. **운동 기록 업로드**

   * 사용자가 운동 종목(스쿼트/데드리프트/벤치프레스)을 선택
   * 중량을 입력하고, iOS 사진 보관함에서 영상을 선택
   * Firebase Storage에 영상을 업로드하고, Firestore에 기록 저장

3. **내 운동 기록 확인 (마이페이지)**

   * 로그인한 사용자의 기록만 필터링하여 테이블 형식으로 보여줌
   * 기록 항목: 운동 종목, 중량(kg), 날짜

4. **운동 랭킹 확인**

   * 선택한 운동 종목별로 다른 사용자들의 기록을 조회 가능
   * 기록은 중량 순으로 정렬되어 상위 사용자 랭킹이 표시됨
   * 각 항목을 탭하면 영상이 AVPlayer를 통해 재생됨

## 화면 구성

### 1. 로그인 화면
<img width="300" height="600" src="https://github.com/user-attachments/assets/603b7112-fe3b-456c-b49e-f0f01842aa60">

* 이메일과 비밀번호를 입력
* 로그인 또는 회원가입 버튼 클릭 시 Firebase 연동

### 2. 메인 화면
<img width="300" height="600" src="https://github.com/user-attachments/assets/10fd7eac-a03a-4b2a-a3cf-03959e92511b">

* 업로드, 랭킹, 마이페이지 기능으로 이동하는 버튼 제공

### 3. 영상 업로드 화면
<img width="300" height="600" src="https://github.com/user-attachments/assets/811c2b22-af98-4d1f-ae4e-6cd4b360a7e5">


* 종목 선택, 중량 입력, 영상 선택
* 업로드 버튼 클릭 시 Firebase Storage와 Firestore에 저장

### 4. 랭킹 화면
<img width="300" height="600" src="https://github.com/user-attachments/assets/5768044e-91f4-4f53-b569-e8f792580475">

* 세 가지 운동 종목 중 선택 가능
* 종목별 랭킹을 테이블뷰로 표시 (이메일, 중량, 날짜)
* 셀을 클릭하면 영상 재생

### 5. 마이페이지 화면
<img width="300" height="600" src="https://github.com/user-attachments/assets/2484b36d-f45c-4acf-9798-e71dbb304fb2">

* 로그인한 사용자 이메일 표시
* 본인의 운동 기록만 목록으로 표시됨

## 내부 구조 (ViewController 기반)

* `LoginViewController.swift` : 로그인/회원가입 처리
* `MainViewController.swift` : 메인 진입화면
* `UploadViewController.swift` : 영상 및 운동 기록 업로드
* `RankingViewController.swift` : 종목별 랭킹 표시 및 영상 재생
* `MyPageViewController.swift` : 내 운동 기록 조회
* `MyWorkoutCell.swift` : 마이페이지용 테이블뷰 셀
* `RankingCell.swift` : 랭킹 표시용 테이블뷰 셀

## 사용된 기술 스택

* iOS (Swift + UIKit)
* Firebase Authentication
* Firebase Firestore (운동 데이터 저장)
* Firebase Storage (영상 저장)
* AVKit (영상 재생)
* PHPicker (영상 선택)

