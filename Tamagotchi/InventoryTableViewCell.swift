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
        print("Action button pressed")
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
