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
    }
    struct Output {
        let postData: PublishRelay<[DetailSectionModel]>
    }
    func transform(input: Input) -> Output {
        let postData = PublishRelay<[DetailSectionModel]>()
        
        input.viewWillAppear
            .map({ _ in
                self.detailPost
            })
            .flatMap({ post in
                return ProfileNetworkService.fetchOtherProfile(userId: post.creator.user_id)
            })
            .subscribe(with: self) { owner, result in
                print(result)
                switch result {
                case .success(let response):
                    print("🅾️", response)
                    var section = [DetailSectionModel]()
                    section.append(.meetupInfoSection(title: "Top info", items: [DetailSectionItem.infoSectionItem(data: owner.detailPost)]))
                    section.append(.meetupDetailSection(title: "모임 정보", items: [DetailSectionItem.detailSectionItem(data: owner.detailPost)]))
                    section.append(.meetupMapSection(title: "위치", items: [DetailSectionItem.mapSectionItem(data: owner.detailPost)]))
                    section.append(.meetupProfileSection(title: "작성자 프로필", items: [DetailSectionItem.profileSectionItem(data: .init(post: owner.detailPost, creator: response))]))
                    postData.accept(section)
                default:
                    print("에러")
                }
            } onError: { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
        return Output(postData: postData)
    }
}
