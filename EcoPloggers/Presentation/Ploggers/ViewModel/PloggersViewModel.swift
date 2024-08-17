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
    case seoul = "서울"
    case kyeongi = "경기"
    case incheon = "인천"
    case busan = "부산"
    case daegu = "대구"
    case daegeon = "대전"
    case ulsan = "울산"
    case kangwon = "강원"
    case chungcheong = "충청"
    case jeolla = "전라"
    case gyeongsang = "경상"
    case jeju = "제주"
}
