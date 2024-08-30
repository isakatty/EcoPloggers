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
                return owner.fetchPosts(with: owner.router, nextCursor: "")
            }
            .bind(onNext: { response in
                lists.accept(response.data)
            })
            .disposed(by: disposeBag)
        
        input.paginationTrigger
            .withUnretained(self)
            .flatMap { owner, isTriggered in
                if isTriggered && next_cursor != "0" {
                    return owner.fetchPosts(with: owner.router, nextCursor: next_cursor)
                } else {
                    return Single.just(ViewPostResponse(data: [], next_cursor: "0"))
                }
            }
            .do(onNext: { response in
                next_cursor = response.next_cursor
            })
            .map { $0.data }
            .subscribe(onNext: { newItems in
                let existedPosts = lists.value
                var newthings: [ViewPostDetailResponse] = newItems
                let newPosts = newthings.filter { item in !existedPosts.contains(where: { $0.post_id == item.post_id }) }
                lists.accept(existedPosts + newPosts)
            })
            .disposed(by: disposeBag)
        
        return Output(
            meetupList: lists,
            cellTapEvent: input.cellTapEvent
        )
    }
    private func fetchPosts(with router: PostRouter, nextCursor: String) -> Single<ViewPostResponse> {
        switch router {
        case .fetchFavoritePost(let query):
            var updatedQuery = query
            updatedQuery.next = nextCursor
            return PostNetworkService.fetchFavPost(query: updatedQuery)
                .map { $0.toCommonResult() }
                .flatMap { result in
                    switch result {
                    case .success(let response):
                        return response.toDomain()
                    default:
                        return Single.just(.init(data: [], next_cursor: "0"))
                    }
                }
        case .hashtags(let query):
            var updatedQuery = query
            updatedQuery.next = nextCursor
            return PostNetworkService.fetchHashtagPost(query: updatedQuery)
                .map { $0.toCommonResult() }
                .flatMap { result in
                    switch result {
                    case .success(let response):
                        return response.toDomain()
                    default:
                        return Single.just(.init(data: [], next_cursor: "0"))
                    }
                }
        default:
            return Single.just(.init(data: [], next_cursor: "0"))
        }
    }
}
