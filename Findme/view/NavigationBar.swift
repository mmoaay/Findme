//
//  NavigationBar.swift
//  MBMotion
//
//  Created by Perry on 15/12/9.
//  Copyright © 2015年 MmoaaY. All rights reserved.
//

import UIKit

enum NavigationBarStyle: Int {
    case `default`
    case futura
}

class NavigationBar: UINavigationBar {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backIndicatorImage = UIImage(named: "back_icon")
        self.backIndicatorTransitionMaskImage = UIImage(named: "back_icon")
        
        self.tintColor = UIColor.white
        
        if let font = UIFont(name: "Futura", size: 20), let largeFont = UIFont(name: "Futura", size: 30) {
            self.largeTitleTextAttributes = [NSAttributedStringKey.font:largeFont, NSAttributedStringKey.foregroundColor:UIColor.white]
            self.titleTextAttributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.foregroundColor:UIColor.white]
        }
    }
    
    func setStyle(_ style:NavigationBarStyle) {
        switch style {
        case .futura:
            break;
        default:
            break;
        }
    }

}
