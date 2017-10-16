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
    
    public enum SwitchType {
        case Radio, Switch
    }
    
    open var state:State!
    open var delegate:PopSwitchDelegate?
    
    private var color:SwitchColor?
    private static let height:CGFloat = 30.0
    private var switchType: SwitchType!
    
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
        shapeLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: PopSwitch.height).cgPath
        
        if self.switchType == .Switch {
            if self.state == .On {
                shapeLayer.fillColor = self.color?.background ?? UIColor.white.cgColor
                self.circle.frame.origin = CGPoint(x: self.startOnXOrigin, y: 0)
            } else {
                shapeLayer.fillColor = self.getDarkerColor()
                self.circle.frame.origin = CGPoint(x: 0, y: 0)
            }
        } else {
            shapeLayer.fillColor = self.getDarkerColor()
            shapeLayer.lineWidth = 5.0
            shapeLayer.strokeColor = self.color?.background ?? UIColor.white.cgColor
        }

        shapeLayer.addSublayer(self.circle)
        
        return shapeLayer
    }()
    
    private lazy var circle:CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        var height = PopSwitch.height
        var center = CGPoint(x:0, y:0)
        
        if self.switchType == .Radio {
            height = PopSwitch.height - 7
            center = CGPoint(x: (PopSwitch.height / 2) - (height / 2), y: (PopSwitch.height / 2) - (height / 2))
        }
        
        circleLayer.frame = CGRect(x: center.x, y: center.y, width: height, height: height)
        circleLayer.path = UIBezierPath.init(ovalIn: circleLayer.bounds).cgPath
        circleLayer.fillColor = self.color?.switch ?? UIColor.green.cgColor

        return circleLayer
    }()
    
    fileprivate func getDarkerColor() -> CGColor {
        var newColor:CGColor?
        
        if let components = color?.background?.components {
            if components.count >= 3 {
                let r = (components[0] * 255) - 100
                let g = (components[1] * 255) - 100
                let b = (components[2] * 255) - 100
                
                newColor = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0).cgColor
            }
        }
        
        return newColor ?? color?.background ?? UIColor.white.cgColor
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
    
    fileprivate func scaleDownAnimation() -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: "transform.scale")
        spring.damping = 10.0
        spring.speed = 2
        spring.duration = spring.settlingDuration
        spring.repeatCount = 0
        spring.toValue = [0.0,0.0]
        if switchType == .Switch {
            spring.toValue = [0.6,0.6]
        }
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
    
    fileprivate func colorOnChangeAnimation() -> CABasicAnimation {
        //backgroundColor
        let colorChange = CABasicAnimation(keyPath: "fillColor")
        colorChange.toValue = self.color?.background ?? UIColor.white.cgColor
        colorChange.isRemovedOnCompletion = false
        colorChange.fillMode = kCAFillModeBoth
        colorChange.repeatCount = 0
        return colorChange
    }
    
    fileprivate func colorOffChangeAnimation() -> CABasicAnimation {
        //backgroundColor
        let colorChange = CABasicAnimation(keyPath: "fillColor")
        colorChange.toValue = getDarkerColor()
        colorChange.repeatCount = 0
        colorChange.fillMode = kCAFillModeBoth
        colorChange.isRemovedOnCompletion = false
        return colorChange
    }
    
    private func animate(to state:State) {
        
        if switchType == .Switch {
            let scaleGroup = CAAnimationGroup()
            scaleGroup.animations = [self.scaleDownAnimation(), self.scaleUpAnimation()]
            circle.add(scaleGroup, forKey: "scale")
            
            if state == .On {
                //animating to the ON position
                circle.add(self.onSpringAnimation(), forKey: "onAnimation")
                switchLayer.add(self.colorOnChangeAnimation(), forKey: "onColorAnimation")
            } else {
                circle.add(self.offSpringAnimation(), forKey: "offAnimation")
                switchLayer.add(self.colorOffChangeAnimation(), forKey: "offColorAnimation")
            }
        } else {
            if state == .On {
                circle.add(self.scaleUpAnimation(), forKey: "onAnimation")
            } else {
                circle.add(self.scaleDownAnimation(), forKey: "offAnimation")
            }
        }
        
    }
    
    public init(position state:State, color: SwitchColor?, type:SwitchType) {
        let width = type == .Radio ? PopSwitch.height : PopSwitch.height * 1.8

        super.init(frame: CGRect(x: 0, y: 0, width: width, height: PopSwitch.height))
        
        self.switchType = type
        
        self.backgroundColor = .clear
        self.state = state
        self.color = color
        self.layer.addSublayer(switchLayer)
        
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(changeState))
        touchGesture.numberOfTapsRequired = 1
        touchGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(touchGesture)

        setState(state: state)
    
    }
    
    //through touch gesture
    @objc private func changeState() {
        if self.state == .On {
            self.state = .Off
        } else {
            self.state = .On
        }
        animate(to: self.state)

        delegate?.valueChanged(to: self.state)
    }
    
    //programmatically set state
    open func setState(state: State) {
        self.state = state
        animate(to: state)
        delegate?.valueChanged(to: state)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Cannot add PopSwitch as part of interface builder. Sorry =(")
    }
}
