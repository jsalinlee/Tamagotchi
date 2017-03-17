//
//  InventoryTableViewController.swift
//  Tamagotchi
//
//  Created by Jonathan Salin Lee on 3/16/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//

import UIKit
import CoreData

class InventoryTableViewController: UITableViewController {
    var itemSections = ["Food", "Toys"]
    var food = ["Red Berry", "Blue Berry", "Green Berry", "Yellow Berry"]
    var foodCounts = [Int32]()
    var toys = ["Red rubber ball", "Kendama", "Gojira Action Figure"]
    var toyCounts = [Int32]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var inventoryList:Inventory?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAllItems()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Inventory")
        do {
            // If inventory does not exist, initialize empty inventory
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
            self.inventoryList = item[0]
            self.foodCounts = [(inventoryList?.redCount)!, (inventoryList?.blueCount)!, (inventoryList?.greenCount)!, (inventoryList?.yellowCount)!]
            self.toyCounts = [(inventoryList?.rubberBall)!, (inventoryList?.kendama)!, (inventoryList?.gojira)!]
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
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return food.count
        }
        else if section == 1 {
            return toys.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(food[indexPath.row]): \(foodCounts[indexPath.row])"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(toys[indexPath.row]): \(toyCounts[indexPath.row])"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return itemSections[section]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
