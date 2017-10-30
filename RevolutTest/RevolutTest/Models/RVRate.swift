//
//  RVRate.swift
//  RevolutTest
//
//  Created by cristinasita on 27/10/2017.
//  Copyright © 2017 cristinasita. All rights reserved.
//

import UIKit

class RVRate: NSObject {
    var shortCurrencyName: String!
    var value: Double!
    
    init(withString: String) {
        super.init()
        var rate = withString.characters.split{$0 == " "}.map(String.init)
        self.shortCurrencyName = rate[0]
        self.value = Double(rate[1])
    }
}
