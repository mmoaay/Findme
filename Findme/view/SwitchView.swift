//
//  SwitchView.swift
//  Findme
//
//  Created by zhengperry on 2017/10/7.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import UIKit
import SnapKit

protocol SwitchViewDelegate {
    func switched(status: OperationStatus)
}

enum OperationType {
    case store
    case search
}

enum OperationStatus {
    case locating
    case going
    case done
    case save
    
    func title(type: OperationType) -> String {
        switch self {
        case .locating:
            return "Place your phone vertically at the very position in the real world, then press Located"
        case .going:
            switch type {
            case .store:
                return "Please hold on for 3 seconds, then press Routing and follow the dashed circle to record the route to find me"
            case .search:
                return "Please hold on for 3 seconds, then press Searching and follow the the route to finde me"
            }
        case .done:
            switch type {
            case .store:
                return "Press Done if you've finish the route to find me"
            case .search:
                return "Press Done if you've find me"
            }
        case .save:
            return "Press Save to save the route to find me"
        }
    }
    
    func next(type: OperationType) -> OperationStatus {
        switch self {
        case .locating:
            return .going
        case .going:
            return .done
        case .done:
            switch type {
            case .store:
                return .save
            case .search:
                return .locating
            }
        case .save:
            return .locating
        }
    }
    
    func buttonTitle(type: OperationType) -> String {
        switch self {
        case .locating:
            return "Located"
        case .going:
            switch type {
            case .store:
                return "Routing"
            case .search:
                return "Searching"
            }
        case .done:
            return "Done"
        case .save:
            return "Save"
        }
    }
    
    func buttonColor() -> UIColor {
        switch self {
        case .locating:
            return UIColor(hexColor: "43CD80")
        case .going:
            return UIColor(hexColor: "CD4F39")
        case .done:
            return UIColor.clear
        case .save:
            return UIColor(hexColor: "CD4F39")
        }
    }
}

class SwitchView: UIView {
    
    var delegate: SwitchViewDelegate? = nil

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var captureView: DashedBorderView!
    @IBOutlet private weak var contentLabel: UILabel!
    
    @IBOutlet weak var switchButton: UIButton!
    
    var status: OperationStatus = .locating {
        didSet {
            contentLabel.text = status.title(type: self.type)
            switchButton.setTitle(status.buttonTitle(type: self.type), for: .normal)
            switchButton.backgroundColor = status.buttonColor()
        }
    }
    
    var type: OperationType = .store {
        didSet {
            contentLabel.text = status.title(type: self.type)
            switchButton.setTitle(status.buttonTitle(type: self.type), for: .normal)
            switchButton.backgroundColor = status.buttonColor()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private func setupContent() {
        Bundle.main.loadNibNamed("SwitchView", owner: self, options: nil)
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupContent()
    }

    @IBAction func switchPressed(_ sender: Any) {
        if .locating == status {
            self.switchButton.isEnabled = false
            var count = 3
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if 0 == count {
                    self.switchButton.isEnabled = true
                    self.switchButton.setTitle("Hold on...", for: .disabled)
                    timer.invalidate()
                } else {
                    self.switchButton.setTitle(String(count), for: .disabled)
                }
                count -= 1
            })
        }
        
        if let delegate = delegate {
            delegate.switched(status: status)
        }
    }
}
