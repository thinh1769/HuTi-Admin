//
//  ReportViewCell.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 18/05/2023.
//

import UIKit

class ReportViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reportUserNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    func config(report: Report) {
        titleLabel.text = report.postTitle
        reportUserNameLabel.text = report.reportUserName
        dateLabel.text = report.getDate()
    }
}
