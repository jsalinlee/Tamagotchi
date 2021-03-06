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
                if red > 0 {
                    print("Red berries: \(red)")
                    self.itemLabel!.text = "Red Berry: \(red)"
                    invList?.redCount -= 1
                }
                else {
                    print("Not enough red berries")
                }
            }
        case "B":
            if let blue = invList?.blueCount {
                if blue > 0 {
                    print("Blue berries \(blue)")
                    self.itemLabel!.text = "Blue Berry: \(blue)"
                    invList?.blueCount -= 1
                }
                else {
                    print("Not enough blue berries")
                }
            }
        case "G":
            if let green = invList?.greenCount {
                if green > 0 {
                    print("Blue berries \(green)")
                    self.itemLabel!.text = "Green Berry: \(green)"
                    invList?.greenCount -= 1
                }
                else {
                    print("Not enough green berries")
                }
            }
        case "Y":
            if let yellow = invList?.yellowCount {
                if yellow > 0 {
                    print("Yellow berries \(yellow)")
                    self.itemLabel!.text = "Yellow Berry: \(yellow)"
                    invList?.blueCount -= 1
                }
                else {
                    print("Not enough yellow berries")
                }
            }
        default:
            print("Unknown")
        }
        do {
            try managedObjectContext.save()
        } catch { print("Error") }
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
