//
//  Reusables.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import UIKit

protocol Reusables {
    static var identifier: String { get }
}

extension Reusables {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusables { }
