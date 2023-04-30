//
//  PostDetailViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 30/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

class PostDetailViewController: HuTiViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var acreageLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var legalLabel: UILabel!
    @IBOutlet weak var funitureLabel: UILabel!
    @IBOutlet weak var bedroomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var houseDirectionLabel: UILabel!
    @IBOutlet weak var balconyDirectionLabel: UILabel!
    @IBOutlet weak var wayInLabel: UILabel!
    @IBOutlet weak var facadeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    var viewModel = PostDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }

    private func setupUI() {
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        getPostDetail()
        setupImageCollectionView()
    }
    
    private func getPostDetail() {
        viewModel.getPostDetail(postId: viewModel.postId).subscribe { [weak self] postDetail in
            guard let self = self else { return }
            self.viewModel.postDetail = postDetail
            self.loadPostDetail()
            self.viewModel.images.accept(postDetail.images)
//            self.getProjectInfo()
        } onCompleted: {
        }.disposed(by: viewModel.bag)
    }
    
    private func loadPostDetail() {
        guard let post = viewModel.postDetail else { return }
        titleLabel.text = post.title
        addressLabel.text = post.getFullAddress()
        acreageLabel.text = "\(post.acreage) m2"
        priceLabel.text = "\(post.price) VNĐ"
        legalLabel.text = post.legal
        funitureLabel.text = post.funiture
        bedroomLabel.text = "\(post.bedroom ?? 0)"
        bathroomLabel.text = "\(post.bathroom ?? 0)"
        floorLabel.text = "\(post.floor ?? 0)"
        houseDirectionLabel.text = post.houseDirection
        balconyDirectionLabel.text = post.balconyDirection
        wayInLabel.text = "\(post.wayIn ?? 0) m"
        facadeLabel.text = "\(post.facade ?? 0) m"
        descriptionLabel.text = post.description
//        self.pinRealEstateLocation()
    
    }
    
    private func setupImageCollectionView() {
        imageCollectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.reusableIdentifier)
        
        viewModel.images.asObservable()
            .bind(to: imageCollectionView.rx.items(cellIdentifier: ImageCell.reusableIdentifier, cellType: ImageCell.self)) { (index, element, cell) in
                cell.configImage(imageName: element)
            }.disposed(by: viewModel.bag)
        
        imageCollectionView.rx.setDelegate(self).disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        backToPreviousView()
    }
    
    
    @IBAction func didTapApproveButton(_ sender: UIButton) {
        viewModel.browsePostParams = ["browseStatus": 1]
        viewModel.browsePost().subscribe { [weak self] _ in
            guard let self = self else { return }
            self.backToPreviousView()
            self.showAlert(title: "Duyệt thành công")
        }.disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapRejectButton(_ sender: UIButton) {
        viewModel.browsePostParams = ["browseStatus": 2]
        viewModel.browsePost().subscribe { [weak self] _ in
            guard let self = self else { return }
            self.backToPreviousView()
            self.showAlert(title: "Từ chối thành công")
        }.disposed(by: viewModel.bag)
    }
}

extension PostDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCollectionView.bounds.width / 2, height: imageCollectionView.bounds.height)
    }
}
extension PostDetailViewController {
    class func instance(postId: String) -> PostDetailViewController {
        let controller = PostDetailViewController(nibName: ClassNibName.PostDetailViewController, bundle: Bundle.main)
        controller.viewModel.postId = postId
        return controller
    }
}
