//
//  WebVC.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 16/01/2024.
//

import UIKit
import WebKit
import Combine

final class WebVC: BaseVC<WebVM> {
    private var requestURLSubject = PassthroughSubject<Void, Never>()
    private var cancelables = Set<AnyCancellable>()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: containerView.bounds)
        webView.sizeToFit()
        containerView.addSubview(webView)
        return webView
    }()
    
    override func bindData() {
        let input = WebVM.Input(requestURL: requestURLSubject.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        output.loadURL
            .receive(on: RunLoop.main)
            .sink {[weak self] urlRequest in
                self?.webView.load(urlRequest)
            }
            .store(in: &cancelables)
    }
    
    override func configuration() {
        requestURLSubject.send(())
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
