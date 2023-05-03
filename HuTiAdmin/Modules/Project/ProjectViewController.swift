//
//  ProjectViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 01/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ProjectViewController: HuTiViewController {

    @IBOutlet weak var projectTableView: UITableView!
    
    var viewModel = ProjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTableView()
        findProject(param: viewModel.findProjectParams)
        addPullToRefresh()
        infiniteScroll()
    }
    
    private func findProject(param: [String: Any]) {
        viewModel.findProject(param: param).subscribe { [weak self] projects in
            guard let self = self else { return }
            if projects.count > 0 {
                if self.viewModel.page == 1 {
                    self.viewModel.project.accept(projects)
                } else {
                    self.viewModel.project.accept(self.viewModel.project.value + projects)
                }
            } else if self.viewModel.page == 1 {
                self.viewModel.project.accept([])
            }
        }.disposed(by: viewModel.bag)
    }
    
    private func setupTableView() {
        projectTableView.rowHeight = CommonConstants.tableRowHeight
        projectTableView.separatorStyle = .none
        
        projectTableView.register(ProjectViewCell.nib, forCellReuseIdentifier: ProjectViewCell.reusableIdentifier)
        
        viewModel.project.asObservable()
            .bind(to: projectTableView.rx.items(cellIdentifier: ProjectViewCell.reusableIdentifier, cellType: ProjectViewCell.self)) { (index, element, cell) in
                cell.config(project: element)
            }.disposed(by: viewModel.bag)
        
        projectTableView.rx
            .modelSelected(Project.self)
            .subscribe { [weak self] element in
                guard let self = self else { return }
                let vc = ProjectDetailViewController.instance(projectId: element.id ?? "")
                self.navigateTo(vc)
            }.disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapAddProjectButton(_ sender: UIButton) {
        let vc = AddProjectViewController()
        navigateTo(vc)
    }
    
    private func addPullToRefresh() {
        projectTableView.addPullToRefresh { [weak self] in
            guard let self = self else { return }
            self.projectTableView.backgroundView = nil
            self.refreshData()
            self.projectTableView.pullToRefreshView.stopAnimating()
        }
    }
    
    private func refreshData() {
        viewModel.page = 1
        viewModel.project.accept([])
        viewModel.findProjectParams = [String: Any]()
        findProject(param: viewModel.findProjectParams)
    }
    
    private func infiniteScroll() {
        projectTableView.addInfiniteScrolling { [weak self] in
            guard let self = self else { return }
            self.viewModel.page += 1
            self.findProject(param: self.viewModel.findProjectParams)
            self.projectTableView.infiniteScrollingView.stopAnimating()
        }
    }
}
