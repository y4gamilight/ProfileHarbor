//
//  LazyOperatorManager.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import Foundation

class LazyOperatorManager {
    lazy var taskInProgress = [String: AsyncOperation]()
        lazy var operationQueue: OperationQueue = {
            var queue = OperationQueue()
            queue.name = "lazyLoadingImage"
            queue.maxConcurrentOperationCount = 1
            return queue
        }()
        
        func reset() {
            self.cancelAll()
            self.operationQueue = OperationQueue()
            self.operationQueue.name = "lazyLoadingImage"
            self.operationQueue.maxConcurrentOperationCount = 1
        }
        
        func cancelAll() {
            operationQueue.cancelAllOperations()
        }
        
        func firstNotFinishedOperator(_ uid: String) -> AsyncOperation? {
            let firstOperator = operationQueue.operations.first { operation in
                guard let asyncOperator = operation as? AsyncOperation else { return false }
                return asyncOperator.uid == uid && !asyncOperator.isFinished && asyncOperator.isExecuting
            }
            return firstOperator as? AsyncOperation
        }
}
