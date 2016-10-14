//
//  Model.swift
//  OrganizationChart
//
//  Created by anilkumar thatha. venkatachalapathy on 12/10/16.
//  Copyright © 2016 Anil T V. All rights reserved.
//

import Foundation

class Model: NSObject {
    var Source : String
    var Destination : String
    
    override init() {
        Source = "Manager"
        Destination = "Employee"
        super.init()
    }
    
    init(Source : String, Destination : String) {
        self.Source = Source
        self.Destination = Destination
        super.init()
    }
}
