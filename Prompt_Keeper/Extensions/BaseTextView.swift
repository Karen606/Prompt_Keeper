//
//  BaseTextViewDelegate.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit

class BaseTextView: UITextView {
    
    private var customPadding = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 14)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = customPadding
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
}
