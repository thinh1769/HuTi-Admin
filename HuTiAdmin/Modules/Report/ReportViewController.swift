//
//  ReportViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 18/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ReportViewController: HuTiViewController {

    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var processedView: UIView!
    @IBOutlet weak var reportTableView: UITableView!
    
    var viewModel = ReportViewModel()
    
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
        getListReport()
        setupProcessView()
    }
    
    private func getListReport() {
        viewModel.getListReport().subscribe { [weak self] reports in
            guard let self = self else { return }
            if reports.count > 0 {
                if self.viewModel.page == 1 {
                    self.viewModel.report.accept(reports)
                } else {
                    self.viewModel.report.accept(self.viewModel.report.value + reports)
                }
            } else if self.viewModel.page == 1 {
                self.viewModel.report.accept([])
            }
        }.disposed(by: viewModel.bag)
    }
    
    private func setupTableView() {
        reportTableView.rowHeight = 135
        reportTableView.separatorStyle = .none
        
        reportTableView.register(ReportViewCell.nib, forCellReuseIdentifier: ReportViewCell.reusableIdentifier)
        
        viewModel.report.asObservable()
            .bind(to: reportTableView.rx.items(cellIdentifier: ReportViewCell.reusableIdentifier, cellType: ReportViewCell.self)) { (index, element, cell) in
                cell.config(report: element)
            }.disposed(by: viewModel.bag)
        
        reportTableView.rx
            .modelSelected(Report.self)
            .subscribe { [weak self] element in
                guard let self = self else { return }
                let vc = ReportDetailViewController.instance(report: element)
                self.navigateTo(vc)
            }.disposed(by: viewModel.bag)
        
        addPullToRefresh()
        infiniteScroll()
    }
    
    private func addPullToRefresh() {
        reportTableView.addPullToRefresh { [weak self] in
            guard let self = self else { return }
            self.reportTableView.backgroundView = nil
            self.refreshData()
            self.reportTableView.pullToRefreshView.stopAnimating()
        }
    }
    
    private func refreshData() {
        viewModel.page = 1
        viewModel.report.accept([])
        getListReport()
    }
    
    private func infiniteScroll() {
        reportTableView.addInfiniteScrolling { [weak self] in
            guard let self = self else { return }
            if self.viewModel.report.value.count >= CommonConstants.pageSize {
                self.viewModel.page += 1
                self.getListReport()
            }
            self.reportTableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    private func setupProcessView() {
        processingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProcessingView)))
        processedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProcessedView)))
    }
    
    @objc private func didTapProcessingView() {
        didSelectProcessView(index: 0)
        viewModel.page = 1
        viewModel.reportListStatus = 0
        getListReport()
    }
    
    @objc private func didTapProcessedView() {
        didSelectProcessView(index: 1)
        viewModel.page = 1
        viewModel.reportListStatus = 1
        getListReport()
    }
    
    private func didSelectProcessView(index: Int) {
        switch index {
        case 0:
            processingView.backgroundColor = UIColor(named: ColorName.darkBackground)
            processedView.backgroundColor = .systemGray5
        default:
            processingView.backgroundColor = .systemGray5
            processedView.backgroundColor = UIColor(named: ColorName.darkBackground)
        }
    }
}
