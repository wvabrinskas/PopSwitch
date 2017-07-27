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
    
    private lazy var onXOrigin: CGFloat = {
        return self.frame.width - self.circle.frame.size.width / 2
    }()
    
    private lazy var offXOrigin: CGFloat = {
        return 0
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
        
        shapeLayer.addSublayer(circle)
        
        if state == .On {
            circle.frame.origin = CGPoint(x: onXOrigin, y: 0)
        } else {
            circle.frame.origin = CGPoint(x: offXOrigin, y: 0)
        }
        
        return shapeLayer
    }
    
    private func animate(to state:State) {
        if state == .On {
            //animating to the ON position
        } else {
            //animating to the OFF position
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
