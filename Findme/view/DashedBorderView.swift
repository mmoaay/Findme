//
//  DashedBorderView.swift
//  Findme
//
//  Created by zhengperry on 2017/10/7.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import UIKit

class DashedBorderView: UIView {
    
    var border:CAShapeLayer!
    var radius = 110.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        border = CAShapeLayer();
        
        border.strokeColor = UIColor.white.cgColor;
        border.fillColor = nil;
        border.lineDashPattern = [4, 4];
        self.layer.addSublayer(border);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:CGFloat(radius)).cgPath;
        border.frame = self.bounds;
    }
}
