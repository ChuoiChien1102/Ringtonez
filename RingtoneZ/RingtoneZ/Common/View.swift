//
//  View.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/23/20.
//

import UIKit

public class View: UIView {

    convenience init(width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        snp.makeConstraints { (make) in
            make.width.equalTo(width)
        }
    }

    convenience init(height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        self.layer.masksToBounds = true
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func getCenter() -> CGPoint {
        return convert(center, from: superview)
    }
}

extension UIView {

    open func setPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        self.setContentHuggingPriority(priority, for: axis)
        self.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
            if #available(iOS 11, *) {
                var cornerMask = CACornerMask()
                if(corners.contains(.topLeft)){
                    cornerMask.insert(.layerMinXMinYCorner)
                }
                if(corners.contains(.topRight)){
                    cornerMask.insert(.layerMaxXMinYCorner)
                }
                if(corners.contains(.bottomLeft)){
                    cornerMask.insert(.layerMinXMaxYCorner)
                }
                if(corners.contains(.bottomRight)){
                    cornerMask.insert(.layerMaxXMaxYCorner)
                }
                self.layer.cornerRadius = radius
                self.layer.maskedCorners = cornerMask

            } else {
                let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                self.layer.mask = mask
            }
        }
}
