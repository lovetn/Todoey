 //
//  ViewController.swift
//  Todoey
//
//  Created by Lovet Nguatem on 2018-12-14.
//  Copyright © 2018 Lovet Nguatem. All rights reserved.
//

import UIKit

class TododListViewController: UITableViewController {
 
   var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        newItem.done = true
        
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//         itemArray = items
//
//    }
    }
        // Do any additional setup after loading the view, typically from a nib.
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return itemArray.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: IndexPath)
        
      let item = itemArray[IndexPath.row]
        
        cell.textLabel?.text = item.title
        //Ternary operator ==>
        //va
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell 
            }

    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   // print(itemArray[indexPath.row])
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    tableView.reloadData()
   
    
   // tableView.deselectRow(at: IndexPath, animated: true)
    
    
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

    tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
       var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            let newItem = Item()
           newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            let encoder = PropertyListEncoder()
             do{
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
              print("error encoding Item Array, \(error)")
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Creat New Item"
            textField = alertTextField
            
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding Item Array, \(error)")
        }
        self.tableView.reloadData()
        
    }

    
    


}

 
