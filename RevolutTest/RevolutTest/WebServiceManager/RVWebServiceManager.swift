//
//  RVWebServiceManager.swift
//  RevolutTest
//
//  Created by cristinasita on 26/10/2017.
//  Copyright © 2017 cristinasita. All rights reserved.
//

import UIKit
import Alamofire

class RVWebServiceManager: NSObject {
    
    static let sharedInstance = RVWebServiceManager()

    var alamofireManager : Alamofire.SessionManager
    
    override init () {
        let configuration = URLSessionConfiguration.default
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }

}
