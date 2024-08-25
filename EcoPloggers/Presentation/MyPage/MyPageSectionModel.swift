//
//  MyPageSectionModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import Foundation

import RxDataSources

enum MyPageSectionModel: Comparable {
    case profileSection(title: String, items: [MyPageSectionItem])
    case postSection(title: String, items: [MyPageSectionItem])
    case favoriteSection(title: String, items: [MyPageSectionItem])
    
    var sortOption: Int {
        switch self {
        case .profileSection(_, _): return 0
        case .postSection(_, _): return 1
        case .favoriteSection(_, _): return 2
        }
    }
    static func == (lhs: MyPageSectionModel, rhs: MyPageSectionModel) -> Bool {
        return lhs.sortOption == rhs.sortOption
    }
    static func < (lhs: MyPageSectionModel, rhs: MyPageSectionModel) -> Bool {
        return lhs.sortOption < rhs.sortOption
    }
}
enum MyPageSectionItem {
    case profileSectionItem(data: Data)
    case postSectionItem(data: String)
    case favoriteSectionItem(data: ViewPostDetailResponse)
}

extension MyPageSectionModel: SectionModelType {
    typealias Item = MyPageSectionItem
    
    var items: [MyPageSectionItem] {
        switch self {
        case .profileSection(_, let items),
             .postSection(_, let items),
             .favoriteSection(_, let items):
            return items
        }
    }
    
    init(original: MyPageSectionModel, items: [MyPageSectionItem]) {
        switch original {
        case let .profileSection(title, _):
            self = .profileSection(title: title, items: items)
        case let .postSection(title, _):
            self = .postSection(title: title, items: items)
        case let .favoriteSection(title, _):
            self = .favoriteSection(title: title, items: items)
        }
    }
}
extension MyPageSectionModel {
    var title: String {
        switch self {
        case .profileSection(let title, _),
             .postSection(let title, _),
             .favoriteSection(let title, _):
            return title
        }
    }
}
