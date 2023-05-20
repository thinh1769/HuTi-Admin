//
//  UserViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 03/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class UserViewController: HuTiViewController {

    @IBOutlet weak var userTableView: UITableView!
    
    var viewModel = UserViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupTableView()
        getListUser()
    }
    
    private func getListUser() {
        viewModel.getAllUser().subscribe { [weak self] users in
            guard let self = self else { return }
            if users.count > 0 {
                if self.viewModel.page == 1 {
                    self.viewModel.user.accept(users)
                } else {
                    self.viewModel.user.accept(self.viewModel.user.value + users)
                }
            } else if self.viewModel.page == 1 {
                self.viewModel.user.accept([])
            }
        }.disposed(by: viewModel.bag)
    }
    
    private func setupTableView() {
        userTableView.rowHeight = 70
        userTableView.separatorStyle = .none
        
        userTableView.register(UserViewCell.nib, forCellReuseIdentifier: UserViewCell.reusableIdentifier)
        
        viewModel.user.asObservable()
            .bind(to: userTableView.rx.items(cellIdentifier: UserViewCell.reusableIdentifier, cellType: UserViewCell.self)) { (index, element, cell) in
                cell.config(user: element)
            }.disposed(by: viewModel.bag)
        
        userTableView.rx
            .modelSelected(User.self)
            .subscribe { [weak self] element in
                guard let self = self else { return }
                let vc = UserDetailViewController.instance(userId: element.id ?? "")
                self.navigateTo(vc)
            }.disposed(by: viewModel.bag)
        
        addPullToRefresh()
        infiniteScroll()
    }
    
    private func addPullToRefresh() {
        userTableView.addPullToRefresh { [weak self] in
            guard let self = self else { return }
            self.userTableView.backgroundView = nil
            self.refreshData()
            self.userTableView.pullToRefreshView.stopAnimating()
        }
    }
    
    private func refreshData() {
        viewModel.page = 1
        viewModel.user.accept([])
        getListUser()
    }
    
    private func infiniteScroll() {
        userTableView.addInfiniteScrolling { [weak self] in
            guard let self = self else { return }
            if self.viewModel.user.value.count >= CommonConstants.pageSize {
                self.viewModel.page += 1
                self.getListUser()
            }
            self.userTableView.infiniteScrollingView.stopAnimating()
        }
    }
}
