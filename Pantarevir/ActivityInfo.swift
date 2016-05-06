//
//  ActivityInfo.swift
//  Pantarevir
//
//  Created by Anton Källbom on 06/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

class ActivityInfo{
    
    // amount
    var type: String!
    var data: Double!
    var dataInt: Int!
    var description: String!
    var title: String!
    
    init(type: String, amount: Double) {

        self.type = type
        
        switch type {
        case "house":
            self.dataInt = Int((amount / 0.02564583333).roundToPlaces(0))
            self.description = "...Värma upp ett"
            self.title = "Svenskt medelhus"
        case "shower":
            self.dataInt = Int((amount / 0.44).roundToPlaces(0))
            self.description = "...Slå på"
            self.title = "Duschen"
        case "dryer":
            self.dataInt = Int((amount / 0.027).roundToPlaces(0))
            self.description = "...Torka håret med"
            self.title = "Hårfön"
        case "microwave":
            self.dataInt = Int((amount / 0.02333333333).roundToPlaces(0))
            self.description = "...Värma din matlåda i"
            self.title = "Mikrovågsugn"
        case "charger":
            self.dataInt = Int((amount / 0.0001666666667).roundToPlaces(0))
            self.description = "...Ladda"
            self.title = "Mobilen"
        case "computer":
            self.dataInt = Int((amount / 0.0008333333333).roundToPlaces(0))
            self.description = "...Ha igång din"
            self.title = "Dator"
        case "lamp":
            self.dataInt = Int((amount / 0.0006666666667).roundToPlaces(0))
            self.description = "...Lysa upp en"
            self.title = "Glödlampa (40 W)"
        case "car":
            self.dataInt = Int((amount / 0.186).roundToPlaces(0))
            self.description = "...Åka omkring i en"
            self.title = "Medelstor bil"
        case "flight":
            self.data = amount / 230
            self.description = "...Motsvara en flygresa"
            self.title = "Arlanda-Berlin"
        case "bus":
            self.data = amount / 16.63
            self.description = "...Motsvara en bussresa"
            self.title = "Göteborg-Stockholm"
        case "food":
            self.dataInt = Int((amount / 1.8).roundToPlaces(0))
            self.description = "...Konsumera"
            self.title = "Hamburgermeny"
        default:
            self.data = 0
        }
    }
    
    func returnDescription() -> String {
        return self.description!
    }
    
    func returnTitle() -> String {
        return self.title!
    }
    
    func returnData() -> Double {
        return self.data!
    }
}
