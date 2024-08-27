//
//  CommentsViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

import RxSwift
import RxCocoa

final class CommentsViewModel: ViewModelType {
    var post: ViewPostDetailResponse
    var disposeBag: DisposeBag = DisposeBag()
    
    init(post: ViewPostDetailResponse) {
        self.post = post
        
    }
    
    struct Input {
//        let viewWillAppear: Observable<Void>
    }
    struct Output {
        let comments: PublishRelay<[Comment]>
    }
    
    func transform(input: Input) -> Output {
        let comments: PublishRelay<[Comment]> = .init()
        
        comments.accept(post.comments)
        
        return Output(comments: comments)
    }
}
