
import Foundation
import UIKit

extension UIColor {
    convenience init(from hsl : HSLColor) {
        self.init(hue: hsl.hue, saturation: hsl.saturation, brightness: hsl.brightness, alpha: hsl.alpha)
    }
    var hslColor: HSLColor {
        get {
            return HSLColor(from: self)
        }
    }
}

struct HSLColor {
    let hue, saturation, brightness, alpha : CGFloat
    init(hue : CGFloat, saturation : CGFloat, brightness : CGFloat, alpha : CGFloat = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    init(from color : UIColor) {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        if color.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            hue = h
            saturation = s
            brightness = b
            alpha = a
        } else {
            hue = 0
            saturation = 0
            brightness = 0
            alpha = 1
        }
    }
    var uiColor : UIColor {
        get {
            return UIColor(from: self)
        }
    }
    
    func shiftHue(by amount : CGFloat) -> HSLColor {
        return HSLColor(hue: shift(hue, by: amount), saturation: saturation, brightness: brightness, alpha: alpha)
    }
    func shiftBrightness(by amount : CGFloat) -> HSLColor {
        return HSLColor(hue: hue, saturation: saturation, brightness: shift(brightness, by: amount), alpha: alpha)
    }
    func shiftSaturation(by amount : CGFloat) -> HSLColor {
        return HSLColor(hue: hue, saturation: shift(saturation, by: amount), brightness: brightness, alpha: alpha)
    }
    private func shift(_ value : CGFloat, by amount : CGFloat) -> CGFloat {
        return abs((value + amount).truncatingRemainder(dividingBy: 1))
    }
}
