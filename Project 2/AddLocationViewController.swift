//
//  AddLocationViewController.swift
//  Project 2
//
//  Created by Raman Singh on 2022-11-29.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var items: [ItemToDo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDefaultItems()
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        
    }
    
    
    private func loadDefaultItems() {
        items.append(ItemToDo(title: "Item 1", description: "Description 1"))
        items.append(ItemToDo(title: "Item 2", description: "Description 2"))
        items.append(ItemToDo(title: "Item 3", description: "Description 3"))
    }
}
    
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let item = items[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.description
        cell.contentConfiguration = content
        return cell
    }
    
    }
     
    struct ItemToDo {
        let title: String
        let description: String
    }
    

    
//    @IBAction func onDonePressed(_ sender: UIButton) {
//        dismiss(animated: true)
//    }
//
   
