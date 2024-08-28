//
//  PostViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/28/24.
//

import Foundation

import RxSwift
import RxCocoa

final class PostViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let selectedImg: BehaviorRelay<NSItemProviderReading?>
        let viewWillAppear: Observable<Void>
        let postBtnTapEvent: ControlEvent<Void>
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let priceText: ControlProperty<String>
        let selectedCategory: BehaviorRelay<Int>
    }
    struct Output {
        let category: PublishRelay<[RegionBorough2]>
        let avaliablPostBtn: BehaviorRelay<Bool>
        let selectedCategory: BehaviorRelay<Int>
        let successUpload: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let category: PublishRelay<[RegionBorough2]> = .init()
        let avaliablPostBtn: BehaviorRelay<Bool> = .init(value: false)
        let successUpload = PublishRelay<Bool>()
        
        input.viewWillAppear
            .bind { _ in
                category.accept(RegionBorough2.allCases)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.selectedImg.map { $0 != nil },
            input.titleText.map { !$0.isEmpty },
            input.contentText.map { !$0.isEmpty },
            input.priceText.map { !$0.isEmpty },
            input.selectedCategory.map { $0 >= 0 }
        )
        .map { imgSelected, titleFilled, contentFilled, priceFilled, categorySelected in
            return imgSelected && titleFilled && contentFilled && priceFilled && categorySelected
        }
        .bind(to: avaliablPostBtn)
        .disposed(by: disposeBag)
        
        input.postBtnTapEvent
            .withLatestFrom(
                Observable.combineLatest(
                    input.titleText.asObservable(),
                    input.contentText.asObservable(),
                    input.priceText.asObservable(),
                    input.selectedCategory.asObservable(),
                    input.selectedImg.asObservable()
                )
            )
            .compactMap { (title: String, content: String, price: String, category: Int, image: NSItemProviderReading?) -> (title: String, content: String, price: String, category: Int, imageData: Data)? in
                guard let imageData = image?.changeItemToData() else {
                    return nil
                }
                return (title: title, content: content, price: price, category: category, imageData: imageData)
            }
            .flatMap { data in
                PostNetworkService.uploadImg(uploadQuery: data.imageData)
                    .flatMap { uploadData in
                        let query = UploadPostQuery(
                            title: data.title,
                            price: 1000,
                            content: data.content.addContentHashTag,
                            required_time: "45분",
                            path: nil,
                            recruits: "상시모집",
                            priceString: data.price,
                            due_date: Date().ISO8601Format(),
                            product_id: RegionBorough2.allCases[data.category].rawValue,
                            files: uploadData.files
                        )
                        return PostNetworkService.uploadPost(postQuery: query)
                    }
                    .catch { error in
                        return Single.never()
                    }
            }
            .subscribe { response in
                switch response {
                case .success(let response):
                    print("여기요")
                    dump(response)
                    successUpload.accept(true)
                case .error(let error):
                    print("여기?")
                    print(error.localizedDescription)
                    successUpload.accept(true)
                default:
                    successUpload.accept(false)
                }
            }
            .disposed(by: disposeBag)


        return Output(
            category: category,
            avaliablPostBtn: avaliablPostBtn,
            selectedCategory: input.selectedCategory,
            successUpload: successUpload
        )
    }
}
