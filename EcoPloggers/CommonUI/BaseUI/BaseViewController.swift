//
//  BaseViewController.swift
//  EcoPloggers
//
//  Created by Jisoo HAM on 8/15/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() { }
    func configureLayout() {
        view.backgroundColor = Constant.Color.mainBG
    }
}
