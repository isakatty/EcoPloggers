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
        let viewWillAppear: ControlEvent<Void>
    }
    struct Output {
        let regions: BehaviorRelay<[Region]>
    }
    func transform(input: Input) -> Output {
        let regions = BehaviorRelay<[Region]>(value: Region.allCases)
        
        
        return Output(regions: regions)
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

