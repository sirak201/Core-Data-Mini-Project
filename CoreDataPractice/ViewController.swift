//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Sirak on 1/7/20.
//  Copyright © 2020 Sirak. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var people : [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
    
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
          do {
            people = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
    }

    @IBAction func addName(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            
            [unowned self] action in
            
            
            guard let textField = alert.textFields?.first,
                let name = textField.text else {
                return
            }
            
            self.save(name : name)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        let mangedContext = appDelegate.persistentContainer.viewContext
        
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: mangedContext)!
        
        
        let person = NSManagedObject(entity: entity, insertInto: mangedContext)
        person.setValue(name, forKey: "name")
        
        
        do {
            try mangedContext.save()
            people.append(person)
            tableView.reloadData()
        } catch let err as NSError {
            print("Here is ur err " , err)
        }
    }
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for : indexPath)
        
        
        cell.textLabel?.text = people[indexPath.row].value(forKeyPath: "name") as? String
        return cell
    }
    
    
}

//

