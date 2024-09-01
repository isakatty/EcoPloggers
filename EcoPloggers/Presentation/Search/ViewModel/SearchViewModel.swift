//
//  SearchViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/29/24.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    struct Output {
        let postLists: PublishRelay<[ViewPostDetailResponse]>
    }
    func transform(input: Input) -> Output {
        let postLists: PublishRelay<[ViewPostDetailResponse]> = .init()
        
        input.viewWillAppear
            .bind { _ in
//                let posts = UserDefaultsManager.shared.postLists
//                postLists.accept(posts)
                
                let posts = RealmRepository.shared.readPosts()
                    .map {
                        ViewPostDetailResponse.init(
                            post_id: $0.post_id,
                            product_id: $0.product_id,
                            title: $0.title,
                            content: $0.content,
                            required_time: $0.required_time,
                            path: $0.path,
                            recruits: $0.recruits,
                            price: $0.price,
                            due_date: $0.due_date,
                            posted_date: $0.posted_date,
                            creator: Creator(
                                user_id: $0.creator?.user_id ?? "",
                                nick: $0.creator?.nick ?? "",
                                profileImage: $0.creator?.profileImage ?? ""
                            ),
                            files: Array($0.files),
                            joins: Array($0.joins),
                            likes2: Array($0.likes2),
                            comments: Array($0.comments.map({ Comment(comment_id: $0.comment_id, content: $0.content, createdAt: $0.createdAt, creator: Creator(
                                user_id: $0.creator?.user_id ?? "",
                                nick: $0.creator?.nick ?? "",
                                profileImage: $0.creator?.profileImage ?? ""
                            )) })),
                            hashtags: Array($0.hashtags),
                            fileData: [],
                            prices: $0.prices
                        )
                    }
                
                postLists.accept(posts)
            }
            .disposed(by: disposeBag)
        
        return Output(postLists: postLists)
    }
}
