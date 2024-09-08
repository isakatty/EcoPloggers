//
//  EditViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/8/24.
//

import Foundation

import RxSwift
import RxCocoa

final class EditViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    var detailPost: ViewPostDetailResponse
    
    init(detailPost: ViewPostDetailResponse) {
        self.detailPost = detailPost
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    struct Output {
        let wrotedPost: PublishRelay<ViewPostDetailResponse>
        let category: PublishRelay<[RegionBorough2]>
    }
    func transform(input: Input) -> Output {
        let wrotedPost: PublishRelay<ViewPostDetailResponse> = .init()
        let category: PublishRelay<[RegionBorough2]> = .init()
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                wrotedPost.accept(owner.detailPost)
                category.accept(RegionBorough2.allCases)
            }
            .disposed(by: disposeBag)
        
        return Output(
            wrotedPost: wrotedPost,
            category: category
        )
    }
}
