//
//  BaseView.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 17/01/2024.
//
import UIKit
class BaseView: UIView {
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            assert(topRadiusOnly == 0)
            assert(bottomRadiusOnly == 0)
            self.rounds(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius:cornerRadius )
        }
    }
    
    @IBInspectable var topRadiusOnly:CGFloat = 0 {
        didSet {
            assert(cornerRadius == 0)
            assert(bottomRadiusOnly == 0)
            self.rounds(corners: [.topLeft, .topRight], radius:topRadiusOnly)
        }
    }
    
    @IBInspectable var bottomRadiusOnly:CGFloat = 0 {
        didSet {
            assert(cornerRadius == 0)
            assert(topRadiusOnly == 0)
            self.rounds(corners: [.bottomLeft, .bottomRight], radius:bottomRadiusOnly)
        }
    }
    
    var view : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadius > 0 {
            self.rounds(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius:cornerRadius )
        } else if topRadiusOnly > 0 {
            self.rounds(corners: [.topLeft, .topRight], radius:topRadiusOnly)
        } else if bottomRadiusOnly > 0 {
            self.rounds(corners: [.bottomLeft, .bottomRight], radius:bottomRadiusOnly)
        }
    }
    
    private func rounds(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    private func loadViewFromNib() {
        let nibName     = String(describing: type(of: self))
        let nib         = UINib(nibName: nibName, bundle: Bundle.main)
        view        =   nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view?.frame      = bounds
        addSubview(view ?? UIView())
        view?.fillVerticalSuperview()
        view?.fillHorizontalSuperview()
        setUpViews()
    }
    
    func setUpViews() { }
}
