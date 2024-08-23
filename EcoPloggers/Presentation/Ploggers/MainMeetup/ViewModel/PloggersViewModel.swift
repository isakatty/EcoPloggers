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
    }
    struct Output {
        let sections: BehaviorRelay<[MultiSectionModel]>
    }
    func transform(input: Input) -> Output {
        let sectionData = BehaviorRelay<[MultiSectionModel]>(value: [])
        input.viewWillAppear
            .debug("VM - ViewWillAppear")
            .subscribe(with: self) { owner, _ in
                owner.fetchSections { sections in
                    sectionData.accept(sections)
                    dump(sections)
                }
            } onError: { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)

        
        return Output(sections: sectionData)
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
            completion(fetchedSections.sorted())
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
                            let hashtagSection = MultiSectionModel.favoriteSection(title: "최신 모집글", items: hash)
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

