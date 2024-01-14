//
//  UIImage+Ext.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromURLString(_ urlString: String,
                                   defaultImage : String? = nil) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {[weak self] (data, response, error) -> Void in
            var image: UIImage?
            if let data = data {
                image = UIImage(data: data)
            } else if let placeHolderImage = defaultImage {
                image = UIImage(named: placeHolderImage)
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self?.image = image
            })
            
        }).resume()
    }
}
