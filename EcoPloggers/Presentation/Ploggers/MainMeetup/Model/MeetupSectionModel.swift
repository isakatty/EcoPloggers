//
//  MeetupSectionModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/22/24.
//

import Foundation

import RxDataSources

enum MultiSectionModel {
    case bannerSection(title: String, items: [SectionItem])
    case regionSection(title: String, items: [SectionItem])
    case favoriteSection(title: String, items: [SectionItem])
    case latestSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case bannerSectionItem
    case regionSectionItem(data: String)
    case favoriteSectionItem(data: ViewPostResponse)
    case latestSectionItem(data: ViewPostResponse)
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
