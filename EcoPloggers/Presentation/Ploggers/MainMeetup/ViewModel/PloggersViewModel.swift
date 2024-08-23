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
    }
    struct Output {
        let sections: BehaviorRelay<[MultiSectionModel]>
        let postRouter: PublishRelay<PostRouter>
        let naviTitle: PublishRelay<String>
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
                    let favRouter = PostRouter.favoritePost(query: query)
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
            naviTitle: input.headerText
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

        let regionSection = MultiSectionModel.regionSection(title: "지역", items: Region.allCases.map { SectionItem.regionSectionItem(data: $0.rawValue)})
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
        let banner = ViewPostQuery(next: nil, limit: "1", product_id: NetworkKey.banner.rawValue)
        PostNetworkService.fetchPost(postQuery: banner)
            .subscribe(onSuccess: { response in
                switch response {
                case .success(let data):
                    // 비동기 작업을 기다리기 위해 DispatchGroup 사용
                    let dispatchGroup = DispatchGroup()
                    var sectionItems: [SectionItem] = []
                    
                    let filePaths = data.toDomainProperty.data.flatMap { $0.files }
                    
                    for filePath in filePaths {
                        dispatchGroup.enter()
                        
                        PostNetworkService.fetchFiles(filePath: filePath)
                            .subscribe(onSuccess: { fileData in
                                let sectionItem = SectionItem.bannerSectionItem(data: fileData)
                                sectionItems.append(sectionItem)
                                dispatchGroup.leave()
                            }, onFailure: { error in
                                print("파일 다운로드 실패: \(error)")
                                dispatchGroup.leave()
                            })
                            .disposed(by: self.disposeBag)

                    }
                    dispatchGroup.notify(queue: .main) {
                        let bannerSection = MultiSectionModel.bannerSection(title: "", items: sectionItems)
                        completion(bannerSection)
                    }
                    
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
                    response.toDomain()
                        .subscribe(onSuccess: { viewPostResponse in
                            let fav = viewPostResponse.data.map { SectionItem.favoriteSectionItem(data: $0) }
                            let favSection = MultiSectionModel.favoriteSection(title: "즐겨찾기한 플로깅 모임", items: fav)
                            completion(favSection)
                        }, onFailure: { error in
                            print("ViewPostResponse 변환 실패: \(error)")
                            completion(nil)
                        })
                        .disposed(by: self.disposeBag)
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
                    response.toDomain()
                        .subscribe(onSuccess: { viewPostResponse in
                            let hash = viewPostResponse.data.map { SectionItem.latestSectionItem(data: $0) }
                            let hashtagSection = MultiSectionModel.latestSection(title: "최신 모집글", items: hash)
                            completion(hashtagSection)
                        }, onFailure: { error in
                            print("ViewPostResponse 변환 실패: \(error)")
                            completion(nil)
                        })
                        .disposed(by: self.disposeBag)
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
enum Region: String, CaseIterable {
    case eco_seoul = "서울"
    case eco_kyeongi = "경기"
    case eco_incheon = "인천"
    case eco_busan = "부산"
    case eco_daegu = "대구"
    case eco_daejeon = "대전"
    case eco_ulsan = "울산"
    case eco_kangwon = "강원"
    case eco_chungcheong = "충청"
    case eco_jeolla = "전라"
    case eco_gyeongsang = "경상"
    case eco_jeju = "제주"
}

