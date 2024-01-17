//
//  CustomIllustrationView.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 17/01/2024.
//

import UIKit

class CustomIllustrationView: BaseView {
    var onAction: (() -> Void)?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var text: UILabel!
    @IBInspectable var kindRawValue: Int = 0 {
        didSet {
            guard let kind = Kind(rawValue: kindRawValue) else { return }
            updateUI(kind)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateUI(_ kind: Kind) {
        self.imageView.image = kind.image
        self.text.text = kind.title
        self.text.isHidden = kind.title.isEmpty
        self.actionButton.isHidden = kind.titleAction.isEmpty
        self.actionButton.setTitle(kind.titleAction, for: .normal)
    }
    
    
    @IBAction func clickDoAction(_ sender: Any) {
        onAction?()
    }
}

extension CustomIllustrationView {
    enum Kind: Int {
        case none
        case empty
        case noNetwork
        case loading
        
        var image: UIImage? {
            switch self {
            case .empty: return UIImage(named: PHImages.Name.imgNoData)
            case .loading: return UIImage(named: PHImages.Name.imgLoadingData)
            case .noNetwork: return UIImage(named: PHImages.Name.imgNoNetwork)
            default: return nil
            }
        }
        
        var title: String {
            switch self {
            case .empty: return StringKey.textNoData
            case .loading: return StringKey.textLoading
            default: return ""
            }
        }
        
        var titleAction: String {
            switch self {
            case .noNetwork: return StringKey.textRefresh
            default: return ""
            }
        }
    }
    

}
