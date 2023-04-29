//
//  HomeViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: HuTiViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var approvedLabel: UILabel!
    @IBOutlet weak var approvedView: UIView!
    @IBOutlet weak var rejectView: UIView!
    @IBOutlet weak var rejectLabel: UILabel!
    
    var viewModel = PostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        viewModel.getAllPosts().subscribe { [weak self] posts in
            guard let self = self else { return }
            print("post = \(posts)")
        }.disposed(by: viewModel.bag)
    }
    
    private func setupPostTableView() {
        postTableView.register(PostViewCell.nib, forCellReuseIdentifier: PostViewCell.reusableIdentifier)
        
//        viewModel.post.asObservable()
//            .bind(to: filterResultTableView.rx.items(cellIdentifier: FilterResultTableViewCell.reusableIdentifier, cellType: FilterResultTableViewCell.self)) { (index, element, cell) in
//                cell.configInfo(element, isHiddenAuthorAndHeart: false, isFavorite: self.isFavoritePost(postId: element.id))
//            }.disposed(by: viewModel.bag)
        
//        filterResultTableView.rx
//            .modelSelected(Post.self)
//            .subscribe { [weak self] element in
//                guard let self = self else { return }
//                let vc = PostDetailViewController.instance(postId: element.id ?? "", isFavorite: self.isFavoritePost(postId: element.id))
//                vc.delegate = self
//                self.navigateTo(vc)
//            }.disposed(by: viewModel.bag)
    }


}
