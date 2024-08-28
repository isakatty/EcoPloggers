//
//  NSItemProviderReading.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/28/24.
//

import UIKit

extension NSItemProviderReading {
    func changeItemToData() -> Data {
        if let photo = self as? UIImage, let data = photo.pngData() {
                return data
        }
        print("이미지 Data type 실패")
        return Data()
    }
}
