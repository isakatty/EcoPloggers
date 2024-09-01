//
//  MyProfileViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/2/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyProfileViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let segmented: ControlProperty<Int>
        let logout: PublishRelay<Void>
    }
    struct Output {
        let myProfile: PublishRelay<ProfileResponse>
        let posts: PublishRelay<[ViewPostDetailResponse]>
        let logoutResult: PublishRelay<Bool>
    }
    func transform(input: Input) -> Output {
        let myProfile: PublishRelay<ProfileResponse> = .init()
        let posts: PublishRelay<[ViewPostDetailResponse]> = .init()
        let logoutResult: PublishRelay<Bool> = .init()
        
        input.viewWillAppear
            .subscribe(with: self) { owner, _ in
                owner.fetchProfile { response in
                    if let response {
                        myProfile.accept(response)
                    }
                }
            } onError: { owner, err in
                print(err, "transform VM")
            }
            .disposed(by: disposeBag)

        input.segmented
            .subscribe(with: self) { owner, segmented in
                switch segmented {
                case 0:
                    owner.fetchMyPosts { response in
                        if let response {
                            posts.accept(response)
                        }
                    }
                case 1:
                    owner.fetchFavPosts { response in
                        if let response {
                            posts.accept(response)
                        }
                    }
                default:
                    print("default")
                }
            } onError: { owner, err in
                print(err, "transform VM")
            }
            .disposed(by: disposeBag)

        input.logout
            .subscribe { _ in
                UserDefaultsManager.shared.accessToken = ""
                UserDefaultsManager.shared.refreshToken = ""
                UserDefaultsManager.shared.myUserID = ""
                
                logoutResult.accept(true)
            } onError: { err in
                print(err)
            }
            .disposed(by: disposeBag)

        
        return Output(
            myProfile: myProfile,
            posts: posts,
            logoutResult: logoutResult
        )
    }
}
extension MyProfileViewModel {
    private func fetchProfile(completion: @escaping (ProfileResponse?) -> Void) {
        ProfileNetworkService.fetchMyProfile()
            .subscribe(with: self) { owner, result  in
                switch result {
                case .success(let response):
                    print(response)
                    completion(response)
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
    private func fetchFavPosts(completion: @escaping ([ViewPostDetailResponse]?) -> Void) {
        let query = FavoriteQuery(next: nil, limit: "20")
        PostNetworkService.fetchFavPost(query: query)
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response.toDomainProperty.data)
                default:
                    completion(nil)
                }
            } onFailure: { error in
                print("err")
                completion(nil)
            }
            .disposed(by: self.disposeBag)
    }
    private func fetchMyPosts(completion: @escaping ([ViewPostDetailResponse]?) -> Void) {
        let query = ViewPostQuery(next: nil, limit: "20", product_id: nil)
        PostNetworkService.fetchMyPosts(query: query)
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response.toDomainProperty.data)
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
