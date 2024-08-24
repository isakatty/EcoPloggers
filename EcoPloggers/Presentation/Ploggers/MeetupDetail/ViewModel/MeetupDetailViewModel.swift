//
//  MeetupDetailViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MeetupDetailViewModel: ViewModelType {
    var detailPost: ViewPostDetailResponse
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(detailPost: ViewPostDetailResponse) {
        self.detailPost = detailPost
        
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    struct Output {
        let postData: PublishRelay<[DetailSectionModel]>
    }
    func transform(input: Input) -> Output {
        let postData = PublishRelay<[DetailSectionModel]>()
        
        input.viewWillAppear
            .withUnretained(self)
            .map { _ in
                var section = [DetailSectionModel]()
                section.append(.meetupInfoSection(title: "Top info", items: [DetailSectionItem.infoSectionItem(data: self.detailPost)]))
                section.append(.meetupDetailSection(title: "모임 정보", items: [DetailSectionItem.detailSectionItem(data: self.detailPost)]))
                section.append(.meetupMapSection(title: "위치", items: [DetailSectionItem.mapSectionItem(data: self.detailPost)]))
                return section
            }
            .bind(to: postData)
            .disposed(by: disposeBag)
        
        
        return Output(postData: postData)
    }
}
