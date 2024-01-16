//
//  WebVM.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 16/01/2024.
//

import Foundation
import Combine

class WebVM: BaseVM {
    var showErrorSubject = PassthroughSubject<String, Never>()
    var showLoadingSubject = PassthroughSubject<Bool, Never>()
    private var loadURLSubject = PassthroughSubject<URLRequest, Never>()
    private var cancelables = Set<AnyCancellable>()
    var coordinator: AppCoordinator!
    private var url: URL?
    init(url: URL? = nil) {
        self.url = url
    }
    
    func transform(input: Input) -> Output {
        input.requestURL
            .sink {[weak self]  in
                self?.loadURL()
            }
            .store(in: &cancelables)
        return Output(showError: showErrorSubject.eraseToAnyPublisher(), loadURL: loadURLSubject.eraseToAnyPublisher())
    }
    
    private func loadURL() {
        if let url = self.url {
            loadURLSubject.send(URLRequest(url: url))
        } else {
            showErrorSubject.send(StringKey.msgErrorInvalidURL)
        }
    }
}

extension WebVM {
    struct Input {
        let requestURL: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let showError: AnyPublisher<String, Never>
        let loadURL: AnyPublisher<URLRequest, Never>
    }
    
    typealias C = AppCoordinator
}
