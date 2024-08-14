//
//  Constant.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import UIKit

enum RecordType {
    static let location = "ConnextLocation"
    static let profile  = "ConnextProfile"
}

enum PlaceHolderImage {
    static let avatar = UIImage(named: "person")!
    static let square = UIImage(named: "connext")!
    static let banner = UIImage(named: "connext.banner")!
}

enum ImageDimension {
    case square, banner
    
    static func getPlaceHolder(dimension: ImageDimension) -> UIImage {
        switch dimension {
        case .square:
            return PlaceHolderImage.square
        case .banner:
            return PlaceHolderImage.banner
        }
    }
}
