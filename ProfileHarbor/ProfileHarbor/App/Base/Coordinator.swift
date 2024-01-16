//
//  Coordinator.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import Foundation

class Coordinator {
    weak var parent: Coordinator?
    private(set) var childs: [Coordinator] = []
    func start() {
        preconditionFailure("Method must be override")
    }
    func finsih() {
        preconditionFailure("Method must be override")
    }
    
    func addChild(_ coordinator: Coordinator) {
        coordinator.parent = self
        childs.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        if let index = childs.firstIndex(of: coordinator) {
            childs.remove(at: index)
        }
    }
    
    func removeAllWith<T>(type: T.Type) {
        childs = childs.filter {$0 is T == false }
    }
    
    func removeAll() {
        childs.removeAll()
    } 
}


extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}
