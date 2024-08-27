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
        let regionName: PublishRelay<String>
        let regionPost: PublishRelay<[ViewPostDetailResponse]>
        let cellTapEvent: PublishRelay<ViewPostDetailResponse>
    }
    func transform(input: Input) -> Output {
        let regionName: PublishRelay<String> = .init()
        let regionPost: PublishRelay<[ViewPostDetailResponse]> = .init()
        
        input.viewWillAppear
            .flatMap { [weak self] _ -> Single<FetchPostResult> in
                guard let self, let seoulBorough = region.seoulBorough.values.first?.first else { return .just(.error(.unknown))}
                regionName.accept(seoulBorough.toTitle)
                let query = ViewPostQuery(next: nil, limit: "20", product_id: seoulBorough.rawValue)
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
            regionName: regionName,
            regionPost: regionPost,
            cellTapEvent: input.cellTapEvent
        )
    }
}
