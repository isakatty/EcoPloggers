//
//  DetailSectionModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import Foundation

import RxDataSources

enum DetailSectionModel: Comparable {
    case meetupInfoSection(title: String, items: [DetailSectionItem])
    case meetupDetailSection(title: String, items: [DetailSectionItem])
    case meetupCommentsSection(title: String, items: [DetailSectionItem])
    case meetupProfileSection(title: String, items: [DetailSectionItem])
    
    // 비동기로 데이터 처리를 해주는게 아니라서 sort해줄 필요가 없는데 있어야할까?
    var sortOption: Int {
        switch self {
        case .meetupInfoSection(_, _): return 0
        case .meetupDetailSection(_, _): return 1
        case .meetupCommentsSection(_, _): return 2
        case .meetupProfileSection(_, _): return 3
        }
    }
    static func == (lhs: DetailSectionModel, rhs: DetailSectionModel) -> Bool {
        return lhs.sortOption == rhs.sortOption
    }
    static func < (lhs: DetailSectionModel, rhs: DetailSectionModel) -> Bool {
        return lhs.sortOption < rhs.sortOption
    }
}

enum DetailSectionItem {
    case infoSectionItem(data: ViewPostDetailResponse)
    case detailSectionItem(data: ViewPostDetailResponse)
    case commentSectionItem(data: ViewPostDetailResponse)
    case profileSectionItem(data: ProfileSectionModel)
}

extension DetailSectionModel: SectionModelType {
    
    typealias Item = DetailSectionItem
    
    var items: [DetailSectionItem] {
        switch self {
        case .meetupInfoSection(_, let items),
             .meetupDetailSection(_, let items),
             .meetupCommentsSection(_, let items),
             .meetupProfileSection(_, let items):
            return items
        }
    }
    
    init(original: DetailSectionModel, items: [DetailSectionItem]) {
        switch original {
        case let .meetupInfoSection(title, _):
            self = .meetupInfoSection(title: title, items: items)
        case let .meetupDetailSection(title, _):
            self = .meetupDetailSection(title: title, items: items)
        case let .meetupCommentsSection(title, _):
            self = .meetupCommentsSection(title: title, items: items)
        case let .meetupProfileSection(title, _):
            self = .meetupProfileSection(title: title, items: items)
        }
    }
}
extension DetailSectionModel {
    var title: String {
        switch self {
        case .meetupInfoSection(let title, _),
             .meetupDetailSection(let title, _),
             .meetupCommentsSection(let title, _),
             .meetupProfileSection(let title, _):
            return title
        }
    }
}
