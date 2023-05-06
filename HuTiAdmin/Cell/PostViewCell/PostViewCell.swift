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
    @IBOutlet weak var bottomBrowseView: UIView!
    @IBOutlet weak var browseStatusView: UIView!
    @IBOutlet weak var browseStatusLabel: UILabel!
    
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
        bottomBrowseView.isHidden = true
    }
    
    func config(post: Post, isShowBrowseStatus: Bool? = false) {
        titleLabel.text = post.title
        priceLabel.text = "\((post.price).formattedWithSeparator)đ"
        addressLabel.text = post.getFullAddress()
        
        if let browseStatus = isShowBrowseStatus {
            if browseStatus {
                bottomBrowseView.isHidden = false
            } else {
                bottomBrowseView.isHidden = true
            }
        }
        
        configBrowseStatusView(post.browseStatus ?? 0)
    }
    
    private func configBrowseStatusView(_ status: Int) {
        switch status {
        case 2:
            browseStatusView.backgroundColor = UIColor(named: ColorName.redStatusBackground)
            browseStatusLabel.textColor = UIColor(named: ColorName.redStatusText)
            browseStatusLabel.text = "Bị từ chối"
        case 1:
            browseStatusView.backgroundColor = UIColor(named: ColorName.greenStatusBackground)
            browseStatusLabel.textColor = UIColor(named: ColorName.greenStatusText)
            browseStatusLabel.text = "Đã duyệt"
        case 0:
            browseStatusView.backgroundColor = UIColor(named: ColorName.purpleStatusBackground)
            browseStatusLabel.textColor = UIColor(named: ColorName.purpleStatusText)
            browseStatusLabel.text = "Chờ duyệt"
        default:
            return
        }
    }
}
