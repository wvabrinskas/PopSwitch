//
//  ViewController.swift
//  PopSwitch
//
//  Created by William Vabrinskas on 7/27/17.
//  Copyright © 2017 williamvabrinskas. All rights reserved.
//

import UIKit


enum Color: Int {
    case LightGreen,DarkGreen,ClearDarkGreen,Purple,ErrorRed,LightErrorRed,LightSuccessGreen,
    LightPurple,LightTabBarBlue,DarkPurple,DarkBlue,LightBlue
    
}

protocol ColorDefinition {
    func uiColor() -> UIColor
}

enum ColorModel: ColorDefinition {
    case Color(color:Color)
    
    func uiColor() -> UIColor {
        switch self {
        case let .Color(color):
            switch color {
            case .LightGreen:
                return UIColor(red: 1/255, green: 158/255, blue: 134/255, alpha: 1)
            case .DarkGreen:
                return UIColor(red: 0/255, green: 106/255, blue: 85/255, alpha: 1)
            case .ClearDarkGreen:
                return UIColor(red: 0/255, green: 106/255, blue: 85/255, alpha: 0.6)
            case .Purple:
                return UIColor(red: 117.0/255.0, green: 32.0/255.0, blue: 167.0/255.0, alpha: 1.0)
            case .DarkPurple:
                return UIColor(red: 127.0/255.0, green: 68.0/255.0, blue: 198.0/255.0, alpha: 1.0)
            case .ErrorRed:
                return UIColor(red: 214.0/255.0, green: 41.0/255.0, blue: 44.0/255.0, alpha: 1.0)
            case .LightErrorRed:
                return UIColor(red: 239.0/255.0, green: 119.0/255.0, blue: 124.0/255.0, alpha: 1.0)
            case .LightSuccessGreen:
                return UIColor(red: 106.0/255.0, green: 200.0/255.0, blue: 95.0/255.0, alpha: 1.0)
            case .LightPurple:
                return UIColor(red: 94.0/255.0, green: 101.0/255.0, blue: 168.0/255.0, alpha: 1.0)
            case .LightTabBarBlue:
                return UIColor(red: 193.0/255.0, green: 211.0/255.0, blue: 243.0/255.0, alpha: 1.0)
            case .DarkBlue:
                return UIColor(red: 36.0/255.0, green: 88.0/255.0, blue: 165.0/255.0, alpha: 1.0)
            case .LightBlue:
                return UIColor(red: 62.0/255.0, green: 109.0/255.0, blue: 179.0/255.0, alpha: 1.0)
            }
        }
    }
}


class ViewController: UIViewController {
    var popSwitch: PopSwitch!
    @IBOutlet weak var centerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let color:SwitchColor = (background:ColorModel.Color(color: .LightGreen).uiColor().cgColor, switch: ColorModel.Color(color: .LightTabBarBlue).uiColor().cgColor)
        popSwitch = PopSwitch(position: .Off, color: color, type: .Switch)
        centerView.addSubview(popSwitch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

