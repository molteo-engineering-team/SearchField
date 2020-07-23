//
//  UIView+Extension.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/12/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

extension UIView {
    
    /// implements the basic edges of any view
    public enum Edge {
        case top, bottom, leading, trailing
    }
    
    /// fills Self into superview while respecting the disregarded Edges and also adds the padding into the Auto Layout
    ///
    /// - Parameters:
    ///   - disregarding: The edges you want to disregard while anchoring the view
    ///   - padding: paddings for the anchors
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
    
    /// Setup the layer with shadows to look similar to material design
    func setupLayerWithShadow() {
        layer.masksToBounds = false
        let cornerRadius: CGFloat = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.24
        layer.shadowRadius = cornerRadius
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
