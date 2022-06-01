//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Александр Христиченко on 31.05.2022.
//
import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item()]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Diana"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Alex"
        itemArray.append(newItem3)
        
        //add info from userDefaults
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add an item", style: .default) { (action) in
            //add new items
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //add info into UserDefaults
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            //refresh the teableView
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableView DataSource Methods

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
}

//MARK: - TableViewDelegate

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //make the checkmarks work
        tableView.reloadData()
        
        //print(itemArray[indexPath.row])
    }
}
