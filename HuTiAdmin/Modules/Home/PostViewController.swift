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
    @IBOutlet weak var approvedView: UIView!
    @IBOutlet weak var rejectedView: UIView!
    @IBOutlet weak var emptyView: UIView!
    
    var viewModel = PostViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTabBarController?.tabBar.isHidden = false
        findPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    private func setupUI() {
        emptyView.isHidden = true
        setupPostTableView()
        setupBrowseView()
    }
    
    private func findPost() {
        viewModel.findPost().subscribe { [weak self] posts in
            guard let self = self else { return }
            if posts.count > 0 {
                if self.viewModel.page == 1 {
                    let sortedPost = posts.sorted { $0.createdAt > $1.createdAt }
                    self.viewModel.post.accept(sortedPost)
                } else {
                    let mergePost = self.viewModel.post.value + posts
                    let sortedPost = mergePost.sorted { $0.createdAt > $1.createdAt }
                    self.viewModel.post.accept(sortedPost)
                }
                self.emptyView.isHidden = true
            } else if self.viewModel.page == 1 {
                self.viewModel.post.accept([])
                self.emptyView.isHidden = false
            }
        }.disposed(by: viewModel.bag)
    }
    
    private func setupPostTableView() {
        postTableView.rowHeight = 120
        postTableView.register(PostViewCell.nib, forCellReuseIdentifier: PostViewCell.reusableIdentifier)
        
        viewModel.post.asObservable()
            .bind(to: postTableView.rx.items(cellIdentifier: PostViewCell.reusableIdentifier, cellType: PostViewCell.self)) { (index, element, cell) in
                cell.config(post: element)

            }.disposed(by: viewModel.bag)
        
        postTableView.rx
            .modelSelected(Post.self)
            .subscribe { [weak self] element in
                guard let self = self else { return }
                let vc = PostDetailViewController.instance(postId: element.id ?? "", selectedTabIndex: self.viewModel.selectedTabIndex)
                self.navigateTo(vc)
            }.disposed(by: viewModel.bag)
        
        postTableViewAddPullToRefresh()
        postTableViewInfiniteScroll()
    }

    private func postTableViewAddPullToRefresh() {
        postTableView.addPullToRefresh { [weak self] in
            guard let self = self else { return }
            self.postTableView.backgroundView = nil
            self.viewModel.post.accept([])
            self.viewModel.page = 1
            self.findPost()
            self.postTableView.pullToRefreshView.stopAnimating()
        }
    }
    
    private func postTableViewInfiniteScroll() {
        postTableView.addInfiniteScrolling { [weak self] in
            guard let self = self else { return }
            if self.viewModel.post.value.count >= CommonConstants.pageSize {
                self.viewModel.page += 1
                self.findPost()
            }
            self.postTableView.infiniteScrollingView.stopAnimating()
        }
    }

    private func setupBrowseView() {
        pendingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPendingView)))
        approvedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapApprovedView)))
        rejectedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRejectedView)))
    }
    
    @IBAction func didTapSignOutButton(_ sender: UIButton) {
        UserDefaults.userInfo = nil
        let vc = SignInViewController()
        navigateTo(vc)
    }
    
    @objc private func didTapPendingView() {
        didSelectBrowseView(index: 0)
        viewModel.selectedTabIndex = 0
        viewModel.page = 1
        self.viewModel.findPostParams = ["browseStatus": 0]
        findPost()
    }
    
    @objc private func didTapApprovedView() {
        didSelectBrowseView(index: 1)
        viewModel.selectedTabIndex = 1
        viewModel.page = 1
        self.viewModel.findPostParams = ["browseStatus": 1]
        findPost()
    }
    
    @objc private func didTapRejectedView() {
        didSelectBrowseView(index: 2)
        viewModel.selectedTabIndex = 2
        viewModel.page = 1
        self.viewModel.findPostParams = ["browseStatus": 2]
        findPost()
    }
    
    private func didSelectBrowseView(index: Int) {
        switch index {
        case 0:
            pendingView.backgroundColor = UIColor(named: ColorName.darkBackground)
            approvedView.backgroundColor = .systemGray5
            rejectedView.backgroundColor = .systemGray5
        case 1:
            pendingView.backgroundColor = .systemGray5
            approvedView.backgroundColor = UIColor(named: ColorName.darkBackground)
            rejectedView.backgroundColor = .systemGray5
        default:
            pendingView.backgroundColor = .systemGray5
            approvedView.backgroundColor = .systemGray5
            rejectedView.backgroundColor = UIColor(named: ColorName.darkBackground)
        }
    }
}
