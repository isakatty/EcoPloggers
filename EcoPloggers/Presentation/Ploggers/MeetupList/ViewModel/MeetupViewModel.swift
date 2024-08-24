//
//  MeetupViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/23/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MeetupViewModel: ViewModelType {
    var router: PostRouter
    var disposeBag: DisposeBag = DisposeBag()
    
    init(router: PostRouter) {
        self.router = router
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cellTapEvent: PublishRelay<ViewPostDetailResponse>
    }
    struct Output {
        let meetupList: Driver<[ViewPostDetailResponse]>
        let cellTapEvent: PublishRelay<ViewPostDetailResponse>
    }
    func transform(input: Input) -> Output {
        let lists = BehaviorRelay<[ViewPostDetailResponse]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                switch owner.router {
                case .favoritePost(let query):
                    return PostNetworkService.fetchFavPost(query: query)
                        .map { $0.toCommonResult() }
                        .flatMap { result in
                            switch result {
                            case .success(let response):
                                return response.toDomain()
                                    .map { $0.data }
                            default:
                                return Single.just([])
                            }
                        }
                case .hashtags(let query):
                    return PostNetworkService.fetchHashtagPost(query: query)
                        .map { $0.toCommonResult() }
                        .flatMap { result in
                            switch result {
                            case .success(let response):
                                return response.toDomain()
                                    .map { $0.data }
                            default:
                                return Single.just([])
                            }
                        }
                default:
                    return Single.just([])
                }
            }
            .bind(to: lists)
            .disposed(by: disposeBag)
        
        return Output(
            meetupList: lists.asDriver(onErrorJustReturn: []),
            cellTapEvent: input.cellTapEvent
        )
    }
    
}
