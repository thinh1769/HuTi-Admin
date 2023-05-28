//
//  StatisticsViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 27/05/2023.
//

import UIKit
import SnapKit
import Charts
import RxSwift
import RxCocoa

class StatisticsViewController: HuTiViewController {
    lazy private var titleLabel = makeLabel(text: "Thống kê", font: UIFont.systemFont(ofSize: 25, weight: .semibold), textColor: UIColor(named: ColorName.themeText)!)
    lazy private var container = makeEmptyView(color: .clear)
    lazy private var postView = makeEmptyView(color: .systemGray5)
    lazy private var postLabel = makeLabel(text: "Tin đăng", font: UIFont.systemFont(ofSize: 18, weight: .semibold), textColor: UIColor(named: ColorName.black)!)
    lazy private var reportView = makeEmptyView(color: .systemGray5)
    lazy private var reportLabel = makeLabel(text: "Báo cáo", font: UIFont.systemFont(ofSize: 18, weight: .semibold), textColor: UIColor(named: ColorName.black)!)
    lazy private var typeView = makeEmptyView(color: .white)
    lazy private var typeTextField = makeTextField()
    lazy private var chevronDown1 = makeIcon()
    lazy private var chevronDown2 = makeIcon()
    lazy private var dateView = makeEmptyView(color: .white)
    lazy private var dateTextField = makeTextField()
    private var chartView: BarChartView?
    private let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    private var topSafeAreaPadding: CGFloat?
    private let viewModel = StatisticsViewModel()
    private let typePicker = UIPickerView()
    private let datePicker = UIDatePicker()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layout()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(named: ColorName.background)
        postView.layer.cornerRadius = 8
        reportView.layer.cornerRadius = 8
        dateView.layer.cornerRadius = 8
        typeView.layer.cornerRadius = 8
        chevronDown1.setImageColor(color: UIColor(named: ColorName.themeText) ?? .white)
        chevronDown2.setImageColor(color: UIColor(named: ColorName.themeText) ?? .white)
        topSafeAreaPadding = self.window?.safeAreaInsets.top
        resetTextField()
        setupTypePickerView()
        setupDatePickerView()
        
        view.addSubview(titleLabel)
        view.addSubview(container)
        container.addSubview(postView)
        container.addSubview(reportView)
        postView.addSubview(postLabel)
        reportView.addSubview(reportLabel)
        view.addSubview(typeView)
        view.addSubview(dateView)
        typeView.addSubview(typeTextField)
        typeView.addSubview(chevronDown1)
        dateView.addSubview(dateTextField)
        dateView.addSubview(chevronDown2)
        
        setupContainerView()
        didSelectContainerView(index: 0)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40 + (topSafeAreaPadding ?? 0))
            make.centerX.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        let tabWidth = (UIScreen.main.bounds.width - 25) / 2
        postView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(tabWidth)
        }
        
        postLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        reportView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(tabWidth)
        }
        
        reportLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        typeView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(tabWidth)
            make.top.equalTo(container.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        chevronDown1.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
        
        typeTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalTo(chevronDown1.snp.leading)
        }
        
        dateView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(tabWidth)
            make.top.equalTo(container.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        chevronDown2.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalTo(chevronDown2.snp.leading)
        }
    }
    
    private func layoutChartView() {
        view.addSubview(chartView ?? BarChartView())
        
        chartView?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(self.mainTabBarController?.tabBar.bounds.height ?? 0) - 20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(typeView.snp.bottom).offset(20)
        }
    }
    
    private func getAllPost() {
        viewModel.getAllPosts().subscribe { [weak self] posts in
            guard let self = self else { return }
            let data = self.viewModel.parsePostArray(posts: posts)
            self.removeChartView()
            self.chartView = self.makeChartView(data: data)
            self.layoutChartView()
        }.disposed(by: viewModel.bag)
    }
    
    private func getAllReport() {
        viewModel.getAllReport().subscribe { [weak self] reports in
            guard let self = self else { return }
            let data = self.viewModel.parseReportArray(reports: reports)
            self.removeChartView()
            self.chartView = self.makeChartView(data: data)
            self.layoutChartView()
        }.disposed(by: viewModel.bag)
    }
    
    private func removeChartView() {
        if self.chartView != nil {
            self.chartView?.removeFromSuperview()
        }
    }
    
    private func resetTextField() {
        typeTextField.text = ""
        dateTextField.text = ""
        dateTextField.isUserInteractionEnabled = false
    }
    
    private func setupContainerView() {
        postView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPostView)))
        reportView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReportView)))
    }
    
    @objc private func didTapPostView() {
        didSelectContainerView(index: 0)
        removeChartView()
        resetTextField()
    }
    
    @objc private func didTapReportView() {
        didSelectContainerView(index: 1)
        removeChartView()
        resetTextField()
    }
    
    private func didSelectContainerView(index: Int) {
        switch index {
        case 0:
            postView.backgroundColor = UIColor(named: ColorName.darkBackground)
            reportView.backgroundColor = .systemGray5
            viewModel.isStatisticsPost = true
        default:
            postView.backgroundColor = .systemGray5
            reportView.backgroundColor = UIColor(named: ColorName.darkBackground)
            viewModel.isStatisticsPost = false
        }
    }
}

extension StatisticsViewController {
    private func setupTypePickerView() {
        typeTextField.inputView = typePicker
        typeTextField.tintColor = .clear
        typeTextField.placeholder = "Thống kê theo"
        typePicker.tag = PickerTag.type
        typeTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.type)
        
        viewModel.type.accept(PickerData.statisticsType)

        viewModel.type.subscribe(on: MainScheduler.instance)
            .bind(to: typePicker.rx.itemTitles) { (row, element) in
                return element
            }.disposed(by: viewModel.bag)

        typePicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedType = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupDatePickerView() {
        dateTextField.inputView = datePicker
        dateTextField.tintColor = .clear
        dateTextField.placeholder = "Chọn thời gian"
        datePicker.tag = PickerTag.date
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date().getMinimumDate()
        datePicker.maximumDate = Date().getMaximumDate()
        
        dateTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.date)
    }
    
    private func setupPickerToolBar(pickerTag: Int) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = .clear
        toolBar.sizeToFit()
       
        var doneButton = UIBarButtonItem(title: CommonConstants.done, style: .done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: CommonConstants.cancel, style: .plain, target: self, action: #selector(self.cancelPicker))
        
        if pickerTag == PickerTag.date {
            doneButton = UIBarButtonItem(title: CommonConstants.done, style: .done, target: self, action: #selector(self.doneDatePicker))
        }
        
        cancelButton.tag = pickerTag
        doneButton.tag = pickerTag
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc private func doneDatePicker() {
        switch viewModel.type.value[viewModel.selectedType] {
        case "Theo ngày":
            viewModel.formatString = CommonConstants.DATE_FORMAT
        case "Theo tháng":
            viewModel.formatString = CommonConstants.MONTH_FORMAT
        default:
            viewModel.formatString = CommonConstants.YEAR_FORMAT
        }
        viewModel.selectedDate = DateFormatter.instance(formatString: viewModel.formatString).string(from: datePicker.date)
        dateTextField.text = viewModel.selectedDate
        getAllPost()
        view.endEditing(true)
    }
    
    @objc private func donePicker(sender: UIBarButtonItem) {
        switch sender.tag {
        case PickerTag.type:
            typeTextField.text = viewModel.pickItem(pickerTag: sender.tag)
            dateTextField.text = ""
            dateTextField.isUserInteractionEnabled = true
        default:
            return
        }
        view.endEditing(true)
    }
    
    @objc private func cancelPicker() {
        view.window?.endEditing(true)
    }
}

extension StatisticsViewController {
    private func makeChartView(data: [BarChartDataEntry]) -> BarChartView {
        let chartView = BarChartView()
        let dataEntries = data
        var chartViewLabel = ""
        if viewModel.isStatisticsPost {
            chartViewLabel = "Số tin đăng"
        } else {
            chartViewLabel = "Số báo cáo"
        }
        let dataSet = BarChartDataSet(entries: dataEntries, label: chartViewLabel)
        dataSet.setColor(UIColor(named: ColorName.themeText) ?? .clear)
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.5
        chartView.data = data
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = IndexAxisValueFormatter(values: viewModel.chartYLabel)
        xAxis.labelCount = dataEntries.count
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.isUserInteractionEnabled = false
        return chartView
    }
    
    private func makeLabel(text: String, font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }
    
    private func makeEmptyView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
    
    private func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.tintColor = .clear
        return textField
    }
    
    private func makeIcon() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        return imageView
    }
}
