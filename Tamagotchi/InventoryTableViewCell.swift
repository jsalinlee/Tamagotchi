//
//  InventoryTableViewCell.swift
//  Tamagotchi
//
//  Created by Jonathan Salin Lee on 3/16/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//

import UIKit
import CoreData

class InventoryTableViewCell: UITableViewCell {
    var cellDelegate: ActionButtonDelegate?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var invList:Inventory?
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var actionButtonLabel: UIButton!
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Inventory")
        do {
            let result = try managedObjectContext.fetch(request)
            var item = result as! [Inventory]
            if item.count == 0 {
                let playerInv = Inventory(context: managedObjectContext)
                playerInv.redCount = 0
                playerInv.blueCount = 0
                playerInv.greenCount = 0
                playerInv.yellowCount = 0
                playerInv.gojira = 0
                playerInv.kendama = 0
                playerInv.rubberBall = 0
                do {
                    try managedObjectContext.save()
                } catch { print("Error") }
                item = [playerInv]
            }
            // Assign the inventory instance to self
            self.invList = item[0]
        } catch {
            let playerInv = Inventory(context: managedObjectContext)
            playerInv.redCount = 0
            playerInv.blueCount = 0
            playerInv.greenCount = 0
            playerInv.yellowCount = 0
            playerInv.gojira = 0
            playerInv.kendama = 0
            playerInv.rubberBall = 0
            do {
                try managedObjectContext.save()
            } catch { print("Error") }
        }
        
        self.cellDelegate?.actionDelegateButtonPressed()
        let str = self.itemLabel!.text
        let end = str!.index(str!.startIndex, offsetBy: 1)
        switch(str!.substring(to: end)) {
        case "R":
            if let red = invList?.redCount {
                print("Red berries \(red)")
                invList?.redCount -= 1
            }
        case "B":
            print("Blue berry button pressed!")
        case "G":
            print("Green berry button pressed!")
        case "Y":
            print("Yellow berry button pressed!")
        default:
            print("Unknown")
        }
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
