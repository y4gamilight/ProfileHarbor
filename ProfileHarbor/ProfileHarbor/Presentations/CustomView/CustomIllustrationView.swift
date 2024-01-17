//
//  CustomIllustrationView.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 17/01/2024.
//

import UIKit

class CustomIllustrationView: BaseView {
    
    @IBOutlet weak var imageView: UIImageView!
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
    }
}

extension CustomIllustrationView {
    enum Kind: Int {
        case empty
        case loading
        
        var image: UIImage? {
            switch self {
            case .empty: return UIImage(named: PHImages.Name.imgNoData)
            case .loading: return UIImage(named: PHImages.Name.imgLoadingData)
            }
        }
        
        var title: String {
            switch self {
            case .empty: return StringKey.textNoData
            case .loading: return StringKey.textLoading
            }
        }
    }
    

}
