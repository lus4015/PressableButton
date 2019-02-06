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
        
        let shadowColor = UIColor(red: 211/255.0, green: 67/255.0, blue: 7/255.0, alpha: 1.0)
        
        layer.cornerRadius = 8.0
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
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

class BrightButton: PressableAnimatedButton {
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

        let brightButtonShadow = UIColor(red: 235/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        backgroundColor = UIColor(red: 255/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1.0)
        layer.shadowColor = brightButtonShadow.cgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        setTitleColor(UIColor(red: 255/255.0, green: 17/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DimButton: PressableAnimatedButton {
    struct DimPressableParameters: PressableParameters {
        var shadowOpacityForPressAmount: (CGFloat) -> CGFloat {
            return {
                amount in
                
                let fixedAmount = abs(1 - amount)
                return 1.0 - fixedAmount * 0.25
            }
        }
    }
    
    init() {
        super.init(parameters: DimPressableParameters())
        
        let brightButtonShadow = UIColor(red: 235/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        
        backgroundColor = UIColor(red: 254/255.0, green: 100/255.0, blue: 149/255.0, alpha: 1.0)
        layer.shadowColor = brightButtonShadow.cgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
