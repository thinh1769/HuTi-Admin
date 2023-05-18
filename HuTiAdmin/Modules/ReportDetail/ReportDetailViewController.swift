//
//  ReportDetailViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 18/05/2023.
//

import UIKit

class ReportDetailViewController: HuTiViewController {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var reportUserNameLabel: UILabel!
    @IBOutlet weak var reportUserPhoneLabel: UILabel!
    @IBOutlet weak var postUserNameLabel: UILabel!
    @IBOutlet weak var postUserPhoneLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var viewModel = ReportDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        loadReportDetail()
    }
    
    private func loadReportDetail() {
        guard let report = viewModel.report else { return }
        postTitleLabel.text = report.postTitle
        reportUserNameLabel.text = report.reportUserName
        reportUserPhoneLabel.text = report.reportUserPhone
        postUserNameLabel.text = report.postUserName
        postUserPhoneLabel.text = report.postUserPhone
        contentLabel.text = report.content
    }

    @IBAction func didTapCallUserReportButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapUserPostButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        backToPreviousView()
    }
    
}

extension ReportDetailViewController {
    class func instance(report: Report) -> ReportDetailViewController {
        let controller = ReportDetailViewController(nibName: ClassNibName.ReportDetailViewController, bundle: Bundle.main)
        controller.viewModel.report = report
        return controller
    }
}
