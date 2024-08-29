//
//  SpecificRegionViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

import RxSwift
import RxCocoa

final class SpecificRegionViewModel: ViewModelType {
    var region: Region
    var disposeBag: DisposeBag = DisposeBag()
    
    init(region: Region) {
        self.region = region
        
        print(region)
    }
    
    struct Input {
        let selectedBorough: BehaviorRelay<Int>
        let viewWillAppear: Observable<Void>
        let cellTapEvent: PublishRelay<ViewPostDetailResponse>

    }
    struct Output {
        let categoryRegion: PublishRelay<[RegionBorough2]>
        let regionPost: PublishRelay<[ViewPostDetailResponse]>
        let cellTapEvent: PublishRelay<ViewPostDetailResponse>
        let selectedBorough: BehaviorRelay<Int>
    }
    func transform(input: Input) -> Output {
        let categoryRegion: PublishRelay<[RegionBorough2]> = .init()
        let regionPost: PublishRelay<[ViewPostDetailResponse]> = .init()
        
        input.viewWillAppear
            .withLatestFrom(input.selectedBorough)
            .withUnretained(self)
            .flatMap { owner, value in
                return owner.fetchRegionPost(index:input.selectedBorough.value, categoryRegion: categoryRegion)
            }
            .subscribe { result in
                switch result {
                case .success(let responseDTO):
                    regionPost.accept(responseDTO.toDomainProperty.data)
                default:
                    print("ERROR")
                }
            } onError: { error in
                print(error, "Specific ViewModel fetch 에러")
            }
            .disposed(by: disposeBag)
        
        input.selectedBorough
            .skip(1)
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMap { owner, value in
                return owner.fetchRegionPost(index: value, categoryRegion: categoryRegion)
            }
            .subscribe { result in
                switch result {
                case .success(let responseDTO):
                    regionPost.accept(responseDTO.toDomainProperty.data)
                default:
                    print("ERROR")
                }
            } onError: { error in
                print(error, "Specific ViewModel fetch 에러")
            }
            .disposed(by: disposeBag)
        
        return Output(
            categoryRegion: categoryRegion,
            regionPost: regionPost,
            cellTapEvent: input.cellTapEvent,
            selectedBorough: input.selectedBorough
        )
    }
    
    private func fetchRegionPost(index: Int, categoryRegion: PublishRelay<[RegionBorough2]>) -> Single<FetchPostResult> {
        let regions = RegionBorough2.allCases
        categoryRegion.accept(regions)
        let query = ViewPostQuery(next: nil, limit: "20", product_id: regions[index].rawValue)
        return PostNetworkService.fetchPost(postQuery: query)
    }
}
