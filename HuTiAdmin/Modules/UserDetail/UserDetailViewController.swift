//
//  UserDetailViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 03/05/2023.
//

import UIKit

class UserDetailViewController: HuTiViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var blockButton: UIButton!
    
    var viewModel = UserDetailViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTabBarController?.tabBar.isHidden = true
        if let user = viewModel.user,
           let isActive = user.isActive {
            if isActive {
                blockButton.setTitle("Chặn", for: .normal)
            } else {
                blockButton.setTitle("Bỏ chặn", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupPostTableView()
        loadUserInfo()
        getPostByUser()
        
        userInfoView.layer.masksToBounds = true
        userInfoView.layer.borderColor = UIColor(named: ColorName.themeText)?.cgColor
        userInfoView.layer.borderWidth = 1
    }
    
    private func getPostByUser() {
        viewModel.getPostByUser().subscribe { [weak self] posts in
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
            } else if self.viewModel.page == 1 {
                self.viewModel.post.accept([])
            }
        }.disposed(by: viewModel.bag)
    }
    
    private func loadUserInfo() {
        guard let user = viewModel.user else { return }
        nameLabel.text = user.name
        phoneLabel.text = user.phoneNumber
        emailLabel.text = user.email ?? ""
    }
    
    private func setupPostTableView() {
        postTableView.rowHeight = 120
        postTableView.separatorStyle = .none
        postTableView.register(PostViewCell.nib, forCellReuseIdentifier: PostViewCell.reusableIdentifier)
        
        viewModel.post.asObservable()
            .bind(to: postTableView.rx.items(cellIdentifier: PostViewCell.reusableIdentifier, cellType: PostViewCell.self)) { (index, element, cell) in
                cell.config(post: element)

            }.disposed(by: viewModel.bag)
        
        postTableView.rx
            .modelSelected(Post.self)
            .subscribe { [weak self] element in
                guard let self = self else { return }
                let vc = PostDetailViewController.instance(postId: element.id ?? "")
                self.navigateTo(vc)
            }.disposed(by: viewModel.bag)
        
        postTableViewAddPullToRefresh()
        postTableViewInfiniteScroll()
    }
    
    @IBAction func didTapCallButton(_ sender: Any) {
        if let phoneCallURL = URL(string: "tel://\(viewModel.user?.phoneNumber ?? "")") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    @IBAction func didTapBlockButton(_ sender: UIButton) {
        viewModel.blockUser().subscribe { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
            self.showAlert(title: "Chặn tài khoản thành công")
        }.disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        backToPreviousView()
    }
    
    private func postTableViewAddPullToRefresh() {
        postTableView.addPullToRefresh { [weak self] in
            guard let self = self else { return }
            self.postTableView.backgroundView = nil
            self.viewModel.post.accept([])
            self.viewModel.page = 1
            self.getPostByUser()
            self.postTableView.pullToRefreshView.stopAnimating()
        }
    }
    
    private func postTableViewInfiniteScroll() {
        if viewModel.post.value.count >= CommonConstants.pageSize {
            postTableView.addInfiniteScrolling { [weak self] in
                guard let self = self else { return }
                self.viewModel.page += 1
                self.getPostByUser()
                self.postTableView.infiniteScrollingView.stopAnimating()
            }
        }
    }
}

extension UserDetailViewController {
    class func instance(user: User) -> UserDetailViewController {
        let controller = UserDetailViewController(nibName: ClassNibName.UserDetailViewController, bundle: Bundle.main)
        controller.viewModel.user = user
        return controller
    }
}
