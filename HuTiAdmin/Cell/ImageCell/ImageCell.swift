//
//  ImageCell.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 30/04/2023.
//

import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var removeButton: UIButton!
    var onTapRemove: (() -> Void)?
    
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
        imageView.layer.cornerRadius = 5
        imageView.image = nil
        removeButton.isHidden = false
    }
    
    func config(image: UIImage) {
        imageView.image = image
    }
    
    func configImage(imageName: String, isEnableRemove: Bool) {
        if let url = URL(string: "\(AWSConstants.objectURL)\(imageName)") {
            imageView.sd_setImage(with: url, placeholderImage: nil, options: [.retryFailed, .scaleDownLargeImages], context: [.imageThumbnailPixelSize: CGSize(width: imageView.bounds.width * UIScreen.main.scale, height: imageView.bounds.height * UIScreen.main.scale)])
        }
        removeButton.isHidden = !isEnableRemove
    }

    @IBAction func didTapRemove(_ sender: UIButton) {
        self.onTapRemove?()
    }
    
}
