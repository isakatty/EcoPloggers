# EcoPloggers
플로깅(조깅+쓰레기 줍기) 모임을 만들고, 참여하고, 후기를 작성할 수 있는 앱

## 개발 환경
```
- 개발 인원 : 1명
- 개발 기간 : 2024.08 - 2024.09 (약 1달)
- Swift 5.10
- Xcode 15.3
- iOS 16.0+
- 세로모드/라이트 모드 지원
```

## 기술스택

UIKit, MVVM -In/Out pattern, 

RxSwift, RxDataSources, Alamofire,

Kingfisher, Realm, SnapKit, iamport-iOS

## 핵심기능
| 카테고리| 게시글 목록 | 검색 | 게시글 정보 |
| --- | --- | --- | --- |
|![Main](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcGBiaX%2FbtsJ07nmF82%2F4XQ5qwT1wGfrBwcky0Msa1%2Fimg.png)|![Search](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FuD0nj%2FbtsJ2bWAAZ1%2FK2zilaDaZhG84fk6l7wRq1%2Fimg.png)|![BusStop](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fc0bgZy%2FbtsJ0tLduns%2F7EpCMQGfjwLBKsAwqoRKM1%2Fimg.png)|![NearMap](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FrvC9R%2FbtsJ2bPPoqH%2FlQAaJe53emknU5Q2B3q9Ck%2Fimg.png)|



## 주요 기술
- **Architecture**
    - MVVM으로 UI와 Business Logic 분리
    - In/Output pattern의 적용을 통해 **단방향 데이터 흐름** 일관성 보장
- **Network**
    - Router 패턴으로 네트워크 작업 추상화
        - Protocol과 enum을 활용해 재사용성과 확장성을 갖춘 endpoint 및 네트워크 요청 관리
    - API 호출 메서드 간소화를 위해 Generic 활용
    - RxSwift.Single을 활용하여 네트워크 통신 실패시에도 event stream 끊기지 않게 처리
    - multipart-form data로 이미지 데이터 post
- **정규식 활용**
    - 정규식을 활용하여 앱단에서 유효성 확인후 서버로 재검증 처리
- **UI**
    - Composional layout을 통해 유연한 Cell layout 구성
    - RxDataSources의 SectionModelType을 채택한 데이터 모델을 만들어 섹션이 나뉜 UICollectionView 구현
- **공통 로직 처리를 위한 추상 클래스 구현**
    - BaseView, BaseViewController class를 만들어 필요한 객체에 상속시켜 보일러 플레이트 코드 감소


## 트러블슈팅
### 1. UICollectionView의 Cell Tap Event가 발생하지 않는 이슈
BaseViewController를 상속한 TrendViewController에서 UICollectionView의 셀 탭이 작동하지 않는 문제 발생.

- **문제 원인**

    - 해결 아이디어
        1. UICollectionViewCell의 layout이 제대로 잡히지 않은 문제
        2. RxSwift를 통해 이벤트 감지하는 데이터 바인딩 문제
        3. UICollectionView를 올린 ViewController에서부터의 뷰의 계층구조 설정 문제

   - **결론) BaseViewController의 viewDidLoad 시점에 호출한 키보드를 내리는 함수에 의해 Cell Tap Event 감지 불가.**

<img width="100%" alt="CellTapMiss" src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fbe1t3D%2FbtsJFpVmWab%2F2HwWL9cmWp8KxqNSR1Y9uK%2Fimg.png">

- **문제 해결**
    
    여러 가설을 세워가며 Cell Tap Event가 감지되지 않는 문제를 해결 시도.
    - 의존관계를 모두 없앤 바닐라 상태의 CollectionView를 만들어 기존 CollectionView와 비교하여 문제 원인 파악
    - 문제 해결을 위해 세운 가설에 해당하는 문제 X

    - **UITapGestureRecognizer 특성에 의한 이슈**
        - UITapGestureRecognizer의 특성상 터치 이벤트가 발생시 다른 이벤트를 해제하고 해당 gesture 이벤트만 방출
        - 따라서 viewDidLoad 시점에 해당 메서드 호출로 모든 tap 감지를 키보드를 내리는 이벤트만 방출

<div style="display: flex; justify-content: space-between;">
    <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbL8Zmm%2FbtsJEUOVqhd%2FMB8hRtrNMl7PkBLJNBwoTk%2Fimg.png" width="50%">
    <img src="https://github.com/user-attachments/assets/07aac895-59e5-419c-98dc-ccc425132644" width="50%">
</div>

</br>

- **cancelsTouchesInView = false 설정을 통해 UITapGestureRecognizer가 다른 제스쳐를 해제하지 않게 설정하여 해결**



### 2. RequestInterceptor의 retry 메서드 무한 호출 이슈
<img width="414" alt="무한Refresh" src="https://github.com/user-attachments/assets/094424c8-7c9a-4434-bfbd-e11d4df73cfd">

- **문제 원인**
    - RequestInterceptor의 retry시 Request하는 Header 확인 결과, 갱신되기 이전의 토큰을 통해 Request
    - retry이후 재통신이 일어날 때, 갱신된 토큰이 있는 Request가 생성되는 순서로 동작 X

- **문제 해결**

    - retry 이후 adapt를 통해 재통신이 일어날 때, adapt에서 Header를 갱신된 token 값을 넣어주어 해결