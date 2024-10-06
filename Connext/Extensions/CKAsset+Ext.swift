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
        let placeHolder   = ImageDimension.getPlaceHolder(dimension: dimension)
        guard let fileURL = self.fileURL else {return placeHolder}
        
        do{
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data) ?? placeHolder
        }catch{
            return placeHolder
        }
    }
}
