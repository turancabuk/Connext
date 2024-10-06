//
//  UIImage+Ext.swift
//  Connext
//
//  Created by Turan Çabuk on 16.08.2024.
//

import CloudKit
import UIKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset? {
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let fileUrl = urlPath.appendingPathComponent("selectedAvatarImage")
        guard let imageData = jpegData(compressionQuality: 0.25) else {return nil}
        do{
            try imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        }catch{
            return nil
        }
    }
}
