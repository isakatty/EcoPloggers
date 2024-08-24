//
//  String+.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import Foundation

extension String{
    var isValidEmail: Bool {
        let regExp = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        return NSPredicate(format: "SELF MATCHES %@", regExp).evaluate(with: self)
    }
    var exceptHashtag: String {
        let splitedContent = self.components(separatedBy: "#")
        return splitedContent[0]
    }
    var contentHashtag: [String] {
        let splitedContent = self.components(separatedBy: "#")
        
        let hashtags = splitedContent.filter { item in
            !item.isEmpty && item != NetworkKey.hashtag.rawValue
        }
        
        return hashtags
    }
}
