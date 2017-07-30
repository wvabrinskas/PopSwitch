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

public typealias SwitchColor = (background: CGColor?, switch: CGColor?)
open class PopSwitch: UIView {
    
    public enum State {
        case On,Off
    }
    
    open var state:State!
    private var color:SwitchColor?
    private let height = 100
    
    private lazy var startOnXOrigin:CGFloat = {
        return self.frame.width - self.circle.frame.size.width
    }()
    private lazy var onXOrigin: CGFloat = {
        return self.frame.width - (self.circle.frame.size.width / 2)
    }()
    
    private lazy var offXOrigin: CGFloat = {
        return self.circle.frame.size.width / 2
    }()
    
    private lazy var switchLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.bounds.height / 2.0).cgPath
        shapeLayer.fillColor = self.color?.background ?? UIColor.white.cgColor
        if self.state == .On {
            self.circle.frame.origin = CGPoint(x: self.startOnXOrigin, y: 0)
        } else {
            self.circle.frame.origin = CGPoint(x: 0, y: 0)
        }

        shapeLayer.addSublayer(self.circle)
        
        return shapeLayer
    }()
    
    private lazy var circle:CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(x: 0, y: 0, width: self.height, height: self.height)
        circleLayer.path = UIBezierPath.init(ovalIn: circleLayer.bounds).cgPath
        circleLayer.fillColor = self.color?.switch ?? UIColor.green.cgColor
        return circleLayer
    }()
    
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

    fileprivate func scaleDownAnimation() -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: "transform.scale")
        spring.damping = 10.0
        spring.speed = 2
        spring.duration = spring.settlingDuration
        spring.repeatCount = 0
        spring.toValue = [0.6,0.6]
        spring.initialVelocity = 0
        spring.fillMode = kCAFillModeBoth
        spring.isRemovedOnCompletion = false
        return spring
    }
    
    fileprivate func scaleUpAnimation() -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: "transform.scale")
        spring.damping = 10.0
        spring.speed = 2
        spring.duration = spring.settlingDuration
        spring.repeatCount = 0
        spring.toValue = [1.0,1.0]
        spring.initialVelocity = 0
        spring.fillMode = kCAFillModeBoth
        spring.isRemovedOnCompletion = false
        return spring
    }
    
    
    private func animate(to state:State) {
        
        let scaleGroup = CAAnimationGroup()
        scaleGroup.animations = [self.scaleDownAnimation(), self.scaleUpAnimation()]
        circle.add(scaleGroup, forKey: "scale")

        if state == .On {
            //animating to the ON position
            circle.add(self.onSpringAnimation(), forKey: "onAnimation")
        } else {
            circle.add(self.offSpringAnimation(), forKey: "offAnimation")
        }

    }
    
    public init(position state:State, color: SwitchColor?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: self.height))
        self.backgroundColor = .clear
        self.state = state
        self.color = color
        self.layer.addSublayer(switchLayer)

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
