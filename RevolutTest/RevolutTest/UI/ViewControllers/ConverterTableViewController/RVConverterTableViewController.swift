//
//  RVConverterTableViewController.swift
//  RevolutTest
//
//  Created by cristinasita on 27/10/2017.
//  Copyright © 2017 cristinasita. All rights reserved.
//

import UIKit

class RVConverterTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var items = [RVRate]()
    
    var selectedRate = RVRate(withString: "EUR 1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "RVConverterTableViewCell", bundle: nil), forCellReuseIdentifier: "RVConverterTableViewCell")
        
        self.items.append(self.selectedRate)
        self.getLatest(withFullReload: true)
    }
    
    func getLatest(withFullReload: Bool) {
        RVWebServiceManager.sharedInstance.getLatest(base: self.selectedRate.shortCurrencyName) { (response) in
            response.result.ifSuccess {
                self.items.removeAll()
                self.items.append(self.selectedRate)
                var responseDict = response.result.value as! [String:Any]
                let responseRatesDict = responseDict["rates"] as! [String:Float]
                let rawItemsArray = responseRatesDict.map {"\($0) \($1)"}
                var row = 1
                for item in rawItemsArray {
                    let rate = RVRate(withString: item)
                    self.items.append(rate)
                    if (!withFullReload) {
                        let indexPath = IndexPath(item: row, section: 0)
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        row = row + 1
                    }
                }
                
                if (withFullReload) {
                    self.tableView.reloadData()
                }
            }
            response.result.ifFailure {
                print(response.error?.localizedDescription ?? String())
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
        cell?.amountTextField.text = String(self.items[indexPath.row].value * self.selectedRate.value)
        cell?.imageView?.image = UIImage(named: self.items[indexPath.row].shortCurrencyName)
        cell?.amountTextField.delegate = self

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! RVConverterTableViewCell
        let rate = self.items.remove(at: indexPath.row)
        self.items.insert(rate, at: 0)
        cell.amountTextField.becomeFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        self.selectedRate = self.items[0]
        self.selectedRate.value = Double(textField.text!)
        self.getLatest(withFullReload: false)
        
        return true
    }

}
