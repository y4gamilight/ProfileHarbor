//
//  LazyLoadUserAvatarManager.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import Foundation
import UIKit

final class LazyLoadUserAvatarManager: LazyOperatorManager {
  
    private var cache = NSCache<NSString, NSData>()

    func asyncDown(item: UserViewModel,
                   index: Int, completed: ((Data?, Int)->())?) {
        let uid = "\(item.uid)"
        if let cachedImage = self.cache.object(forKey: item.avatarURL as NSString) {
            completed?(Data(referencing: cachedImage), index)
            return
        }
        
        if let operation = self.firstNotFinishedOperator(uid)  {
            operation.queuePriority = .veryHigh
            completed?(nil, index)
            return
        }
        var task: URLSessionDataTask!
        let operation = AsyncOperation(uid: uid, asyncTask: { callback in
            guard let __url = URL(string: item.avatarURL) else {
                completed?(nil, index)
                callback()
                return
            }
            task = URLSession.shared.dataTask(with: __url, completionHandler: {[weak self] (data, response, error) -> Void in
                if let imgData = data {
                    let resizeData = imgData.resizeImage(withSize: Constants.Download.thumbnailSize)
                    self?.cache.setObject(resizeData as NSData, forKey: __url.absoluteString as NSString)
                    completed?(resizeData, index)
                } else {
                    completed?(nil, index)
                }
                callback()
            })
            task.resume()
        })
        operation.queuePriority = .high
        operationQueue.addOperation(operation)
    }
    
    func slowDownImageDownloadTaskfor (_ item: UserViewModel) {
        self.firstNotFinishedOperator("\(item.uid)")?.queuePriority = .low
    }
    
}
