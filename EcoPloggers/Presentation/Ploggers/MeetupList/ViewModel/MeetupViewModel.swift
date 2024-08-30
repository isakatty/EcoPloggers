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
        let paginationTrigger: PublishRelay<Bool>
    }
    struct Output {
        let meetupList: BehaviorRelay<[ViewPostDetailResponse]>
        let cellTapEvent: PublishRelay<ViewPostDetailResponse>
    }
    func transform(input: Input) -> Output {
        let lists = BehaviorRelay<[ViewPostDetailResponse]>(value: [])
        
        var next_cursor: String = ""
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                switch owner.router {
                case .fetchFavoritePost(let query):
                    return PostNetworkService.fetchFavPost(query: query)
                        .map { $0.toCommonResult() }
                        .flatMap { result in
                            switch result {
                            case .success(let response):
                                next_cursor = response.next_cursor
                                print(response.next_cursor, "Fav - next")
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
                                next_cursor = response.next_cursor
                                print(next_cursor, "HashTag")
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
        
        input.paginationTrigger
            .withUnretained(self)
            .flatMap { owner, isTriggered in
                if isTriggered && next_cursor != "0"  {
                    switch owner.router {
                    case .hashtags(let hashQuery):
                        var tagQuery = hashQuery
                        tagQuery.next = next_cursor
                        return PostNetworkService.fetchHashtagPost(query: tagQuery)
                            .map { $0.toCommonResult() }
                            .flatMap { result in
                                switch result {
                                case .success(let response):
                                    next_cursor = response.next_cursor
                                    print(next_cursor, "💥")
                                    return response.toDomain()
                                        .map { $0.data }
                                default:
                                    return Single.just([])
                                }
                            }
                    case .fetchFavoritePost(let favQuery):
                        var favoriteQuery = favQuery
                        favoriteQuery.next = next_cursor
                        return PostNetworkService.fetchFavPost(query: favoriteQuery)
                            .map { $0.toCommonResult() }
                            .flatMap { result in
                                switch result {
                                case .success(let response):
                                    next_cursor = response.next_cursor
                                    print(next_cursor, "💥")
                                    return response.toDomain()
                                        .map { $0.data }
                                default:
                                    return Single.just([])
                                }
                            }
                    default:
                        return Single.just([])
                    }
                } else {
                    return Single.just([])
                }
            }
            .subscribe(onNext: { newItems in
                lists.accept(lists.value + newItems)
            })
            .disposed(by: disposeBag)

        return Output(
            meetupList: lists,
            cellTapEvent: input.cellTapEvent
        )
    }
    
}
