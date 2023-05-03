//
//  PostDetailViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 30/04/2023.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import CoreLocation

class PostDetailViewController: HuTiViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var acreageLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var legalLabel: UILabel!
    @IBOutlet weak var funitureLabel: UILabel!
    @IBOutlet weak var bedroomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var houseDirectionLabel: UILabel!
    @IBOutlet weak var balconyDirectionLabel: UILabel!
    @IBOutlet weak var wayInLabel: UILabel!
    @IBOutlet weak var facadeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectView: UIStackView!
    @IBOutlet weak var funitureView: UIStackView!
    @IBOutlet weak var bedroomView: UIStackView!
    @IBOutlet weak var bathroomView: UIStackView!
    @IBOutlet weak var floorView: UIStackView!
    @IBOutlet weak var balconyView: UIStackView!
    @IBOutlet weak var wayInView: UIStackView!
    @IBOutlet weak var facadeView: UIStackView!
    @IBOutlet weak var isSellLabel: UILabel!
    
    var viewModel = PostDetailViewModel()
    private var locationManager = CLLocationManager()
    private let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }

    private func setupUI() {
        self.tabBarController?.tabBar.isHidden = true
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 8
        getPostDetail()
        setupImageCollectionView()
    }
    
    private func getPostDetail() {
        viewModel.getPostDetail(postId: viewModel.postId).subscribe { [weak self] postDetail in
            guard let self = self else { return }
            self.viewModel.postDetail = postDetail
            self.loadPostDetail()
            self.viewModel.images.accept(postDetail.images)
        } onCompleted: {
        }.disposed(by: viewModel.bag)
    }
    
    private func loadPostDetail() {
        guard let post = viewModel.postDetail else { return }
        titleLabel.text = post.title
        addressLabel.text = post.getFullAddress()
        typeLabel.text = post.realEstateType
        if post.isSell {
            isSellLabel.text = TabBarItemTitle.sell
        } else {
            isSellLabel.text = TabBarItemTitle.forRent
        }
        acreageLabel.text = "\(post.acreage) m2"
        priceLabel.text = "\((post.price).formattedWithSeparator)đ"
        legalLabel.text = post.legal
        funitureLabel.text = post.funiture
        bedroomLabel.text = "\(post.bedroom ?? 0)"
        bathroomLabel.text = "\(post.bathroom ?? 0)"
        floorLabel.text = "\(post.floor ?? 0)"
        houseDirectionLabel.text = post.houseDirection
        balconyDirectionLabel.text = post.balconyDirection
        wayInLabel.text = "\(post.wayIn ?? 0) m"
        facadeLabel.text = "\(post.facade ?? 0) m"
        descriptionLabel.text = post.description
        authorLabel.text = post.contactName
        phoneLabel.text = post.contactPhoneNumber
        if let project = post.projectName {
            projectNameLabel.text = project
        } else {
            projectView.isHidden = true
        }
        pinRealEstateLocation()
    
        unhiddenAllView()
        switch viewModel.postDetail?.realEstateType {
        case RealEstateType.apartment:
            self.floorView.isHidden = true
            self.wayInView.isHidden = true
            self.facadeView.isHidden = true
        case RealEstateType.projectLand:
            self.funitureView.isHidden = true
            self.bedroomView.isHidden = true
            self.bathroomView.isHidden = true
            self.floorView.isHidden = true
            self.balconyView.isHidden = true
        case RealEstateType.land:
            self.funitureView.isHidden = true
            self.bedroomView.isHidden = true
            self.bathroomView.isHidden = true
            self.floorView.isHidden = true
            self.balconyView.isHidden = true
        case RealEstateType.codontel:
            self.floorView.isHidden = true
            self.wayInView.isHidden = true
            self.facadeView.isHidden = true
        case RealEstateType.wareHouseFactory:
            self.bedroomView.isHidden = true
            self.floorView.isHidden = true
            self.balconyView.isHidden = true
        case RealEstateType.office:
            self.floorView.isHidden = true
        case RealEstateType.shopKiosk:
            self.bedroomView.isHidden = true
        default:
            return
        }
    }
    
    private func setupImageCollectionView() {
        imageCollectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.reusableIdentifier)
        
        viewModel.images.asObservable()
            .bind(to: imageCollectionView.rx.items(cellIdentifier: ImageCell.reusableIdentifier, cellType: ImageCell.self)) { (index, element, cell) in
                cell.configImage(imageName: element, isEnableRemove: false)
            }.disposed(by: viewModel.bag)
        
        imageCollectionView.rx.setDelegate(self).disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        backToPreviousView()
    }
    
    
    @IBAction func didTapApproveButton(_ sender: UIButton) {
        viewModel.browsePostParams = ["browseStatus": 1]
        viewModel.browsePost().subscribe { [weak self] _ in
            guard let self = self else { return }
            self.backToPreviousView()
            self.showAlert(title: "Duyệt thành công")
        }.disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapRejectButton(_ sender: UIButton) {
        viewModel.browsePostParams = ["browseStatus": 2]
        viewModel.browsePost().subscribe { [weak self] _ in
            guard let self = self else { return }
            self.backToPreviousView()
            self.showAlert(title: "Từ chối thành công")
        }.disposed(by: viewModel.bag)
    }
    
    @IBAction func didTapRealEstateLocationButton(_ sender: UIButton) {
        pinRealEstateLocation()
    }
    
    private func unhiddenAllView() {
        funitureView.isHidden = false
        bedroomView.isHidden = false
        bathroomView.isHidden = false
        floorView.isHidden = false
        balconyView.isHidden = false
        wayInView.isHidden = false
        facadeView.isHidden = false
    }
}

extension PostDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    private func moveCameraToLocation(_ lat: Double, _ long: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    private func pinRealEstateLocation() {
        guard let lat = viewModel.postDetail?.lat,
              let long = viewModel.postDetail?.long
        else { return }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        moveCameraToLocation(lat, long)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
}

extension PostDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCollectionView.bounds.width / 2, height: imageCollectionView.bounds.height)
    }
}

extension PostDetailViewController {
    class func instance(postId: String) -> PostDetailViewController {
        let controller = PostDetailViewController(nibName: ClassNibName.PostDetailViewController, bundle: Bundle.main)
        controller.viewModel.postId = postId
        return controller
    }
}
