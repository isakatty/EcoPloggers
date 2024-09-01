//
//  PloggersViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import Foundation

import RxSwift
import RxCocoa

final class PloggersViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let headerTapEvent: PublishRelay<IndexPath>
        let headerText: PublishRelay<String>
        let meetupCellTap: PublishRelay<ViewPostDetailResponse>
        let regionCellTap: PublishRelay<Region>
        let plusBtnTap: ControlEvent<Void>
        let searchBarTap: ControlEvent<Void>
    }
    struct Output {
        let sections: BehaviorRelay<[MultiSectionModel]>
        let postRouter: PublishRelay<PostRouter>
        let naviTitle: PublishRelay<String>
        let meetupCellTap: PublishRelay<ViewPostDetailResponse>
        let regionCellTap: PublishRelay<Region>
        let plusBtnTap: ControlEvent<Void>
        let searchBarTap: ControlEvent<Void>
    }
    func transform(input: Input) -> Output {
        let sectionData = BehaviorRelay<[MultiSectionModel]>(value: [])
        let postRouter = PublishRelay<PostRouter>()
        
        input.viewWillAppear
            .debug("VM - ViewWillAppear")
            .subscribe(with: self) { owner, _ in
                owner.fetchSections { sections in
                    sectionData.accept(sections.sorted())
                    dump(sections)
                }
            } onError: { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        input.headerTapEvent
            .bind { indexPath in
                switch indexPath.section {
                case 2: // 찜한 모임 -> Router 만들어서 내보내줘야함
                    print("2")
                    let query = FavoriteQuery(next: nil, limit: "20")
                    let favRouter = PostRouter.fetchFavoritePost(query: query)
                    postRouter.accept(favRouter)
                case 3: // 최신글 ->
                    print("3")
                    let query = HashtagsQuery(next: nil, limit: "20", product_id: nil, hashTag: NetworkKey.hashtag.rawValue)
                    let latestRouter = PostRouter.hashtags(query: query)
                    postRouter.accept(latestRouter)
                default:
                    print("헤더")
                }
            }
            .disposed(by: disposeBag)

        
        return Output(
            sections: sectionData,
            postRouter: postRouter,
            naviTitle: input.headerText,
            meetupCellTap: input.meetupCellTap,
            regionCellTap: input.regionCellTap,
            plusBtnTap: input.plusBtnTap,
            searchBarTap: input.searchBarTap
        )
    }
}

extension PloggersViewModel {
    private func fetchSections(completion: @escaping ([MultiSectionModel]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var fetchedSections: [MultiSectionModel] = []

        dispatchGroup.enter()
        fetchBanner { result in
            if let bannerSection = result {
                fetchedSections.append(bannerSection)
            }
            dispatchGroup.leave()
        }

        let regionSection = MultiSectionModel.regionSection(title: "지역", items: Region.allCases.map { SectionItem.regionSectionItem(data: $0)})
        fetchedSections.append(regionSection)

        dispatchGroup.enter()
        fetchFavorite { result in
            if let favoriteSection = result {
                fetchedSections.append(favoriteSection)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchHashtag { result in
            if let hashtagSection = result {
                fetchedSections.append(hashtagSection)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            completion(fetchedSections)
        }
    }
    private func fetchBanner(completion: @escaping (MultiSectionModel?) -> Void) {
        let bannerQuery = ViewPostQuery(next: nil, limit: "1", product_id: NetworkKey.banner.rawValue)
        PostNetworkService.fetchPost(postQuery: bannerQuery)
            .subscribe(onSuccess: { response in
                switch response {
                case .success(let response):
                    let banner = response.toDomainProperty.data.flatMap { $0.files.map { SectionItem.bannerSectionItem(data: $0)}}
                    let bannerSection = MultiSectionModel.bannerSection(title: "", items: banner)
                    completion(bannerSection)
                default:
                    print("멈춰")
                    completion(nil)
                }
            }, onFailure: { error in
                print("Banner fetch 실패: \(error)")
                completion(nil)
            })
            .disposed(by: disposeBag)
    }
    private func fetchFavorite(completion: @escaping (MultiSectionModel?) -> Void) {
        let query = FavoriteQuery(next: nil, limit: "10")
        PostNetworkService.fetchFavPost(query: query)
            .subscribe(onSuccess: { result in
                switch result {
                case .success(let response):
                    let fav = response.toDomainProperty.data.map { SectionItem.favoriteSectionItem(data: $0)}
                    let favSection = MultiSectionModel.favoriteSection(title: "즐겨찾기 한 플로깅 모임", items: fav)
                    completion(favSection)
                default:
                    print("멈춰")
                    completion(nil)
                }
            }, onFailure: { error in
                print("Fav fetch 실패: \(error)")
                completion(nil)
            })
            .disposed(by: disposeBag)
    }
    private func fetchHashtag(completion: @escaping (MultiSectionModel?) -> Void) {
        let tagQuery = HashtagsQuery(next: nil, limit: "10", product_id: nil, hashTag: NetworkKey.hashtag.rawValue)
        PostNetworkService.fetchHashtagPost(query: tagQuery)
            .subscribe(onSuccess: { response in
                switch response {
                case .success(let response):
                    let latest = response.toDomainProperty.data.map { SectionItem.favoriteSectionItem(data: $0)}
                    let latestSection = MultiSectionModel.favoriteSection(title: "최신 모집글", items: latest)
                    completion(latestSection)
                default:
                    print("멈춰")
                    completion(nil)
                }
            }, onFailure: { error in
                print("Fav fetch 실패: \(error)")
                completion(nil)
            })
            .disposed(by: disposeBag)
    }
}

