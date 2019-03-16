//
//  ViewController.swift
//  Checklist
//
//  Created by Lucas Almeida on 13/03/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    private var todoList: TodoList
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let newRowIndex = todoList.todos.count
        _ = todoList.newTodo()
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifierBundle.addItemId.rawValue {
            if let addItemViewController = segue.destination as? ItemDetailV {
                addItemViewController.delegate = self
                addItemViewController.todoList = todoList
            }
        } else if segue.identifier == IdentifierBundle.editItemId.rawValue {
            if let addItemViewController = segue.destination as? ItemDetailV {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                    let item = todoList.todos[indexPath.row]
                    addItemViewController.delegate = self
                    addItemViewController.itemToEdit = item
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
  
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = todoList.todos[indexPath.row]
            configureCheckmark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func checkCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmark = cell.viewWithTag(Int(IdentifierBundle.checkMarkTag.rawValue)!) as? UILabel else { return }
        
        if item.isChecked {
            checkmark.text = "√"
        } else {
            checkmark.text = ""
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmark = cell.viewWithTag(Int(IdentifierBundle.checkMarkTag.rawValue)!) as? UILabel else { return }
        
        if item.isChecked {
            checkmark.text = ""
        } else {
            checkmark.text = "√"
        }
        item.toggleChecked()
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierBundle.checklistTableViewCellId.rawValue, for: indexPath)
        let item = todoList.todos[indexPath.row]
        configureText(for: cell, with: item)
        checkCheckmark(for: cell, with: item)     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        todoList.todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension ChecklistViewController: itemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailV) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailV, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todos.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func itemDetailViewController(_ controller: ItemDetailV, didFinishEditing item: ChecklistItem) {
        if let index = todoList.todos.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}


