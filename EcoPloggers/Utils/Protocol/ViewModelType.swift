//
//  ViewModelType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import Foundation

import RxSwift

protocol ViewModelType {
    var disposeBag: DisposeBag { get set }
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
