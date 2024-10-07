//
//  CKAsset+Ext.swift
//  Connext
//
//  Created by Turan Çabuk on 14.08.2024.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(dimension: ImageDimension) -> UIImage {
        guard let fileURL = self.fileURL else {return dimension.placeHolder}
        
        do{
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data) ?? dimension.placeHolder
        }catch{
            return dimension.placeHolder
        }
    }
}
