//
//  Reusables.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import Foundation

protocol Reusables {
    static var id: String { get }
}

extension Reusables {
    static var id: String {
        return String(describing: self)
    }
}
