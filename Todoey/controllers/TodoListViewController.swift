 //
//  ViewController.swift
//  Todoey
//
//  Created by Lovet Nguatem on 2018-12-14.
//  Copyright © 2018 Lovet Nguatem. All rights reserved.
//

import UIKit
import CoreData

class TododListViewController: UITableViewController {
 
   var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
       
//     loadItems()
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
           
          
            let newItem = Item(context: self.context)
           newItem.title = textField.text!
           newItem.done = false
            
            self.itemArray.append(newItem)
        
            self.saveItems()
            
//            let encoder = PropertyListEncoder()
//             do{
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            } catch {
//              print("error encoding Item Array, \(error)")
//            }
//            self.tableView.reloadData()
            
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
            
           try context.save()
        } catch {
            print("error saving context\(error)")
        }
        self.tableView.reloadData()
        
    }
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                try itemArray = decoder.decode([Item].self, from: data)
//                //itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item arraray\(error)")
//            }
//        }
//    }
    
    

    
    


}

 
