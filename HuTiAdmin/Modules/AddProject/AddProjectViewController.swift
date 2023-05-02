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
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var legalTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var apartmentTextField: UITextField!
    @IBOutlet weak var investorTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
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
//        setupImageCollectionView()
//        acreageTextField.delegate = self
////        formattingTextField(sender: priceTextField)
//        mapView.isUserInteractionEnabled = false
//        hidePostButton.isHidden = true
//        currentLocationButton.isUserInteractionEnabled = false
//        sellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickedSellView)))
//        forRentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickedForRentView)))
//
//        provinceTextField.rx.controlEvent([.editingDidEnd,.valueChanged])
//            .subscribe { [weak self] _ in
//            guard let self = self,
//                  let text = self.provinceTextField.text
//                else { return }
//            if text.count > 0 {
//                self.moveCameraToLocation(21.0031177, 105.8201408)
//            }
//        }.disposed(by: viewModel.bag)
//
//        typeTextField.rx.controlEvent([.editingDidEnd,.valueChanged])
//            .subscribe { [weak self] _ in
//            guard let self = self,
//                  let text = self.typeTextField.text
//                else { return }
//            if text.count > 0 {
//                self.hiddenUnnecessaryView(text: text)
//            }
//        }.disposed(by: viewModel.bag)
//
//        contactNameTextField.text = UserDefaults.userInfo?.name ?? ""
//        contactPhoneTextField.text = UserDefaults.userInfo?.phoneNumber
//
//        if viewModel.isEdit {
//            loadPostDetailForEdit()
//            hidePostButton.isHidden = false
//        }
    }

    @IBAction func didTapEditLocationButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapCurrentLocationButton(_ sender: UIButton) {
    }
    
    
    @IBAction func didTapAddImageButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapSubmitButton(_ sender: UIButton) {
        
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
//                    self.viewModel.imageSelected = (image as! UIImage).rotate()
//                    self.viewModel.imagesList.append(self.viewModel.imageSelected)
//                    self.viewModel.setupDataImageCollectionView()
//
//                    let now = Date()
//                    let timeInterval = now.timeIntervalSince1970
//                    self.viewModel.imagesNameList.append("\(UserDefaults.userInfo?.id ?? "")_\(timeInterval)")
                }
            }
        }
    }
}

extension AddProjectViewController {
    private func setupTypePickerView() {
        typeTextField.inputView = typePicker
        typeTextField.tintColor = .clear
        typePicker.tag = PickerTag.type
        typeTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.type)
        
        viewModel.type.accept(RealEstateType.project)

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
