//
//  ProjectViewCell.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 02/05/2023.
//

import UIKit

class ProjectViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var investorLabel: UILabel!
    
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
    }
    
    func config(project: Project) {
        nameLabel.text = project.name
        addressLabel.text = project.getFullAddress()
        statusLabel.text = project.status
        self.configStatusView(project.status)
        investorLabel.text = project.investor
        
    }
    
    private func configStatusView(_ status: String) {
        switch status {
        case PickerData.status[0]:
            statusView.backgroundColor = UIColor(named: ColorName.redStatusBackground)
            statusLabel.textColor = UIColor(named: ColorName.redStatusText)
        case PickerData.status[1]:
            statusView.backgroundColor = UIColor(named: ColorName.greenStatusBackground)
            statusLabel.textColor = UIColor(named: ColorName.greenStatusText)
        case PickerData.status[2]:
            statusView.backgroundColor = UIColor(named: ColorName.purpleStatusBackground)
            statusLabel.textColor = UIColor(named: ColorName.purpleStatusText)
        default:
            return
        }
    }
}
