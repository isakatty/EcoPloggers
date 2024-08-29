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
                let posts = UserDefaultsManager.shared.postLists
                postLists.accept(posts)
            }
            .disposed(by: disposeBag)
        
        return Output(postLists: postLists)
    }
}
