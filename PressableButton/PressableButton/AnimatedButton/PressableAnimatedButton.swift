//
//  PressableAnimatedButton.swift
//  PressableButton
//
//  Created by Unsung Lee on 6/2/19.
//  Copyright © 2019 Unsung. All rights reserved.
//

import UIKit

class PressableAnimatedButton: UIButton {
    
    private let parameters: PressableParameters
    private var initialPositionInView: CGPoint = .zero
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 58)
    }
    
    override var frame: CGRect {
        didSet {
            layer.updateForPressAmount(0.0, parameters: parameters)
        }
    }
    
    override var bounds: CGRect {
        didSet {
            layer.updateForPressAmount(0.0, parameters: parameters)
        }
    }
    
    init(parameters: PressableParameters = DefaultPressableParameters()) {
        self.parameters = parameters
        
        super.init(frame: .zero)
        
        backgroundColor = .keyPink
        
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.onboardingShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        setTitleColor(.white, for: .normal)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressed(_:)))
        longPressGesture.minimumPressDuration = 0.0
        
        addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pressed(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            initialPositionInView = sender.location(in: self)
            layer.animatePressAmount(pressAmount: 0.0, amount: 1.0, parameters: parameters)
            
        case .changed:
            let pos = sender.location(in: self)
            
            if abs(pos.y - initialPositionInView.y) > 10.0 || abs(pos.x - initialPositionInView.x) > 10 {
                sender.isEnabled = false
                sender.isEnabled = true
            }
        case .ended:
            
            let point = sender.location(in: self)
            
            if bounds.contains(point) {
                layer.animatePressAmount(pressAmount: 1.0, amount: 0.0, parameters: parameters)
                
                DispatchQueue.main.async {
                    self.sendActions(for: .touchUpInside)
                }
            } else {
                sender.isEnabled = false
                sender.isEnabled = true
                layer.animatePressAmount(pressAmount: 1.0, amount: 0.0, parameters: parameters)
            }
            
        case .cancelled:
            layer.animatePressAmount(pressAmount: 1.0, amount: 0.0, parameters: parameters)
        default:
            break
        }
        
    }
    
}

class OnboardingButton: PressableButton {
}

class BrightButton: PressableButton {
    struct BrightPressableParameters: PressableParameters {
        var shadowOpacityForPressAmount: (CGFloat) -> CGFloat {
            return {
                amount in
                
                let fixedAmount = abs(1 - amount)
                return 1.0 - fixedAmount * 0.4
            }
        }
    }
    
    init() {
        super.init(parameters: BrightPressableParameters())
        
        backgroundColor = .onboardingBackground
        layer.shadowColor = UIColor.brightButtonShadow.cgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setTitleColor(.keyPink, for: .normal)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DimButton: PressableButton {
    struct DimPressableParameters: PressableParameters {
        var shadowOpacityForPressAmount: (CGFloat) -> CGFloat {
            return {
                amount in
                
                let fixedAmount = abs(1 - amount)
                return 1.0 - fixedAmount * 0.4
            }
        }
    }
    
    init() {
        super.init(parameters: DimPressableParameters())
        
        backgroundColor = UIColor(red: 254/255.0, green: 100/255.0, blue: 149/255.0, alpha: 1.0)
        layer.shadowColor = UIColor.brightButtonShadow.cgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setTitleColor(.white, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
