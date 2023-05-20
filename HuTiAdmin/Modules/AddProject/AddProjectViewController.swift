//
//  AddProjectViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 01/05/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import MapKit
import CoreLocation
import PhotosUI

class AddProjectViewController: HuTiViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var wardTextField: UITextField!
    @IBOutlet weak var editLocationButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var acreageTextField: UITextField!
    @IBOutlet weak var minPriceTextField: UITextField!
    @IBOutlet weak var maxPriceTextField: UITextField!
    @IBOutlet weak var legalTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var apartmentTextField: UITextField!
    @IBOutlet weak var investorTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteProjectButton: UIButton!
    
    let typePicker = UIPickerView()
    let provincePicker = UIPickerView()
    let districtPicker = UIPickerView()
    let wardPicker = UIPickerView()
    let statusPicker = UIPickerView()
    var viewModel = AddProjectViewModel()
    private var locationManager = CLLocationManager()
    private let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    var config = PHPickerConfiguration()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupPickerView()
        setupImageCollectionView()
        mapView.isUserInteractionEnabled = false
        mapView.showsUserLocation = true
        minPriceTextField.delegate = self
        maxPriceTextField.delegate = self
        currentLocationButton.isUserInteractionEnabled = false

        provinceTextField.rx.controlEvent([.editingDidEnd,.valueChanged])
            .subscribe { [weak self] _ in
            guard let self = self,
                  let text = self.provinceTextField.text
                else { return }
            if text.count > 0 {
                self.moveCameraToLocation(21.0031177, 105.8201408)
            }
        }.disposed(by: viewModel.bag)
        
        if viewModel.isEdit {
            loadProjectForEdit()
            submitButton.setTitle("Lưu", for: .normal)
            titleLabel.text = "Chỉnh sửa dự án"
            deleteProjectButton.isHidden = false
        } else {
            submitButton.setTitle("Thêm dự án", for: .normal)
            titleLabel.text = "Dự án mới"
            deleteProjectButton.isHidden = true
        }
    }
    
    private func loadProjectForEdit() {
        guard let project = viewModel.project else { return }
        typeTextField.text = project.projectType
        provinceTextField.text = project.provinceName
        districtTextField.text = project.districtName
        wardTextField.text = project.wardName
        moveCameraToLocation(project.lat, project.long)
        nameTextField.text = project.name
        descriptionTextView.text = project.description
        acreageTextField.text = "\(project.acreage)"
        minPriceTextField.text = "\(project.minPrice)"
        maxPriceTextField.text = "\(project.maxPrice)"
        statusTextField.text = project.status
        legalTextField.text = project.legal
        buildingTextField.text = "\(project.building ?? 0)"
        apartmentTextField.text = "\(project.apartment ?? 0)"
        investorTextField.text = project.investor
        viewModel.imagesName.accept(project.images)
        viewModel.imagesNameList = project.images
    }

    private func setupImageCollectionView() {
        imageCollectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.reusableIdentifier)
        
        if !viewModel.isEdit {
            viewModel.selectedImage.asObservable()
                .bind(to: imageCollectionView.rx.items(cellIdentifier: ImageCell.reusableIdentifier, cellType: ImageCell.self)) { [weak self] (index, element, cell) in
                    guard let self = self else { return }
                    cell.config(image: element)
                    
                    cell.onTapRemove = {
                        self.viewModel.imagesList.remove(at: index)
                        self.viewModel.imagesNameList.remove(at: index)
                        self.viewModel.setupDataImageCollectionView()
                    }
                }.disposed(by: viewModel.bag)
        } else {
            viewModel.imagesName.asObservable()
                .bind(to: imageCollectionView.rx.items(cellIdentifier: ImageCell.reusableIdentifier, cellType: ImageCell.self)) { [weak self] (index, element, cell) in
                    guard let self = self else { return }
                    cell.configImage(imageName: element, isEnableRemove: true)

                    cell.onTapRemove = {
                        self.viewModel.imagesNameList.remove(at: index)
                        self.viewModel.imagesName.accept(self.viewModel.imagesNameList)
                    }
                }.disposed(by: viewModel.bag)
        }
        
        imageCollectionView.rx.setDelegate(self).disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapEditLocationButton(_ sender: UIButton) {
        if !viewModel.isEditBtnClicked {
            editLocationButton.setTitle(CommonConstants.done, for: .normal)
            mapView.isUserInteractionEnabled = true
            currentLocationButton.isUserInteractionEnabled = true
        } else {
            editLocationButton.setTitle(CommonConstants.edit, for: .normal)
            mapView.isUserInteractionEnabled = false
            currentLocationButton.isUserInteractionEnabled = false
        }
        viewModel.isEditBtnClicked = !viewModel.isEditBtnClicked
    }
    
    @IBAction func didTapCurrentLocationButton(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func didTapAddImageButton(_ sender: UIButton) {
        config.filter = .images
        config.selectionLimit = 10 - viewModel.imagesList.count
        
        if config.selectionLimit > 0 {
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            showAlert(title: "Chỉ được chọn tối đa 10 hình ảnh")
        }
    }
    
    @IBAction func didTapSubmitButton(_ sender: UIButton) {
        if !viewModel.isEdit {
            showLoading()
            viewModel.uploadImages {
                DispatchQueue.main.async {
                    self.viewModel.addNewProject(  long: self.mapView.centerCoordinate.longitude,
                                                   lat: self.mapView.centerCoordinate.latitude,
                                                   name: self.nameTextField.text ?? "",
                                                   description: self.descriptionTextView.text ?? "",
                                                   acreage: self.acreageTextField.text ?? "",
                                                   minPrice: Double(self.minPriceTextField.text ?? "") ?? 0,
                                                   maxPrice: Double(self.maxPriceTextField.text ?? "") ?? 0,
                                                   legal: self.legalTextField.text ?? "",
                                                   building: Int(self.buildingTextField.text ?? "") ?? 0,
                                                   apartment: Int(self.apartmentTextField.text ?? "") ?? 0,
                                                   investor: self.investorTextField.text ?? "")
                    .subscribe { [weak self] _ in
                        guard let self = self else { return }
                        self.hideLoading()
                        self.backToPreviousView()
                        self.showAlert(title: "Thêm dự án thành công")
                    }.disposed(by: self.viewModel.bag)
                }
            }
        } else if viewModel.checkUpdateProject(typeTextField.text ?? "",
                                               provinceTextField.text ?? "",
                                               districtTextField.text ?? "",
                                               wardTextField.text ?? "",
                                               mapView.centerCoordinate.latitude,
                                               mapView.centerCoordinate.longitude,
                                               nameTextField.text ?? "",
                                               descriptionTextView.text,
                                               acreageTextField.text ?? "",
                                               minPriceTextField.text ?? "",
                                               maxPriceTextField.text ?? "",
                                               legalTextField.text ?? "",
                                               statusTextField.text ?? "",
                                               buildingTextField.text ?? "",
                                               apartmentTextField.text ?? "",
                                               investorTextField.text ?? "") {
            viewModel.updateProject().subscribe { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
                self.showAlert(title: "Chỉnh sửa thông tin dự án thành công")
            }.disposed(by: viewModel.bag)
        } else {
            self.showAlert(title: "Bạn chưa chỉnh sửa thông tin dự án")
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        backToPreviousView()
    }
    
    private func setupPickerView() {
        setupTypePickerView()
        setupProvincePickerView()
        setupDistrictPickerView()
        setupWardPickerView()
        setupStatusPickerView()
    }
    
    @IBAction func didTapDeleteProjectButton(_ sender: UIButton) {
        viewModel.deleteProject().subscribe { [weak self] _ in
            guard let self = self else { return }
            self.backToPreviousView()
            self.backToPreviousView()
            self.showAlert(title: "Xóa dự án thành công")
        }.disposed(by: viewModel.bag)
    }
    
}

extension AddProjectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCollectionView.bounds.width / 2, height: imageCollectionView.bounds.height)
    }
}

extension AddProjectViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            moveCameraToLocation(location.coordinate.latitude, location.coordinate.longitude)
            mapView.showsUserLocation = true
        }
    }
    
    private func moveCameraToLocation(_ lat: Double, _ long: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
}

extension AddProjectViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                if let image = image {
                    self.viewModel.imageSelected = (image as! UIImage).rotate()
                    self.viewModel.imagesList.append(self.viewModel.imageSelected)
                    self.viewModel.setupDataImageCollectionView()

                    let now = Date()
                    let timeInterval = now.timeIntervalSince1970
                    self.viewModel.imagesNameList.append("\(UserDefaults.userInfo?.id ?? "")_\(timeInterval)")
                }
            }
        }
    }
}

extension AddProjectViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "," {
            textField.text = (textField.text ?? "") + "."
            return false
        }
        return true
    }
}

extension AddProjectViewController {
    private func setupTypePickerView() {
        typeTextField.inputView = typePicker
        typeTextField.tintColor = .clear
        typePicker.tag = PickerTag.type
        typeTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.type)
        
        viewModel.type.accept(RealEstateType.addProject)

        viewModel.type.subscribe(on: MainScheduler.instance)
            .bind(to: typePicker.rx.itemTitles) { (row, element) in
                return element
            }.disposed(by: viewModel.bag)

        typePicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedType = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupProvincePickerView() {
        provinceTextField.inputView = provincePicker
        provinceTextField.tintColor = .clear
        provincePicker.tag = PickerTag.province
        provinceTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.province)

        viewModel.getAllProvinces().subscribe { [weak self] provinces in
            guard let self = self else { return }
            self.viewModel.province.accept(self.viewModel.parseProvincesArray(provinces: provinces))
        } onError: { _ in
        } onCompleted: {
        } .disposed(by: viewModel.bag)

        viewModel.province.subscribe(on: MainScheduler.instance)
            .bind(to: provincePicker.rx.itemTitles) { (row, element) in
                return element.name
            }.disposed(by: viewModel.bag)

        provincePicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedProvince = row
        }.disposed(by: viewModel.bag)
    }

    private func setupDistrictPickerView() {
        districtTextField.inputView = districtPicker
        districtTextField.tintColor = .clear
        districtPicker.tag = PickerTag.district
        districtTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.district)

        viewModel.district.subscribe(on: MainScheduler.instance)
            .bind(to: districtPicker.rx.itemTitles) { (row, element) in
                return element.name
            }.disposed(by: viewModel.bag)

        districtPicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedDistrict = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupDistrictDataPicker() {
        districtTextField.text = ""
        wardTextField.text = ""
        
        viewModel.getDistrictsByProvinceId().subscribe { [weak self] districts in
            guard let self = self else { return }
            self.viewModel.district.accept(self.viewModel.parseDistrictsArray(districts: districts))
        } onError: { _ in
        } onCompleted: {
        }.disposed(by: viewModel.bag)
    }

    private func setupWardPickerView() {
        wardTextField.inputView = wardPicker
        wardTextField.tintColor = .clear
        wardPicker.tag = PickerTag.ward
        wardTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.ward)

        viewModel.ward.subscribe(on: MainScheduler.instance)
            .bind(to: wardPicker.rx.itemTitles) { (row, element) in
                return element.name
            }.disposed(by: viewModel.bag)

        wardPicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedWard = row
        }.disposed(by: viewModel.bag)
    }

    private func setupWardDataPicker() {
        wardTextField.text = ""
        
        viewModel.getWardsByDistrictId().subscribe { [weak self] wards in
            guard let self = self else { return }
            self.viewModel.ward.accept(self.viewModel.parseWardsArray(wards: wards))
        } onError: { _ in
        } onCompleted: {
        }.disposed(by: viewModel.bag)
    }
    
    private func setupStatusPickerView() {
        statusTextField.inputView = statusPicker
        statusTextField.tintColor = .clear
        statusPicker.tag = PickerTag.status
        statusTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.status)
        
        viewModel.status.accept(PickerData.status)
        
        viewModel.status.subscribe(on: MainScheduler.instance)
            .bind(to: statusPicker.rx.itemTitles) { (row, element) in
                return element
            }.disposed(by: viewModel.bag)

        statusPicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedStatus = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupPickerToolBar(pickerTag: Int) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = .clear
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: CommonConstants.done, style: .done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: CommonConstants.cancel, style: .plain, target: self, action: #selector(self.cancelPicker))
        
        cancelButton.tag = pickerTag
        doneButton.tag = pickerTag
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc private func donePicker(sender: UIBarButtonItem) {
        switch sender.tag {
        case PickerTag.type:
            typeTextField.text = viewModel.pickItem(pickerTag: sender.tag)
        case PickerTag.province:
            provinceTextField.text = viewModel.pickItem(pickerTag: sender.tag)
            if provinceTextField.text != "" {
                setupDistrictDataPicker()
            }
        case PickerTag.district:
            districtTextField.text = viewModel.pickItem(pickerTag: sender.tag)
            if districtTextField.text != "" {
                setupWardDataPicker()
            }
        case PickerTag.ward:
            wardTextField.text = viewModel.pickItem(pickerTag: sender.tag)
        case PickerTag.status:
            statusTextField.text = viewModel.pickItem(pickerTag: sender.tag)
        default:
            return
        }
        view.endEditing(true)
    }
    
    @objc private func cancelPicker() {
        view.window?.endEditing(true)
    }
}

extension AddProjectViewController {
    class func instance(isEdit: Bool, project: Project?) -> AddProjectViewController {
        let controller = AddProjectViewController(nibName: ClassNibName.AddProjectViewController, bundle: Bundle.main)
        controller.viewModel.isEdit = isEdit
        controller.viewModel.project = project
        return controller
    }
}
