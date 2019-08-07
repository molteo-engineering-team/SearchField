//
//  UIView+Extension.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/12/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import UIKit

extension UIView {
    
    public enum Edge {
        case top, bottom, leading, trailing
    }
    
    public func fillSuperView(disregarding: Edge..., padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = superview?.topAnchor, !disregarding.contains(.top) {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottomSuperAnchor = superview?.bottomAnchor, !disregarding.contains(.bottom) {
            bottomAnchor.constraint(equalTo: bottomSuperAnchor, constant: -padding.bottom).isActive = true
        }
        if let leadingSuperAnchor = superview?.leadingAnchor, !disregarding.contains(.leading) {
            leadingAnchor.constraint(equalTo: leadingSuperAnchor, constant: padding.left).isActive = true
        }
        if let trailingSuperAnchor = superview?.trailingAnchor, !disregarding.contains(.trailing) {
            trailingAnchor.constraint(equalTo: trailingSuperAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func setupShadowForLayout() {
        let cornerRadius: CGFloat = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.16
        layer.shadowRadius = cornerRadius
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.masksToBounds = false
    }
}
