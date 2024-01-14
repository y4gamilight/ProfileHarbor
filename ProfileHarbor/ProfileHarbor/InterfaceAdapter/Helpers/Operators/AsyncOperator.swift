//
//  AsyncOperator.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//
import Foundation

class AsyncOperation: Operation {
    var uid: String
    var asyncTask: ((_ callback: @escaping (() -> ())) -> ())?
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    override func main() {
        guard let asyncTask = asyncTask else {
            return
        }
        willChangeValue(forKey: State.executing.keyPath)
        state = .executing
        didChangeValue(forKey: State.executing.keyPath)
        
        asyncTask {
            self.willChangeValue(forKey: State.executing.keyPath)
            self.willChangeValue(forKey: State.finished.keyPath)
            
            self.state = .finished
            
            self.willChangeValue(forKey: State.executing.keyPath)
            self.willChangeValue(forKey: State.finished.keyPath)
        }
    }
    
    init(uid: String, asyncTask: ((_ callback: @escaping (() -> ())) -> ())?) {
        self.uid = uid
        self.asyncTask = asyncTask
    }
    
    public final func finish() {
        if isExecuting { state = .finished }
    }
}
