//
//  PostViewCell.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import UIKit

class PostViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
    }
    
    func config(post: Post) {
        titleLabel.text = post.title
        priceLabel.text = "\((post.price).formattedWithSeparator)đ"
        addressLabel.text = post.getFullAddress()
    }
}
