//
//  BaseVM.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import Foundation
import Combine

protocol BaseVM {
    associatedtype Input
    associatedtype Output
    var fetchedError: PassthroughSubject<String, Never> { get set }
    func transform(input: Input) -> Output
}
