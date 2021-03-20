//
//  AddOrderViewController.swift
//  Coffee Ordering App
//
//  Created by Denis Onofras on 17.03.2021.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller : UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: AddCoffeeOrderDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextFiel: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    private var vm = AddCoffeeOdersViewModel()
    private var coffeeSizesSegmentedControll: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setupUI() {
        
        self.coffeeSizesSegmentedControll = UISegmentedControl(items: self.vm.size)
        self.coffeeSizesSegmentedControll.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.coffeeSizesSegmentedControll)
        self.coffeeSizesSegmentedControll.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        
        self.coffeeSizesSegmentedControll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddOderdCoffeeCell", for: indexPath)
        
        cell.textLabel?.text = self.vm.type[indexPath.row]
        return cell
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        let name = nameTextFiel.text
        let email = emailTextField.text
        let size = self.coffeeSizesSegmentedControll.titleForSegment(at: self.coffeeSizesSegmentedControll.selectedSegmentIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffe")
        }
       
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = size
        self.vm.selectedType = self.vm.type[indexPath.row]
        
        WebService().load(resource: Order.create(vm: self.vm)) { (resoult) in
            
            switch resoult {
                case .success(let order):
                    if let order = order, let delegate = self.delegate {
                        DispatchQueue.main.async {
                            delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
            
        }
    }
    
    @IBAction func closePressed(_ sender: UIBarButtonItem) {
        
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(controller: self)
        }
        
    }
    
}
