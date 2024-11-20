//
//  MyCell.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 20.11.24.
//

import UIKit
import DropDown

class MyCell: DropDownCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak override var optionLabel: UILabel! {
        didSet {

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
