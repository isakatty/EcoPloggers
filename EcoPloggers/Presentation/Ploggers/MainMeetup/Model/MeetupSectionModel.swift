//
//  MeetupSectionModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/22/24.
//

import Foundation

import RxDataSources

enum MultiSectionModel: Comparable {
    case bannerSection(title: String, items: [SectionItem])
    case regionSection(title: String, items: [SectionItem])
    case favoriteSection(title: String, items: [SectionItem])
    case latestSection(title: String, items: [SectionItem])
    
    var sortOption: Int {
        switch self {
        case .bannerSection(_, _): return 0
        case .regionSection(_, _): return 1
        case .favoriteSection(_, _): return 2
        case .latestSection(_, _): return 3
        }
    }
    static func == (lhs: MultiSectionModel, rhs: MultiSectionModel) -> Bool {
        return lhs.sortOption == rhs.sortOption
    }
    static func < (lhs: MultiSectionModel, rhs: MultiSectionModel) -> Bool {
        return lhs.sortOption < rhs.sortOption
    }
}

enum SectionItem {
    case bannerSectionItem(data: ViewPostDetailResponse)
    case regionSectionItem(data: String)
    case favoriteSectionItem(data: ViewPostDetailResponse)
    case latestSectionItem(data: ViewPostDetailResponse)
}

extension MultiSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .bannerSection(_, let items),
             .regionSection(_, let items),
             .favoriteSection(_, let items),
             .latestSection(_, let items):
            return items
        }
    }
    
    init(original: MultiSectionModel, items: [SectionItem]) {
        switch original {
        case let .bannerSection(title, _):
            self = .bannerSection(title: title, items: items)
        case let .regionSection(title, _):
            self = .regionSection(title: title, items: items)
        case let .favoriteSection(title, _):
            self = .favoriteSection(title: title, items: items)
        case let .latestSection(title, _):
            self = .latestSection(title: title, items: items)
        }
    }
}
extension MultiSectionModel {
    var title: String {
        switch self {
        case .bannerSection(let title, _),
             .regionSection(let title, _),
             .favoriteSection(let title, _),
             .latestSection(let title, _):
            return title
        }
    }
}
