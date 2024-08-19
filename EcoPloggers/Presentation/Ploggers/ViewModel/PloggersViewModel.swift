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
    case daejeon = "대전"
    case ulsan = "울산"
    case kangwon = "강원"
    case chungcheong = "충청"
    case jeolla = "전라"
    case gyeongsang = "경상"
    case jeju = "제주"
    
    var queryPlogger: String {
        let common = "ecoploggers_"
        switch self {
        case .seoul:
            return common + "seoul"
        case .kyeongi:
            return common + "kyeongi"
        case .incheon:
            return common + "incheon"
        case .busan:
            return common + "busan"
        case .daegu:
            return common + "daegu"
        case .daejeon:
            return common + "daejeon"
        case .ulsan:
            return common + "ulsan"
        case .kangwon:
            return common + "kangwon"
        case .chungcheong:
            return common + "chungcheon"
        case .jeolla:
            return common + "jeolla"
        case .gyeongsang:
            return common + "gyeongsang"
        case .jeju:
            return common + "jeju"
        }
    }
}
