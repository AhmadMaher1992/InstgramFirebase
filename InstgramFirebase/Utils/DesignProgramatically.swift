//
//  DesignProgramatically.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 12/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//



import UIKit


extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? , left: NSLayoutXAxisAnchor? , bottom: NSLayoutYAxisAnchor? , right: NSLayoutXAxisAnchor? , paddingTop: CGFloat , paddingLeft: CGFloat  , paddingBottom: CGFloat , paddingRight: CGFloat , width: CGFloat , height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UIView{
    
    
  
    
    func constraints(to view: UIView ,left: NSLayoutXAxisAnchor?,right: NSLayoutXAxisAnchor?,top: NSLayoutYAxisAnchor?,bottom: NSLayoutYAxisAnchor?, paddingLeft: CGFloat, paddingRight: CGFloat ,paddingTop: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
 

    /// Attaches all sides of the receiver to its parent view
    func fillSuperView(margin: CGFloat = 0.0) {
        let view = superview
       equalTop(to: view, margin: margin)
        equalBottom(to: view, margin: margin)
        equalLeading(to: view, margin: margin)
        equalTrailing(to: view, margin: margin)

    }

    /// Attaches the top of the current view to the given view's top if it's a superview of the current view
    /// or to it's bottom if it's not (assuming this is then a sibling view).
    @discardableResult
    func equalTop(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {

        let view: UIView? = to ?? superview
        let isSuperview = view == superview
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                                            toItem: view, attribute: isSuperview ? .top : .bottom, multiplier: 1.0,
                                            constant: margin)
        superview?.addConstraint(constraint)

        return constraint
    }

    /// Attaches the bottom of the current view to the given view
    @discardableResult
    func equalBottom(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {

        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                                            toItem: view, attribute: isSuperview ? .bottom : .top, multiplier: 1.0,
                                            constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)

        return constraint
    }

    /// Attaches the leading edge of the current view to the given view
    @discardableResult
    func equalLeading(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {

        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
                                            toItem: view, attribute: isSuperview ? .leading : .trailing, multiplier: 1.0,
                                            constant: margin)
        superview?.addConstraint(constraint)

        return constraint
    }

    /// Attaches the trailing edge of the current view to the given view
    @discardableResult
    func equalTrailing(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {

        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                                            toItem: view, attribute: isSuperview ? .trailing : .leading, multiplier: 1.0,
                                            constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)

        return constraint
    }
    
    
    
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    

}






// Reference Video: https://youtu.be/iqpAP7s3b-8
extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }
    
    func centerYInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
    func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}







class VerticalStackView: UIStackView {

    init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        
        arrangedSubviews.forEach({addArrangedSubview($0)})
        
        self.spacing = spacing
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}







//
//extension UIView {
//    /// Attaches all sides of the receiver to its parent view
//    func coverWholeSuperview(margin: CGFloat = 0.0) {
//        let view = superview
//        layoutAttachTop(to: view, margin: margin)
//        layoutAttachBottom(to: view, margin: margin)
//        layoutAttachLeading(to: view, margin: margin)
//        layoutAttachTrailing(to: view, margin: margin)
//
//    }
//
//    /// Attaches the top of the current view to the given view's top if it's a superview of the current view
//    /// or to it's bottom if it's not (assuming this is then a sibling view).
//    @discardableResult
//    func layoutAttachTop(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {
//
//        let view: UIView? = to ?? superview
//        let isSuperview = view == superview
//        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
//                                            toItem: view, attribute: isSuperview ? .top : .bottom, multiplier: 1.0,
//                                            constant: margin)
//        superview?.addConstraint(constraint)
//
//        return constraint
//    }
//
//    /// Attaches the bottom of the current view to the given view
//    @discardableResult
//    func layoutAttachBottom(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
//
//        let view: UIView? = to ?? superview
//        let isSuperview = (view == superview) || false
//        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
//                                            toItem: view, attribute: isSuperview ? .bottom : .top, multiplier: 1.0,
//                                            constant: -margin)
//        if let priority = priority {
//            constraint.priority = priority
//        }
//        superview?.addConstraint(constraint)
//
//        return constraint
//    }
//
//    /// Attaches the leading edge of the current view to the given view
//    @discardableResult
//    func layoutAttachLeading(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {
//
//        let view: UIView? = to ?? superview
//        let isSuperview = (view == superview) || false
//        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
//                                            toItem: view, attribute: isSuperview ? .leading : .trailing, multiplier: 1.0,
//                                            constant: margin)
//        superview?.addConstraint(constraint)
//
//        return constraint
//    }
//
//    /// Attaches the trailing edge of the current view to the given view
//    @discardableResult
//    func layoutAttachTrailing(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
//
//        let view: UIView? = to ?? superview
//        let isSuperview = (view == superview) || false
//        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
//                                            toItem: view, attribute: isSuperview ? .trailing : .leading, multiplier: 1.0,
//                                            constant: -margin)
//        if let priority = priority {
//            constraint.priority = priority
//        }
//        superview?.addConstraint(constraint)
//
//        return constraint
//    }
//
//    // For anchoring View
//    struct AnchoredConstraints {
//        var top, leading, bottom, trailing, width, height, centerX, centerY: NSLayoutConstraint?
//    }
//
//    @discardableResult
//    func constraints(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil,
//                trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero,
//                centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil,
//                centerXOffset: CGFloat = 0, centerYOffset: CGFloat = 0) -> AnchoredConstraints {
//
//        translatesAutoresizingMaskIntoConstraints = false
//        var anchoredConstraints = AnchoredConstraints()
//
//        if let top = top {
//            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
//        }
//
//        if let leading = leading {
//            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
//        }
//
//        if let bottom = bottom {
//            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
//        }
//
//        if let trailing = trailing {
//            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
//        }
//
//        if size.width != 0 {
//            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
//        }
//
//        if size.height != 0 {
//            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
//        }
//
//        if let centerX = centerX {
//            anchoredConstraints.centerX = centerXAnchor.constraint(equalTo: centerX, constant: centerXOffset)
//        }
//
//        if let centerY = centerY {
//            anchoredConstraints.centerY = centerYAnchor.constraint(equalTo: centerY, constant: centerYOffset)
//        }
//
//        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom,
//         anchoredConstraints.trailing, anchoredConstraints.width,
//         anchoredConstraints.height, anchoredConstraints.centerX,
//         anchoredConstraints.centerY].forEach { $0?.isActive = true }
//
//        return anchoredConstraints
//    }
//}
