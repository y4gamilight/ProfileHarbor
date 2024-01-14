//
//  Data+Ext.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import Foundation
import UIKit

extension Data {
    func resizeImage(withSize newSize: CGSize) -> Data {
        let data = self
        guard let originalImage = UIImage(data: data) else {
            return data
        }
        
        // Create a new graphics context
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        // Draw the original image in the new graphics context
        originalImage.draw(in: CGRect(origin: .zero, size: newSize))
        
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return data
        }
        
        UIGraphicsEndImageContext()
    
        return resizedImage.pngData() ?? data
    }
}
