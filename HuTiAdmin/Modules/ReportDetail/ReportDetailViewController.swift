//
//  ReportDetailViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 18/05/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ReportDetailViewController: HuTiViewController {

    @IBOutlet weak var reportUserNameLabel: UILabel!
    @IBOutlet weak var reportUserPhoneLabel: UILabel!
    @IBOutlet weak var reportTimeLabel: UILabel!
    @IBOutlet weak var postUserNameLabel: UILabel!
    @IBOutlet weak var postUserPhoneLabel: UILabel!
    @IBOutlet weak var reportUserNameView: UIView!
    @IBOutlet weak var postUserNameView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var doneProcessButton: UIButton!
    @IBOutlet weak var doneProcessView: UIView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reportUserEmailLabel: UILabel!
    @IBOutlet weak var postUserEmailLabel: UILabel!
    
    lazy private var grayBackgroundView = makeGrayBackgroundView()
    private var viewModel = ReportDetailViewModel()
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    var bottomSafeAreaPadding: CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTabBarController?.tabBar.isHidden = true
        if let status = viewModel.report?.status {
            if status == 0 {
                doneProcessButton.isHidden = false
                doneProcessView.isHidden = true
                scrollViewBottomConstraint.constant = 50
            } else {
                doneProcessButton.isHidden = true
                doneProcessView.isHidden = false
                scrollViewBottomConstraint.constant = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        loadReportDetail()
        
        bottomSafeAreaPadding = self.window?.safeAreaInsets.bottom
    }
    
    private func loadReportDetail() {
        guard let report = viewModel.report else { return }
        reportUserNameLabel.text = report.reportUserName
        reportUserPhoneLabel.text = report.reportUserPhone
        reportUserEmailLabel.text = report.reportUserEmail
        reportTimeLabel.text = report.getDate()
        postUserNameLabel.text = report.postUserName
        postUserPhoneLabel.text = report.postUserPhone
        postUserEmailLabel.text = report.postUserEmail
        contentLabel.text = report.content
        
        setupUserView()
    }

    private func setupUserView() {
        reportUserNameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReportUser)))
        
        postUserNameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPostUser)))
    }
    
    @objc private func didTapReportUser() {
        let vc = UserDetailViewController.instance(userId: viewModel.report?.reportUserId ?? "")
        self.navigateTo(vc)
    }
    
    @objc private func didTapPostUser() {
        let vc = UserDetailViewController.instance(userId: viewModel.report?.postUserId ?? "")
        self.navigateTo(vc)
    }
    @IBAction func didTapCallUserReportButton(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "tel://\(viewModel.report?.reportUserPhone ?? "")") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func didTapUserPostButton(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "tel://\(viewModel.report?.postUserPhone ?? "")") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        backToPreviousView()
    }
    
    @IBAction func didTapDoneProcessButton(_ sender: UIButton) {
        self.showLoading()
        viewModel.processReport().subscribe { [weak self] _ in
            guard let self = self else { return }
            self.hideLoading()
            self.backToPreviousView()
            self.showAlert(title: "Hoàn tất xử lý báo cáo")
        }.disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapPostDetailButton(_ sender: UIButton) {
        let vc = PostDetailViewController.instance(postId: viewModel.report?.postId ?? "")
        self.navigateTo(vc)
    }
    
    @IBAction func didTapSendEmailToReportUser(_ sender: UIButton) {
        didTapSendEmail(email: viewModel.report?.reportUserEmail ?? "")
    }
    
    @IBAction func didTapSendEmailToPostUser(_ sender: UIButton) {
        didTapSendEmail(email: viewModel.report?.postUserEmail ?? "")
    }
    
    @IBAction func didTapCopyContentButton(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = contentLabel.text
    }
    
    private func didTapSendEmail(email: String) {
        self.view.addSubview(grayBackgroundView)
        
        grayBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let sendEmailView = SendEmailPopupView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 350 + (bottomSafeAreaPadding ?? 0)))
        sendEmailView.delegate = self
        sendEmailView.popupViewHeight = 350
        sendEmailView.tag = SubviewTag.detailView.rawValue
        sendEmailView.bottomSafeAreaPadding = bottomSafeAreaPadding ?? 0
        sendEmailView.emailLabel.text = email
        self.view.addSubview(sendEmailView)

        let finalFrame = CGRect(x: 0, y: self.view.bounds.height - sendEmailView.popupViewHeight - (bottomSafeAreaPadding ?? 0), width: self.view.bounds.width, height: sendEmailView.popupViewHeight + (bottomSafeAreaPadding ?? 0))
        
        UIView.animate(withDuration: 0.4) {
            sendEmailView.frame = finalFrame
        }
    }
    
    @objc private func didTapGrayBackgroundView() {
        for subview in view.subviews {
            if subview.tag == SubviewTag.detailView.rawValue {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0) {
                    subview.transform = CGAffineTransform(translationX: 0, y: 350)
                } completion: { _ in
                    subview.removeFromSuperview()
                }
            }
        }
        grayBackgroundView.removeFromSuperview()
    }
    
}

extension ReportDetailViewController: SendEmailPopupViewDelegate {
    func dismissBottomView() {
        grayBackgroundView.removeFromSuperview()
    }
    
    func didSendEmail(email: String, content: String) {
        self.showLoading()
        viewModel.sendEmail(email: email, content: content).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.hideLoading()
            self.showAlert(title: "Gửi email thành công")
        }.disposed(by: viewModel.bag)
    }
    
    func didTapSubmitButtonWithEmptyContent() {
        self.showAlert(title: "Vui lòng nhập nội dung email")
    }
}

extension ReportDetailViewController {
    class func instance(report: Report) -> ReportDetailViewController {
        let controller = ReportDetailViewController(nibName: ClassNibName.ReportDetailViewController, bundle: Bundle.main)
        controller.viewModel.report = report
        return controller
    }
}

extension ReportDetailViewController {
    private func makeGrayBackgroundView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.alpha = 0.3
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGrayBackgroundView)))
        return view
    }
}
