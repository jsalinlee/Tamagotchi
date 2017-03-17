//
//  InventoryTableViewController.swift
//  Tamagotchi
//
//  Created by Jonathan Salin Lee on 3/16/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//

import UIKit
import CoreData

class InventoryTableViewController: UITableViewController, ActionButtonDelegate {
    var itemSections = ["Food", "Toys"]
    var food = ["Red Berry", "Blue Berry", "Green Berry", "Yellow Berry"]
    var foodCounts = [Int32]()
    var toys = ["Red rubber ball", "Kendama", "Gojira Action Figure"]
    var toyCounts = [Int32]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var inventoryList:Inventory?
    var playerStats:Player?
    var inventoryCell = InventoryTableViewCell()
    var cellIndex = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAllItems()
        tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Inventory")
        let playerRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        do {
            let result = try managedObjectContext.fetch(playerRequest)
            var player = result as! [Player]
            if player.count == 0 {
                playerStats = Player(context: managedObjectContext)
                playerStats?.hunger = 50
                playerStats?.health = 100
                playerStats?.lastFeed = Date() as NSDate?
                playerStats?.lastPlay = Date() as NSDate?
                playerStats?.lastCheck = Date() as NSDate?
                do {
                    try managedObjectContext.save()
                } catch { print("Error") }
            }
        } catch {
            playerStats = Player(context: managedObjectContext)
            playerStats?.hunger = 50
            playerStats?.health = 100
            playerStats?.lastFeed = Date() as NSDate?
            playerStats?.lastPlay = Date() as NSDate?
            playerStats?.lastCheck = Date() as NSDate?
            do {
                try managedObjectContext.save()
            } catch { print("Error") }
        }
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
    
    func actionDelegateButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryTableViewCell
        if indexPath.section == 0 {
            cell.itemLabel.text = "\(food[indexPath.row]): \(foodCounts[indexPath.row])"
            cell.actionButtonLabel.setTitle("Feed", for: .normal)
        } else if indexPath.section == 1 {
            cell.itemLabel.text = "\(toys[indexPath.row]): \(toyCounts[indexPath.row])"
            cell.actionButtonLabel.setTitle("Play", for: .normal)
        }
        cell.tag = indexPath.row
        print(cell.tag)
        cell.cellDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return itemSections[section]
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print(cellIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
