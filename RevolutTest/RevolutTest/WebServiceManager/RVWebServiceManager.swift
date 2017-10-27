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
    
    func getLatest(base: String, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        self.alamofireManager.request(API.getLatest,
                                      method: .get,
                                      parameters: ["base": base],
                                      encoding: URLEncoding.default,
                                      headers: nil)
            .responseJSON(completionHandler: { (response) -> Void in
                completionHandler(response)
            })
    }

}
