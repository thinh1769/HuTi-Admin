//
//  ProjectDetailViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 03/05/2023.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

class ProjectDetailViewController: HuTiViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var acreageLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: UIStackView!
    @IBOutlet weak var buildingView: UIStackView!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var apartmentView: UIStackView!
    @IBOutlet weak var apartmentLabel: UILabel!
    @IBOutlet weak var legalView: UIStackView!
    @IBOutlet weak var legalLabel: UILabel!
    @IBOutlet weak var investorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private var viewModel = ProjectDetailViewModel()
    private var locationManager = CLLocationManager()
    private let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        getProjectDetail()
        loadProjectDetail()
        setupImageCollectionView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        backToPreviousView()
    }
    
    @IBAction func onClickedProjectLocationButton(_ sender: UIButton) {
        pinProjectLocation()
    }
    
    private func getProjectDetail() {
        viewModel.getProjectById().subscribe { [weak self] project in
            guard let self = self else { return }
            self.viewModel.project = project
            self.loadProjectDetail()
        }.disposed(by: viewModel.bag)
    }
    
    private func loadProjectDetail() {
        guard let project = viewModel.project else { return }
        viewModel.images.accept(project.images)
        nameLabel.text = project.name
        addressLabel.text = project.getFullAddress()
        statusLabel.text = project.status
        configStatusView(project.status)
        projectTypeLabel.text = project.projectType
        acreageLabel.text = "\(project.acreage)"
        if let price = project.price {
            priceLabel.text = price
        } else {
            priceView.isHidden = true
        }
        
        if let building = project.building {
            buildingLabel.text = "\(building)"
        } else {
            buildingView.isHidden = true
        }
        
        if let apartment = project.apartment {
            apartmentLabel.text = "\(apartment)"
        } else {
            apartmentView.isHidden = true
        }
        
        if let legal = project.legal {
            legalLabel.text = legal
        } else {
            legalView.isHidden = true
        }
        
        investorLabel.text = project.investor
        descriptionLabel.text = project.description
        self.pinProjectLocation()
    }
    
    private func setupImageCollectionView() {
        imageCollectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.reusableIdentifier)
        
        viewModel.images.asObservable()
            .bind(to: imageCollectionView.rx.items(cellIdentifier: ImageCell.reusableIdentifier, cellType: ImageCell.self)) { (index, element, cell) in
                cell.configImage(imageName: element, isEnableRemove: false)
            }.disposed(by: viewModel.bag)
        
        imageCollectionView.rx.setDelegate(self).disposed(by: viewModel.bag)
    }
    
    private func configStatusView(_ status: String) {
        switch status {
        case PickerData.status[0]:
            statusView.backgroundColor = UIColor(named: ColorName.redStatusBackground)
            statusLabel.textColor = UIColor(named: ColorName.redStatusText)
        case PickerData.status[1]:
            statusView.backgroundColor = UIColor(named: ColorName.greenStatusBackground)
            statusLabel.textColor = UIColor(named: ColorName.greenStatusText)
        case PickerData.status[2]:
            statusView.backgroundColor = UIColor(named: ColorName.purpleStatusBackground)
            statusLabel.textColor = UIColor(named: ColorName.purpleStatusText)
        default:
            return
        }
    }
    
}

extension ProjectDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCollectionView.bounds.width / 2, height: imageCollectionView.bounds.height)
    }
}

extension ProjectDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    private func moveCameraToLocation(_ lat: Double, _ long: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    private func pinProjectLocation() {
        guard let lat = viewModel.project?.lat,
              let long = viewModel.project?.long
        else { return }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        moveCameraToLocation(lat, long)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
}

extension ProjectDetailViewController {
    class func instance(projectId: String) -> ProjectDetailViewController {
        let controller = ProjectDetailViewController(nibName: ClassNibName.ProjectDetailViewController, bundle: Bundle.main)
        controller.viewModel.projectId = projectId
        return controller
    }
}
