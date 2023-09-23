//
//  AbandonedMemoryLeaksVC.swift
//  MemoryLeaksCheck
//
//  Created by Hoang Anh Tuan on 23/09/2023.
//

import UIKit

class Person {
    var apartment: Apartment?
}

class Apartment {
    var person: Person?
}

final class AbandonedMemoryVC: UIViewController {
    
    let apartment = Apartment()
    let person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Abandoned Memory Example"
        view.backgroundColor = .white
        
        apartment.person = person
        person.apartment = apartment
    }
}

