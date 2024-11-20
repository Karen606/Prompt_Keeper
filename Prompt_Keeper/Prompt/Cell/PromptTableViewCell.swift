//
//  PromptTableViewCell.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 20.11.24.
//

import UIKit

protocol PromtTableViewCellDelegate: AnyObject {
    func clickedMore(cell: PromptTableViewCell)
}

class PromptTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var infoBgView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    weak var delegate: PromtTableViewCellDelegate?
    var promptModel: PromptModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .medium(size: 20)
        descriptionLabel.font = .regular(size: 16)
        categoryLabel.font = .bold(size: 9)
        categoryLabel.layer.borderWidth = 2
        categoryLabel.layer.borderColor = UIColor.baseBlack.cgColor
        categoryLabel.layer.cornerRadius = 13
        categoryLabel.layer.masksToBounds = true
        categoryLabel.layer.zPosition = 1
        bgView.bringSubviewToFront(categoryLabel)
        bgView.addObserver(self, forKeyPath: "bounds", options: [.new, .old], context: nil)

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "bounds" {
                bgView.addRoundedBorder(cornerRadius: 8, borderColor: .baseBlack, borderWidth: 2)
                infoBgView.addTopBorder(color: .baseBlack, thickness: 2)
            }
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(prompt: PromptModel) {
        self.promptModel = prompt
        nameLabel.text = prompt.name
        descriptionLabel.text = prompt.info
        categoryLabel.text = "   \(prompt.category ?? "")   "
    }
    
    @IBAction func clickedMore(_ sender: UIButton) {
        PromptViewModel.shared.selectedPrompt = promptModel
        FavoritePromtViewModel.shared.selectedPrompt = promptModel
        delegate?.clickedMore(cell: self)
    }
}
