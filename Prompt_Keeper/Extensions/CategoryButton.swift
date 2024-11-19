//
//  CategoryButton.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit

class CategoryButton: UIButton {
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .content : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.layer.cornerRadius = 21
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.baseBlack.cgColor
        self.titleLabel?.font = .regular(size: 15)
        self.setTitleColor(.baseBlack, for: .normal)
    }
}
