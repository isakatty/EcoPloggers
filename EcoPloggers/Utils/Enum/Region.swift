//
//  Region.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

enum Region: CaseIterable, Hashable {
    case eco_seoul
    case eco_kyeongi
    case eco_incheon
    case eco_busan
    case eco_daegu
    case eco_daejeon
    case eco_ulsan
    case eco_kangwon
    case eco_chungcheong
    case eco_jeolla
    case eco_gyeongsang
    case eco_jeju
    
    var toTitle: String {
        switch self {
        case .eco_seoul: return "서울"
        case .eco_kyeongi: return "경기"
        case .eco_incheon: return "인천"
        case .eco_busan: return "부산"
        case .eco_daegu: return "대구"
        case .eco_daejeon: return "대전"
        case .eco_ulsan: return "울산"
        case .eco_kangwon: return "강원"
        case .eco_chungcheong: return "충청"
        case .eco_jeolla: return "전라"
        case .eco_gyeongsang: return "경상"
        case .eco_jeju: return "제주"
        }
    }
    var seoulBorough: [Region: [RegionBorough]] {
        return [.eco_seoul: RegionBorough.allCases]
    }
}

enum RegionBorough: String, CaseIterable {
    case eco_111261
    case eco_111151
    case eco_111311
    case eco_111181
    case eco_111191
    case eco_111201
    case eco_111301
    case eco_111212
    case eco_111221
    case eco_111281
    case eco_111231
    case eco_111241
    case eco_111273
    case eco_111274
    case eco_111123
    case eco_111121
    case eco_111131
    case eco_111142
    case eco_111141
    case eco_111152
    case eco_111161
    case eco_111291
    case eco_111171
    case eco_111251
    case eco_111262
    
    var toTitle: String {
        switch self {
        case .eco_111261: return "강남구"
        case .eco_111151: return "중랑구"
        case .eco_111311: return "노원구"
        case .eco_111181: return "은평구"
        case .eco_111191: return "서대문구"
        case .eco_111201: return "마포구"
        case .eco_111301: return "양천구"
        case .eco_111212: return "강서구"
        case .eco_111221: return "구로구"
        case .eco_111281: return "금천구"
        case .eco_111231: return "영등포구"
        case .eco_111241: return "동작구"
        case .eco_111273: return "송파구"
        case .eco_111274: return "강동구"
        case .eco_111123: return "종로구"
        case .eco_111121: return "중구"
        case .eco_111131: return "용산구"
        case .eco_111142: return "성동구"
        case .eco_111141: return "광진구"
        case .eco_111152: return "동대문구"
        case .eco_111161: return "성북구"
        case .eco_111291: return "강북구"
        case .eco_111171: return "도봉구"
        case .eco_111251: return "관악구"
        case .eco_111262: return "서초구"
        }
    }
}

enum RegionBorough2: String, CaseIterable {
    case eco_111121
    case eco_111261
    case eco_111262
    case eco_111273
    case eco_111231
    case eco_111152
    case eco_111201
    
    var toTitle: String {
        switch self {
        case .eco_111121: return "중구"
        case .eco_111261: return "강남구"
        case .eco_111262: return "서초구"
        case .eco_111273: return "송파구"
        case .eco_111231: return "영등포구"
        case .eco_111152: return "동대문구"
        case .eco_111201: return "마포구"
        }
    }
}
