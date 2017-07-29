//
//  PopSwitch.swift
//  PopSwitch
//
//  Created by William Vabrinskas on 7/27/17.
//  Copyright © 2017 williamvabrinskas. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import QuartzCore

open class PopSwitch: UIView {
    
    public enum State {
        case On,Off
    }

    open var state:State!
    
    private lazy var startOnXOrigin:CGFloat = {
        return self.frame.width - self.circle.frame.size.width
    }()
    private lazy var onXOrigin: CGFloat = {
        return self.frame.width - (self.circle.frame.size.width / 2)
    }()
    
    private lazy var offXOrigin: CGFloat = {
        return self.circle.frame.size.width / 2
    }()
    
    private lazy var circle:CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        circleLayer.path = UIBezierPath.init(ovalIn: circleLayer.bounds).cgPath
        circleLayer.fillColor = UIColor.green.cgColor
        return circleLayer
    }()
    
    private func getSwitchLayer(with state: State) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.bounds.height / 2.0).cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        
        if state == .On {
            circle.frame.origin = CGPoint(x: startOnXOrigin, y: 0)
        } else {
            circle.frame.origin = CGPoint(x: 0, y: 0)
        }
        
        shapeLayer.addSublayer(circle)

        return shapeLayer
    }
    
    fileprivate func onSpringAnimation() -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: "position")
        spring.damping = 10.0
        spring.duration = spring.settlingDuration
        spring.repeatCount = 0
        spring.speed = 2
        spring.toValue = [onXOrigin, self.circle.frame.size.height / 2]
        spring.initialVelocity = 0
        spring.fillMode = kCAFillModeBoth
        spring.isRemovedOnCompletion = false
        return spring
    }
    
    fileprivate func offSpringAnimation() -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: "position")
        spring.damping = 10.0
        spring.speed = 2
        spring.duration = spring.settlingDuration
        spring.repeatCount = 0
        spring.toValue = [offXOrigin, self.circle.frame.size.height / 2]
        spring.initialVelocity = 0
        spring.fillMode = kCAFillModeBoth
        spring.isRemovedOnCompletion = false
        return spring
    }

    private func animate(to state:State) {
        
        if state == .On {
            //animating to the ON position
            circle.add(self.onSpringAnimation(), forKey: "onAnimation")
        } else {
            circle.add(self.offSpringAnimation(), forKey: "offAnimation")
        }

    }
    
    public init(default state:State) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.backgroundColor = .clear
        self.layer.addSublayer(getSwitchLayer(with: state))
        self.state = state
        
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(changeState))
        touchGesture.numberOfTapsRequired = 1
        touchGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(touchGesture)

    }
    
    //through touch gesture
    @objc private func changeState() {
        if self.state == .On {
            self.state = .Off
        } else {
            self.state = .On
        }
        animate(to: self.state)
    }
    
    //programmatically set state
    open func setState(state: State) {
        self.state = state
        animate(to: state)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
