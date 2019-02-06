//
//  CALayer+Animate.swift
//  PressableButton
//
//  Created by Unsung Lee on 6/2/19.
//  Copyright © 2019 Unsung. All rights reserved.
//

import UIKit

protocol PressableParameters {
    var shadowBezierPathForPressAmount: (CGFloat, CGRect) -> UIBezierPath { get }
    var shadowRadiusForPressAmount: (CGFloat) -> CGFloat { get }
    var shadowOpacityForPressAmount: (CGFloat) -> CGFloat { get }
}

extension PressableParameters {
    var shadowBezierPathForPressAmount: (CGFloat, CGRect) -> UIBezierPath {
        return {
            amount, rect in
            
            let fixedAmount = abs(amount - 1)
            let shadowInset = fixedAmount * 10
            let shadowOffset = fixedAmount * 10
            return UIBezierPath(roundedRect: rect.insetBy(dx: shadowInset, dy: 0).offsetBy(dx: 0, dy: shadowOffset), cornerRadius: 10)
        }
    }
    
    var shadowRadiusForPressAmount: (CGFloat) -> CGFloat {
        return {
            amount in
            
            let fixedAmount = abs(amount - 1)
            return fixedAmount * 4.0 + 3.0
        }
    }
    
    var shadowOpacityForPressAmount: (CGFloat) -> CGFloat {
        return {
            amount in
            
            let fixedAmount = abs(amount - 1)
            return 0.7 - fixedAmount * 0.5
        }
    }
}

struct DefaultPressableParameters: PressableParameters {}

extension CALayer {
    
    func animate(pressAmount: CGFloat, parameters: PressableParameters = DefaultPressableParameters()) -> CALayerAnimate {
        return CALayerAnimate(layer: self, pressAmount: pressAmount, parameters: parameters)
    }
    
    func animatePressAmount(pressAmount: CGFloat, amount: CGFloat, parameters: PressableParameters = DefaultPressableParameters(), _ completion: (()->())? = nil) {
        
        self
            .animate(pressAmount: pressAmount, parameters: parameters)
            .zPosition(amount)
            .shadowPath(amount, rect: bounds)
            .shadowOpacity(shadowOpacity: amount)
            .shadowRadius(shadowRadius: amount)
            .start(timingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
        
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.updateForPressAmount(amount, parameters: parameters)
        }) {
            finished in
            completion?()
        }
    }
    
    func updateForPressAmount(_ pressAmount: CGFloat, parameters: PressableParameters) {
        
        let maxTranslation: CGFloat = 100.0
        let minTranslation: CGFloat = 0.0
        let zTranslation = pressAmount * maxTranslation + minTranslation
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 1000.0
        transform = CATransform3DTranslate(transform, 0, 0, zTranslation)
        
        self.transform = transform
        
        shadowPath = parameters.shadowBezierPathForPressAmount(pressAmount, bounds).cgPath
        shadowRadius = parameters.shadowRadiusForPressAmount(pressAmount)
        shadowOpacity = Float(parameters.shadowOpacityForPressAmount(pressAmount))
    }
}

class CALayerAnimate {
    
    private var animations: [String: CAAnimation]
    private var duration: CFTimeInterval
    private let parameters: PressableParameters
    let layer: CALayer
    let pressAmount: CGFloat
    
    init(layer: CALayer, pressAmount: CGFloat, parameters: PressableParameters = DefaultPressableParameters()) {
        self.parameters = parameters
        self.animations = [String: CAAnimation]()
        self.duration = 0.2
        self.layer = layer
        self.pressAmount = pressAmount
    }
    
    func zPosition(_ amount: CGFloat) -> CALayerAnimate {
        let key = "zPosition"
        let animation = CABasicAnimation(keyPath: key)
        animation.fromValue = pressAmount
        animation.toValue = amount
        animation.isRemovedOnCompletion = false
        animations[key] = animation
        return self
    }
    
    func shadowOpacity(shadowOpacity: CGFloat) -> CALayerAnimate {
        let key = "shadowOpacity"
        let animation = CABasicAnimation(keyPath: key)
        animation.fromValue = layer.shadowOpacity
        animation.toValue = parameters.shadowOpacityForPressAmount(shadowOpacity)
        animation.isRemovedOnCompletion = false
        animations[key] = animation
        return self
    }
    
    func shadowPath(_ amount: CGFloat, rect: CGRect) -> CALayerAnimate {
        let key = "shadowPath"
        let animation = CABasicAnimation(keyPath: key)
        animation.fromValue = layer.shadowPath
        animation.toValue = parameters.shadowBezierPathForPressAmount(amount, rect).cgPath
        animation.isRemovedOnCompletion = false
        animations[key] = animation
        return self
    }
    
    func shadowRadius(shadowRadius: CGFloat) -> CALayerAnimate {
        let key = "shadowRadius"
        let animation = CABasicAnimation(keyPath: key)
        animation.fromValue = layer.shadowRadius
        animation.toValue = parameters.shadowRadiusForPressAmount(shadowRadius)
        animation.isRemovedOnCompletion = false
        animations[key] = animation
        return self
    }
    
    func duration(duration: CFTimeInterval) -> CALayerAnimate {
        self.duration = duration
        return self
    }
    
    func start(timingFunction: CAMediaTimingFunction? = nil) {
        for (key, animation) in animations {
            animation.duration = duration
            animation.timingFunction = timingFunction
            
            layer.removeAnimation(forKey: key)
            layer.add(animation, forKey: key)
        }
    }
}
