//
//  UIFontExtension.swift
//  Findme
//
//  Created by zhengperry on 2017/10/5.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
