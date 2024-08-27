//
//  MeetupDetailViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import Foundation

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
    }
    struct Output {
        let postData: PublishRelay<[DetailSectionModel]>
        let detailPost: PublishRelay<ViewPostDetailResponse>
    }
    func transform(input: Input) -> Output {
        let postData = PublishRelay<[DetailSectionModel]>()
        let detailPost = PublishRelay<ViewPostDetailResponse>()
        
        input.viewWillAppear
            .map({ _ in
                self.detailPost
            })
            .flatMapLatest({ post in
                return ProfileNetworkService.fetchOtherProfile(userId: post.creator.user_id)
            })
            .subscribe(with: self) { owner, result in
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
        
//        input.followTapEvent
//            .flatMap { userID in
//                return FollowNetworkService.follow(userID: userID)
//            }
//            .subscribe { result in
//                switch result {
//                case .success(let response):
//                    print(response)
//                case .alreadyFollowed:
//                    print("이미 followed")
//                default:
//                    print("나머지 에러")
//                }
//            } onError: { err in
//                print("error: \(err)")
//            }
//            .disposed(by: disposeBag)
        
        input.commentHeaderTap
            .bind(with: self) { owner, _ in
                detailPost.accept(owner.detailPost)
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            postData: postData,
            detailPost: detailPost
        )
    }
}
