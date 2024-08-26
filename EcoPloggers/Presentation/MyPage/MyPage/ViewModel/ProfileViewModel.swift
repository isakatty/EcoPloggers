//
//  ProfileViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import Foundation

import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    private var cacheProfile: [ProfileResponse] = []
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let postBtnTap: PublishRelay<Void>
    }
    struct Output {
        let profileData: PublishRelay<[MyPageSectionModel]>
        let userPosted: PublishRelay<[String]>
    }
    func transform(input: Input) -> Output {
        let profileData = PublishRelay<[MyPageSectionModel]>()
        let userPosted = PublishRelay<[String]>()
        
        input.viewWillAppear
            .subscribe(with: self) { owner, _ in
                owner.fetchProfileTotalSection { sections in
                    profileData.accept(sections)
                }
            } onError: { owner, error in
                print(error, "ProfileVM - viewWillAppear")
            }
            .disposed(by: disposeBag)
        
        input.postBtnTap
            .withUnretained(self)
            .map { owner, _ in
                owner.cacheProfile.first
            }
            .bind { response in
                if let response {
                    userPosted.accept(response.posts)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            profileData: profileData,
            userPosted: userPosted
        )
    }
}
extension ProfileViewModel {
    // profile fetch -> 좋아요 데이터 fetch : completion + DispatchGroup 사용해서
    private func fetchProfileTotalSection(completion: @escaping ([MyPageSectionModel]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var fetchedSections: [MyPageSectionModel] = []
        
        dispatchGroup.enter()
        fetchProfile(title: "프로필") { result in
            if let profile = result {
                fetchedSections.append(contentsOf: profile)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchFavoritePost { result in
            if let fav = result {
                fetchedSections.append(fav)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(fetchedSections.sorted())
        }
    }
    private func fetchProfile(title: String, completion: @escaping ([MyPageSectionModel]?) -> Void) {
        ProfileNetworkService.fetchMyProfile()
            .subscribe(with: self) { owner, result  in
                switch result {
                case .success(let response):
                    var sectionItems: [MyPageSectionModel] = []
                    sectionItems.append(.profileSection(title: title, items: [MyPageSectionItem.profileSectionItem(data: response)]))
                    owner.cacheProfile.append(response)
                    completion(sectionItems)
                case .invalidToken:
                    print("invalidToken - ProfileVM - Fetch Profile")
                    completion(nil)
                case .forbidden:
                    print("forbidden - ProfileVM - Fetch Profile")
                    completion(nil)
                case .expiredToken:
                    print("419 에러 - ProfileVM - Fetch Profile")
                    completion(nil)
                case .error(let error):
                    print("에러 \(error.localizedDescription) - ProfileVM - Fetch Profile")
                    completion(nil)
                }
            } onFailure: { onwer, error in
                print("My Profile fetch 실패: \(error)")
                completion(nil)
            }
            .disposed(by: disposeBag)
    }
    private func fetchFavoritePost(completion: @escaping (MyPageSectionModel?) -> Void) {
        let query = FavoriteQuery(next: nil, limit: "10")
        PostNetworkService.fetchFavPost(query: query)
            .subscribe { result in
                switch result {
                case .success(let response):
                    response.toDomain()
                        .subscribe { response in
                            let fav = response.data.map {
                                MyPageSectionItem.favoriteSectionItem(data: $0)
                            }
                            
                            let favSection = MyPageSectionModel.favoriteSection(title: "좋아요한 모임 목록", items: fav)
                            completion(favSection)
                        } onFailure: { error in
                            print("err")
                            completion(nil)
                        }
                        .disposed(by: self.disposeBag)
                default:
                    completion(nil)
                }
            } onFailure: { error in
                print("err")
                completion(nil)
            }
            .disposed(by: self.disposeBag)

    }
}
