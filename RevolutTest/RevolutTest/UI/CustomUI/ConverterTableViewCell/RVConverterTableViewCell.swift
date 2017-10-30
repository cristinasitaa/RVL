//
//  RVConverterTableViewCell.swift
//  RevolutTest
//
//  Created by cristinasita on 30/10/2017.
//  Copyright © 2017 cristinasita. All rights reserved.
//

import UIKit

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class RVConverterTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.amountTextField.setBottomBorder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.amountTextField.isEnabled = selected
    }
    
}
