//
//  MeetupDetailViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import Foundation

import iamport_ios
import RxSwift
import RxCocoa

final class MeetupDetailViewModel: ViewModelType {
    var detailPost: ViewPostDetailResponse
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(detailPost: ViewPostDetailResponse) {
        self.detailPost = detailPost
        
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let followTapEvent: PublishRelay<String>
        let commentHeaderTap: PublishRelay<Void>
        let engageBtnTap: PublishRelay<ViewPostDetailResponse>
        let paymentResponse: PublishRelay<IamportResponse>
    }
    struct Output {
        let postData: PublishRelay<[DetailSectionModel]>
        let detailPost: PublishRelay<ViewPostDetailResponse>
        let followState: PublishRelay<FollowState>
        let paymentOutput: PublishRelay<IamportPayment?>
    }
    func transform(input: Input) -> Output {
        let postData = PublishRelay<[DetailSectionModel]>()
        let detailPost = PublishRelay<ViewPostDetailResponse>()
        let isSuccessFollow = PublishRelay<FollowState>()
        let paymentOutput: PublishRelay<IamportPayment?> = .init()
        
        input.viewWillAppear
            .withUnretained(self)
            .map({ vm, _ in
                return vm.detailPost
            })
            .flatMapLatest({ post in
                return ProfileNetworkService.fetchOtherProfile(userId: post.creator.user_id)
            })
            .subscribe(with: self) { owner, result in
                
//                var posts = UserDefaultsManager.shared.postLists
//                posts.append(owner.detailPost)
//                UserDefaultsManager.shared.postLists = posts
                
                var section = [DetailSectionModel]()
                section.append(.meetupInfoSection(title: "Top info", items: [DetailSectionItem.infoSectionItem(data: owner.detailPost)]))
                section.append(.meetupDetailSection(title: "모임 정보", items: [DetailSectionItem.detailSectionItem(data: owner.detailPost)]))
                section.append(.meetupCommentsSection(title: "댓글", items: [DetailSectionItem.commentSectionItem(data: owner.detailPost)]))
                
                switch result {
                case .success(let response):
                    section.append(.meetupProfileSection(title: "작성자 프로필", items: [DetailSectionItem.profileSectionItem(data: .init(post: owner.detailPost, creator: response))]))
                    postData.accept(section)
                default:
                    section.append(.meetupProfileSection(title: "작성자 프로필", items: [DetailSectionItem.profileSectionItem(data: .init(post: owner.detailPost, creator: .init(user_id: owner.detailPost.creator.user_id, nick: owner.detailPost.creator.nick, profileImage: owner.detailPost.creator.profileImage, followers: [], following: [], posts: [])))]))
                    postData.accept(section)
                }
            } onError: { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        input.followTapEvent
            .flatMap { userID in
                return FollowNetworkService.follow(userID: userID)
            }
            .subscribe { result in
                switch result {
                case .success(let response):
                    print(response)
                    isSuccessFollow.accept(.success)
                case .alreadyFollowed:
                    print("이미 followed")
                    isSuccessFollow.accept(.cancel)
                default:
                    print("나머지 에러")
                    isSuccessFollow.accept(.failure)
                }
            } onError: { err in
                print("error: \(err)")
                isSuccessFollow.accept(.failure)
            }
            .disposed(by: disposeBag)
        
        input.commentHeaderTap
            .bind(with: self) { owner, _ in
                detailPost.accept(owner.detailPost)
            }
            .disposed(by: disposeBag)
        
        input.engageBtnTap
            .map { postData -> IamportPayment? in
                guard let apiKey = Constant.NetworkComponents.apiKey else {
                    print("🔑 API Key error")
                    return nil
                }
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(apiKey)_\(Int(Date().timeIntervalSince1970))",
                    amount: String(postData.prices ?? 1000)
                ).then {
                    $0.pay_method = PayMethod.card.rawValue
                    $0.name = postData.title
                    $0.buyer_name = postData.creator.nick
                    $0.app_scheme = "ecoPloggers"
                }
                
                return payment
            }
            .bind(to: paymentOutput)
            .disposed(by: disposeBag)
        
        input.paymentResponse
            .withUnretained(self)
            .map { vm, response -> PaymentQuery in
                guard let isSuccess = response.success,
                      let imp_uid = response.imp_uid 
                else {
                    return PaymentQuery(imp_uid: "", post_id: "")
                }
                
                if isSuccess {
                    let paymentQuery = PaymentQuery(imp_uid: imp_uid, post_id: vm.detailPost.post_id)
                    return paymentQuery
                } else {
                    return PaymentQuery(imp_uid: "", post_id: "")
                }
            }
            .flatMap { query in
                return PaymentNetworkService.validatePayment(query: query)
            }
            .subscribe { result in
                print("4 - subscribe")
                switch result {
                case .success(let payment):
                    print(payment)
                case .alreadyValidated:
                    print("이미 validate?")
                case .disappearPost:
                    print("post 없음")
                case .forbidden:
                    print("forbidden")
                case .invalidPayment:
                    print("payment 실패")
                case .invalidToken:
                    print("토큰 오류")
                case .error(let error):
                    print("err: \(error.localizedDescription)")
                default:
                    print("실패")
                }
            } onError: { err in
                print("err: \(err)")
            }
            .disposed(by: disposeBag)

        
        
        return Output(
            postData: postData,
            detailPost: detailPost,
            followState: isSuccessFollow,
            paymentOutput: paymentOutput
        )
    }
}
