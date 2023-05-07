//
//  UserViewCell.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 03/05/2023.
//

import UIKit

class UserViewCell: UITableViewCell {
    @IBOutlet weak var isInactiveImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        isInactiveImage.isHidden = true
    }
    
    func config(user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        if let isActive = user.isActive {
            if isActive {
                isInactiveImage.isHidden = true
            } else {
                isInactiveImage.isHidden = false
            }
        }
    }
    
}
