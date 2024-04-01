//
//  ImageComparator.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import Foundation
import UIKit
import CryptoKit

class ImageComparator {
    
    static func imageComparator(img1: UIImage, img2: UIImage) -> Bool {
        guard let hash1 = ImageComparator.img2Md5(img: img1), let hash2 = ImageComparator.img2Md5(img: img2) else {
            return false
        }
        return hash1 == hash2
    }
    
    private static func img2Md5(img: UIImage) -> String? {
        guard let imgData = img.pngData() else { return nil }
        let md5Data = Insecure.MD5.hash(data: imgData)
        return md5Data.map { String(format: "%02hhx", $0) }.joined()
    }
}
