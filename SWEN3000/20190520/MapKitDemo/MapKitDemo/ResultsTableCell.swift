//
//  ResultsTableCell.swift
//  MapKitDemo
//
//  Created by Shemar Henry on 17/06/2019.
//  Copyright © 2019 Maxim Bilan. All rights reserved.
//

import UIKit

class ResultsTableCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    
    var openInMAp: (() -> Void)? = nil
    
    @IBAction func openInMap(sender: UIButton) {
        openInMAp?()
    }
    
}
