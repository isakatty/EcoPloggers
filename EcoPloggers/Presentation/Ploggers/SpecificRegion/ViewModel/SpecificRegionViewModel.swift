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
        let viewWillAppear: Observable<Void>
        let cellTapEvent: PublishRelay<ViewPostDetailResponse>

    }
    struct Output {
        let categoryRegion: PublishRelay<[RegionBorough2]>
        let regionPost: PublishRelay<[ViewPostDetailResponse]>
        let cellTapEvent: PublishRelay<ViewPostDetailResponse>
    }
    func transform(input: Input) -> Output {
        let categoryRegion: PublishRelay<[RegionBorough2]> = .init()
        let regionPost: PublishRelay<[ViewPostDetailResponse]> = .init()
        
        input.viewWillAppear
            .flatMap { _ -> Single<FetchPostResult> in
                let regions = RegionBorough2.allCases
                categoryRegion.accept(RegionBorough2.allCases)
                let query = ViewPostQuery(next: nil, limit: "20", product_id: regions[0].rawValue)
                return PostNetworkService.fetchPost(postQuery: query)
            }
            .subscribe { result in
                switch result {
                case .success(let responseDTO):
                    regionPost.accept(responseDTO.toDomainProperty.data)
                case .forbidden:
                    print("엥")
                default:
                    print("419 -> interceptor 작동, badRequest ?")
                }
            } onError: { err in
                print("err: \(err)")
            }
            .disposed(by: disposeBag)

        
        
        return Output(
            categoryRegion: categoryRegion,
            regionPost: regionPost,
            cellTapEvent: input.cellTapEvent
        )
    }
}
