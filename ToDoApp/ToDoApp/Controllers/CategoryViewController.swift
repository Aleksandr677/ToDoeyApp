//
//  CategoryController.swift
//  ToDoApp
//
//  Created by Александр Христиченко on 04.06.2022.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        view.backgroundColor = UIColor(hexString: "61BBFF")
        
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller doesn't exists" ) }
        navBar.backgroundColor = UIColor(hexString: "61BBFF")
    }
    
    //Add a new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat()?.hexValue() ?? "61BBFF"
            self.categoryArray.append(newCategory)
            
            //add data using CoreData(Crud)
            self.saveCategories()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
            textField = alertTextField
        }
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    //save our data using CoreData(Crud)
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        //refresh the tableView
        self.tableView.reloadData()
    }
    
    //get our data using CoreData(cRud)
    func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        
        //refresh the tableView
        tableView.reloadData()
    }
    
    //delete our data from swipe
    override func updateModel(at indexPath: IndexPath) {
        self.context.delete(self.categoryArray[indexPath.row])
        self.categoryArray.remove(at: indexPath.row)
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
}

//MARK: - TableVIew DataSource

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        let color = UIColor(hexString: categoryArray[indexPath.row].color ?? "61BBFF")  //ChameleonFramework
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color!, returnFlat: true)
        
        return cell
    }
}

//MARK: - TableView Delegate

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
