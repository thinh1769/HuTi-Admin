//
//  SendEmailPopUpView.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 20/05/2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol SendEmailPopupViewDelegate: AnyObject {
    func dismissBottomView()
    
    func didSendEmail(email: String, content: String)
    
    func didTapSubmitButtonWithEmptyContent()
}

class SendEmailPopupView: UIView {
    lazy private var topLine = makeTopLine()
    lazy private var titleLabel = makeLabel(text: "Gửi Email", font: UIFont.systemFont(ofSize: 22, weight: .semibold), textColor: UIColor(named: ColorName.themeText)!)
    lazy private var emailTitleLabel = makeLabel(text: "Đến:", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: UIColor(named: ColorName.black)!)
    lazy private(set) var emailLabel = makeLabel(text: "", font: UIFont.systemFont(ofSize: 16, weight: .regular), textColor: UIColor(named: ColorName.black)!)
    lazy private var textViewLabel = makeLabel(text: "Nội dung email", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: UIColor(named: ColorName.black)!)
    lazy private var textView = makeTextView()
    lazy private var submitButton = makeSubmitButton()
    
    var popupViewHeight: CGFloat = 0
    var bottomSafeAreaPadding: CGFloat = 0
    weak var delegate: SendEmailPopupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addPanGestureToBottomView()
        
        self.addSubview(topLine)
        self.addSubview(titleLabel)
        self.addSubview(emailTitleLabel)
        self.addSubview(emailLabel)
        self.addSubview(textViewLabel)
        self.addSubview(textView)
        self.addSubview(submitButton)
        
        emailLabel.numberOfLines = 0
        emailLabel.textAlignment = .left
    }
    
    private func layout() {
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.top)
            make.leading.equalTo(emailTitleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        textViewLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(textViewLabel.snp.bottom).offset(5)
            make.height.equalTo(150)
        }
        
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(textView.snp.bottom).offset(10)
        }
    }
    
    @objc private func dismissBottomView() {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0) {
            self.transform = CGAffineTransform(translationX: 0, y: self.popupViewHeight)
        } completion: { _ in
            self.removeFromSuperview()
            self.delegate?.dismissBottomView()
        }
    }
    
    @objc private func didTapSubmitButton() {
        guard let text = textView.text,
              text.count > 0
        else {
            delegate?.didTapSubmitButtonWithEmptyContent()
            return
        }
        delegate?.didSendEmail(email: emailLabel.text ?? "", content: text)
        self.dismissBottomView()
    }
    
    private func addPanGestureToBottomView() {
        let swipeDown = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        self.addGestureRecognizer(swipeDown)
    }
    
    @objc private func handleGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        gesture.location(in: self)
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0) {
                    self.transform = CGAffineTransform(translationX: 0, y: self.popupViewHeight)
                } completion: { _ in
                    self.removeFromSuperview()
                    self.delegate?.dismissBottomView()
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 1) {
                    self.transform = .identity
                }
            }
        default:
            return
        }
    }
}

extension SendEmailPopupView {
    private func makeTopLine() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.layer.cornerRadius = 2
        return view
    }
    
    private func makeLabel(text: String, font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }
    
    private func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8.0
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }
    
    private func makeSubmitButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Gửi", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(named: ColorName.themeText)
        button.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        return button
    }
}
