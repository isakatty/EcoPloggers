//
//  DateFormatter.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import Foundation

final class EcoDateFormatter {
    static let shared = EcoDateFormatter()
    
    private let responseDate: DateFormatter
    private let viewDateString: DateFormatter
    private init() {
        responseDate = DateFormatter()
        responseDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        viewDateString = DateFormatter()
        viewDateString.dateFormat = "yyyy-MM-dd"
        viewDateString.timeZone = TimeZone.current
        viewDateString.locale = Locale.current
    }
    func changeToDateFormat(from dateString: String) -> String? {
        if let date = responseDate.date(from: dateString) {
            return viewDateString.string(from: date)
        }
        return nil
    }
}
