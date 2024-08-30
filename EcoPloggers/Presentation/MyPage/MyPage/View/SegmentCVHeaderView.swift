//
//  SegmentCVHeaderView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/30/24.
//

import UIKit

import RxSwift
import SnapKit

enum EcoProfile: Int, CaseIterable {
    case favorite
    case myPosts
    
    var toImg: UIImage? {
        switch self {
        case .favorite:
            return UIImage(systemName: "heart")
        case .myPosts:
            return UIImage(systemName: "pencil.and.list.clipboard")
        }
    }
}

final class SegmentCVHeaderView: BaseCollectionViewCell {
    let segmentControl: UISegmentedControl = {
        let seg = UISegmentedControl()
        for (index, item) in EcoProfile.allCases.enumerated() {
            seg.insertSegment(with: item.toImg, at: index, animated: true)
        }
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(segmentControl)
    }
    override func configureLayout() {
        segmentControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
