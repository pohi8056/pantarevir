//
//  Store.swift
//  Pantarevir
//
//  Created by Anton Källbom on 13/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

//
//  ActivityInfo.swift
//  Pantarevir
//
//  Created by Anton Källbom on 06/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class Store{
    
    var name: String!
    var street: String!
    var zip: String!
    var city: String!
    
    init(name: String, street: String, zip: String, city: String) {
        
        self.name = name
        self.street = street
        self.zip = zip
        self.city = city
        
    }
    
    func returnName() -> String {
        return self.name
    }

    func returnStreet() -> String {
        return self.street
    }
    
    func returnZipCity() -> String {
        return "\(zip), \(city)"
    }
    
}
