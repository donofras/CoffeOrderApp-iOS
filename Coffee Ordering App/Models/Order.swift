//
//  Order.swift
//  Coffee Ordering App
//
//  Created by Denis Onofras on 17.03.2021.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case Latte
    case Cappuccino
    case Esspreso
}

enum CoffeeSize: String, Codable, CaseIterable {
    case Small
    case Medium
    case Large
}

struct Order: Codable {
    
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
    
}

extension Order {
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("Url was incorrect")
        }
        
        return Resource<[Order]>(url)
        
    }()
    
    static func create(vm: AddCoffeeOdersViewModel) -> Resource<Order?> {
        
        let order = Order(vm)
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("Url was incorrect")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error at encoding")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        
        return resource
    }
    
}

extension Order {
    
    init?(_ vm: AddCoffeeOdersViewModel) {
        
        guard let name = vm.name,
        let email = vm.email,
        let type = CoffeeType(rawValue: vm.selectedType!.capitalized),
        let size = CoffeeSize(rawValue: vm.selectedSize!.capitalized) else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = type
        self.size = size
    }
    
}
