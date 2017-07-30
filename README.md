
# PopSwitch

A switch that has a fun spring animation added.

Works for iOS 10+
Note: it is much faster than this gif shows.

![](https://github.com/wvabrinskas/PopSwitch/blob/master/public/PopSwitch.gif)

# Installation
* Simply install using Cocoapods, add `'pod PopSwitch'` to your podfile

# Simple to use
* `import PopSwitch`
* Create a SwitchColor for your switch: `let color:SwitchColor = (background: UIColor.white.cgColor, switch: UIColor.green.cgColor)`
* Create an instance of PopSwitch `let popSwitch = PopSwitch(position: .Off, color: color)`
  * There are two positions: `PopSwitch.State.On` or `PopSwitch.State.Off`
* Add your PopSwitch to a view `view.addSubview(popSwitch)`
