//
//  BaseVC.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import UIKit
import ProgressHUD
import Toast

class BaseVC<ViewModel: BaseVM>: UIViewController {
    var viewModel: ViewModel!
    
    init(nibName: String? = nil,
         viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindData()
        bindEvent()
        configuration()
    }
    
    func setupUI() {}
    
    func setupConstraints() {}
    
    func bindData() {}
    
    func bindEvent() {}
    
    func configuration() {}
    
    func showErorMessage(_ msg: String) {
        let alertVC = UIAlertController(title: StringKey.appName, message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title:  StringKey.textCancel, style: .cancel))
        self.present(alertVC, animated: true)
    }
    
    func showErrorToastMessage(_ msg: String) {
        var errorStyle = ToastStyle()
        errorStyle.messageColor = UIColor.white
        errorStyle.backgroundColor = UIColor.red
        view.makeToast(msg, position: .top, style: errorStyle, completion: nil)
    }
    
    func showLoading() {
        ProgressHUD.animate()
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
}

extension BaseVC {
    static func from<VC: BaseVC>(storyboard: UIStoryboard, with viewModel: ViewModel) -> VC {
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! VC
        vc.viewModel = viewModel
        return vc;
    }
}
