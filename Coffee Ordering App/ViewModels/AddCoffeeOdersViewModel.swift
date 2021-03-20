//
//  AddCoffeeOdersViewModel.swift
//  Coffee Ordering App
//
//  Created by Denis Onofras on 18.03.2021.
//

import Foundation

struct AddCoffeeOdersViewModel {
    
    var name: String?
    var email: String?
    var selectedType: String?
    var selectedSize: String?
    
    var type: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var size: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }

}
