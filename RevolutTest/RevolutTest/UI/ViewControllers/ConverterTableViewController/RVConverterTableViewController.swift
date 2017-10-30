//
//  RVConverterTableViewController.swift
//  RevolutTest
//
//  Created by cristinasita on 27/10/2017.
//  Copyright © 2017 cristinasita. All rights reserved.
//

import UIKit

class RVConverterTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var items = [RVRate]()
    
    var base = "EUR"
    var amount = 100.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "RVConverterTableViewCell", bundle: nil), forCellReuseIdentifier: "RVConverterTableViewCell")

        self.getLatest()
    }
    
    func getLatest() {
        RVWebServiceManager.sharedInstance.getLatest(base: self.base) { (response) in
            response.result.ifSuccess {
                var responseDict = response.result.value as! [String:Any]
                let responseRatesDict = responseDict["rates"] as! [String:Float]
                let rawItemsArray = responseRatesDict.map {"\($0) \($1)"}
                for item in rawItemsArray {
                    let rate = RVRate(withString: item)
                    self.items.append(rate)
                }
                self.tableView.reloadData()
            }
            response.result.ifFailure {
                
            }
        }
    }
    
    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RVConverterTableViewCell") as! RVConverterTableViewCell!
        cell?.currencyLabel.text = self.items[indexPath.row].shortCurrencyName
        cell?.amountTextField.text = String(self.items[indexPath.row].value * self.amount)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
    }

}
