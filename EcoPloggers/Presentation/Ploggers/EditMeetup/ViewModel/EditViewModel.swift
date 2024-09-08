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
        let editBtnTap: ControlEvent<Void>
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let priceText: ControlProperty<String>
        let selectedCategory: PublishRelay<Int>
    }
    struct Output {
        let wrotedPost: PublishRelay<ViewPostDetailResponse>
        let category: PublishRelay<[RegionBorough2]>
        let selectedCategory: BehaviorRelay<Int>
        let isEdited: PublishRelay<Bool>
        let resultToast: PublishRelay<String>
    }
    func transform(input: Input) -> Output {
        let wrotedPost: PublishRelay<ViewPostDetailResponse> = .init()
        let category: PublishRelay<[RegionBorough2]> = .init()
        let selectedCategory: BehaviorRelay<Int> = .init(value: RegionBorough2(rawValue: detailPost.product_id ?? "eco_111262")?.toNumber ?? 3)
        let isEdited: PublishRelay<Bool> = .init()
        let resultToast: PublishRelay<String> = .init()
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                wrotedPost.accept(owner.detailPost)
                category.accept(RegionBorough2.allCases)
            }
            .disposed(by: disposeBag)
        
        input.selectedCategory
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        input.editBtnTap
            .withLatestFrom(
                Observable.combineLatest(
                    input.titleText.asObservable().distinctUntilChanged(),
                    input.contentText.asObservable().distinctUntilChanged(),
                    input.priceText.asObservable().distinctUntilChanged(),
                    input.selectedCategory.asObservable().distinctUntilChanged()
                )
            )
            .withUnretained(self)
            .map { vm, arg1 in
                let (title, content, price, _) = arg1
                
                let query = UploadPostQuery(title: title, price: Int(price) ?? 1000, content: content, required_time: "", path: "", recruits: "", priceString: "", due_date: "", product_id: vm.detailPost.product_id ?? "eco_111262", files: vm.detailPost.files)
                return query
            }
            .withUnretained(self)
            .flatMap { vm, uploadQuery in
                print(vm.detailPost.post_id)
                return PostNetworkService.editPost(postID: vm.detailPost.post_id, query: uploadQuery)
            }
            .subscribe { result in
                switch result {
                case .success(let response):
                    isEdited.accept(true)
                    resultToast.accept("수정 성공")
                default:
                    isEdited.accept(false)
                    resultToast.accept("수정 실패. 잠시후 다시 시도해주세요.")
                }
            } onError: { err in
                print(err)
            }
            .disposed(by: disposeBag)
        
        return Output(
            wrotedPost: wrotedPost,
            category: category,
            selectedCategory: selectedCategory,
            isEdited: isEdited,
            resultToast: resultToast
        )
    }
}
