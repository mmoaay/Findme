//
//  HomeTableViewCell.swift
//  Findme
//
//  Created by ZhengYidong on 09/10/2017.
//  Copyright © 2017 mmoaay. All rights reserved.
//

import UIKit
import Material

class HomeTableViewCell: TableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setRoute(route: Route) {
        titleLabel.text = route.name
        
        let timeInterval:TimeInterval = TimeInterval(route.identity)
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        detailLabel.text = "Created at " + formatter.string(from: date)
        
        headImageView.image = route.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
