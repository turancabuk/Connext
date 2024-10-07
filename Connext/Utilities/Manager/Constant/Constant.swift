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
    
    var placeHolder: UIImage {
        switch self {
        case .square:
            return PlaceHolderImage.square
        case .banner:
            return PlaceHolderImage.banner
        }
    }
}

enum DeviceType {
    enum screenSize {
        static let width                = UIScreen.main.bounds.width
        static let height               = UIScreen.main.bounds.height
        static let maxLength            = max(screenSize.width, screenSize.height)
    }
    static let idiom                = UIDevice.current.userInterfaceIdiom
    static let nativeScale          = UIScreen.main.nativeScale
    static let scale                = UIScreen.main.scale
    
    static let isiPhone8Standard    = idiom == .phone && screenSize.maxLength == 667.0 && nativeScale == scale
}
