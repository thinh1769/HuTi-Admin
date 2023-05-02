//
//  ProjectViewCell.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 02/05/2023.
//

import UIKit

class ProjectViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UIStackView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var investorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
