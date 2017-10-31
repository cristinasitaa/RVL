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
    
    var selectedRate = RVRate(withString: "EUR 0")
    
    var timer: Timer!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "RVConverterTableViewCell", bundle: nil), forCellReuseIdentifier: "RVConverterTableViewCell")
        
        self.items.append(self.selectedRate)
        self.getLatest(withFullReload: true)
        self.startTimer()
    }
    
    //MARK:- Data
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
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
        if (self.selectedRate.value != nil) {
            cell?.amountTextField.text = String(self.items[indexPath.row].value * self.selectedRate.value)
        } else {
            cell?.amountTextField.text = "0"
        }
        cell?.imageView?.image = UIImage(named: self.items[indexPath.row].shortCurrencyName)
        cell?.amountTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.timer.invalidate()
       
        let rate = self.items.remove(at: indexPath.row)
        self.items.insert(rate, at: 0)
        self.selectedRate = self.items[0]
       
        self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! RVConverterTableViewCell
        cell.amountTextField.becomeFirstResponder()
        self.textFieldDidChange(textField: cell.amountTextField)
      
        self.getLatest(withFullReload: false)
        self.startTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextField
    @objc func textFieldDidChange(textField: UITextField) {
        let formatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
        let double = formatter.number(from: textField.text!)
        
        self.selectedRate.value = double?.doubleValue
    }
    
    //MARK:- Timer
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.getLatest(withFullReload: false)
        }
    }
}
