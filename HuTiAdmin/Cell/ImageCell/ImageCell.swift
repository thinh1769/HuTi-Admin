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
    }
    
    func config(image: UIImage) {
        imageView.image = image
    }
    
    func configImage(imageName: String) {
        if let url = URL(string: "\(AWSConstants.objectURL)\(imageName)") {
            imageView.sd_setImage(with: url, placeholderImage: nil, options: [.retryFailed, .scaleDownLargeImages], context: [.imageThumbnailPixelSize: CGSize(width: imageView.bounds.width * UIScreen.main.scale, height: imageView.bounds.height * UIScreen.main.scale)])
        }
    }

    @IBAction func didTapRemove(_ sender: UIButton) {
        self.onTapRemove?()
    }
    
}
