//
//  InventoryTableViewCell.swift
//  Tamagotchi
//
//  Created by Jonathan Salin Lee on 3/16/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {
    var cellDelegate: ActionButtonDelegate?
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var actionButtonLabel: UIButton!
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        self.cellDelegate?.actionDelegateButtonPressed()
        let str = self.itemLabel!.text
        let end = str!.index(str!.startIndex, offsetBy: 1)
        print("Action button pressed - \(str!.substring(to: end))")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
