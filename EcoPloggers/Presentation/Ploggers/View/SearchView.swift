//
//  SearchView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

import SnapKit

final class SearchView: BaseView {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "지역을 검색해보세요."
        searchBar.sizeToFit()
        searchBar.searchTextField.backgroundColor = Constant.Color.clear
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = Constant.Color.clear.cgColor
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return searchBar
    }()
    
    override func configureHierarchy() {
        addSubview(searchBar)
    }
    override func configureLayout() {
        super.configureLayout()
        
        layer.borderColor = Constant.Color.lightGray.cgColor.copy(alpha: 0.5)
        layer.borderWidth = 1
        clipsToBounds = true
        
        searchBar.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
}
