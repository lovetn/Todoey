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
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print(dataFilePath)
        
       
    }
    
        
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
    
//    context.delete(itemArray[indexPath.row ])
//    itemArray.remove(at: indexPath.row)
    
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
            newItem.parentCatergory = self.selectedCategory
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
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
      
let CategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
   
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, additionalPredicate])
        }else{
            request.predicate = CategoryPredicate
        }
        

        
        do{
       itemArray = try context.fetch(request)
        } catch {
            print("Erorr fetching data from context \(error)")
        }
    }
    
 }
 
 extension TododListViewController: UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
 }
 

 

 
