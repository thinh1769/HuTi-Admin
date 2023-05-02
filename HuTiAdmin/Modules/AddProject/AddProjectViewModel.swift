//
//  AddProjectViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 01/05/2023.
//

import Foundation
import RxSwift
import RxRelay

class AddProjectViewModel {
    let bag = DisposeBag()
    let projectService = ProjectService()
    let awsService = AWSService()
    let addressService = AddressService()
    let type = BehaviorRelay<[String]>(value: [])
    let status = BehaviorRelay<[String]>(value: [])
    let selectedImage = BehaviorRelay<[UIImage]>(value: [])
    let imagesName = BehaviorRelay<[String]>(value: [])
    let province = BehaviorRelay<[(id: String, name: String)]>(value: [])
    let district = BehaviorRelay<[(id: String, name: String)]>(value: [])
    let ward = BehaviorRelay<[(id: String, name: String)]>(value: [])
    var selectedProvince = -1
    var selectedDistrict = -1
    var selectedWard = -1
    var selectedType = -1
    var selectedStatus = -1
    var isEditBtnClicked = false
    var imageSelected = UIImage()
    var imagesList = [UIImage]()
    var imagesNameList = [String]()
    var searchProjectParams = [String: Any]()
    var isEdit = false
    var post: PostDetail?
    var projectDetail: Project?
    var updatePostParams = [String: Any]()
    var newProjectParams = [String: Any]()

    func setupDataImageCollectionView() {
        selectedImage.accept(imagesList)
    }
    
    func getAllProvinces() -> Observable<[Province]> {
        return addressService.getAllProvinces()
    }
    
    func getDistrictsByProvinceId() -> Observable<[District]> {
        return addressService.getDistrictsByProvinceId(provinceId: province.value[selectedProvince].id)
    }
    
    func getWardsByDistrictId() -> Observable<[Ward]> {
        return addressService.getWardsByDistrictId(districtId: district.value[selectedDistrict].id)
    }
    
    func pickItem(pickerTag: Int) -> String? {
        switch pickerTag{
        case PickerTag.type:
            if type.value.count > 0 && selectedType >= 0 {
                return type.value[selectedType]
            } else if selectedType == -1 {
                selectedType = 0
                return type.value[0]
            } else {
                return ""
            }
        case PickerTag.province:
            if province.value.count > 0 && selectedProvince >= 0 {
                return province.value[selectedProvince].name
            } else if selectedProvince == -1 {
                selectedProvince = 0
                return province.value[0].name
            } else {
                return ""
            }
        case PickerTag.district:
            if district.value.count > 0 && selectedDistrict >= 0 {
                return district.value[selectedDistrict].name
            } else if selectedDistrict == -1 && district.value.count > 0 {
                selectedDistrict = 0
                return district.value[0].name
            } else {
                return ""
            }
        case PickerTag.ward:
            if ward.value.count > 0 && selectedWard >= 0 {
                return ward.value[selectedWard].name
            } else if selectedWard == -1 && ward.value.count > 0 {
                selectedWard = 0
                return ward.value[0].name
            } else {
                return ""
            }
        case PickerTag.status:
            if status.value.count > 0 && selectedStatus >= 0 {
                return status.value[selectedStatus]
            } else if selectedStatus == -1 {
                selectedStatus = 0
                return status.value[0]
            } else {
                return ""
            }
        default:
            return ""
        }
    }
    
    func addNewProject(long: Double, lat: Double, name: String, description: String, acreage: String, minPrice: Double, maxPrice: Double, legal: String, building: Int, apartment: Int, investor: String) -> Observable<Project> {
        
        /// Required Field
        newProjectParams.updateValue(self.type.value[selectedType], forKey: "projectType")
        newProjectParams.updateValue(self.province.value[selectedProvince].name, forKey: "provinceName")
        newProjectParams.updateValue(self.province.value[selectedProvince].id, forKey: "provinceCode")
        newProjectParams.updateValue(self.district.value[selectedDistrict].name, forKey: "districtName")
        newProjectParams.updateValue(self.district.value[selectedDistrict].id, forKey: "districtCode")
        newProjectParams.updateValue(self.ward.value[selectedWard].name, forKey: "wardName")
        newProjectParams.updateValue(self.ward.value[selectedWard].id, forKey: "wardCode")
        newProjectParams.updateValue(lat, forKey: "lat")
        newProjectParams.updateValue(long, forKey: "long")
        newProjectParams.updateValue(name, forKey: "name")
        newProjectParams.updateValue(description, forKey: "description")
        newProjectParams.updateValue(acreage, forKey: "acreage")
        newProjectParams.updateValue("\(minPrice) - \(maxPrice) triệu/m2", forKey: "price")
        newProjectParams.updateValue(getPriceRange(price: minPrice), forKey: "priceRange")
        newProjectParams.updateValue(imagesNameList, forKey: "images")
        newProjectParams.updateValue(legal, forKey: "legal")
        newProjectParams.updateValue(building, forKey: "building")
        newProjectParams.updateValue(apartment, forKey: "apartment")
        newProjectParams.updateValue(investor, forKey: "investor")
        newProjectParams.updateValue(self.status.value[selectedStatus], forKey: "status")
       
        print("newProjectParams = \(newProjectParams)")
        
        return projectService.addProject(params: newProjectParams)
    }
    
    private func getPriceRange(price: Double) -> String {
        if price < 5 {
            return PickerData.projectPrice[1]
        } else if price < 10 {
            return PickerData.projectPrice[2]
        } else if price < 20 {
            return PickerData.projectPrice[3]
        } else if price < 35 {
            return PickerData.projectPrice[4]
        } else if price < 50 {
            return PickerData.projectPrice[5]
        } else if price < 80 {
            return PickerData.projectPrice[6]
        } else {
            return PickerData.projectPrice[7]
        }
    }
    
    func parseProvincesArray(provinces: [Province]) -> [(id: String, name: String)] {
        var provinceArray = [(id: String, name: String)]()
        for (_, element) in provinces.enumerated() {
            provinceArray.append((id: element.code, name: element.name))
        }
        let sortedProvince = provinceArray.sorted { $0.name < $1.name }
        return sortedProvince
    }
    
    func parseDistrictsArray(districts: [District]) -> [(id: String, name: String)] {
        var districtArray = [(id: String, name: String)]()
        for (_, element) in districts.enumerated() {
            districtArray.append((id: element.code, name: element.name))
        }
        let sortedDistrict = districtArray.sorted { $0.name < $1.name }
        return sortedDistrict
    }
    
    func parseWardsArray(wards: [Ward]) -> [(id: String, name: String)] {
        var wardArray = [(id: String, name: String)]()
        for (_, element) in wards.enumerated() {
            wardArray.append((id: element.code, name: element.name))
        }
        let sortedWard = wardArray.sorted { $0.name < $1.name }
        return sortedWard
    }
    
//    func checkUpdatePost(_ realEstateType: String,
//                         _ province: String,
//                         _ district: String,
//                         _ ward: String,
//                         _ address: String,
//                         _ project: String,
//                         _ lat: Double,
//                         _ long: Double,
//                         _ title: String,
//                         _ description: String,
//                         _ acreage: String,
//                         _ price: String,
//                         _ legal: String,
//                         _ funiture: String,
//                         _ bedroom: String,
//                         _ bathroom: String,
//                         _ floor: String,
//                         _ houseDirection: String,
//                         _ balconyDirection: String,
//                         _ wayIn: String,
//                         _ facade: String,
//                         _ contactName: String,
//                         _ contactNumber: String) -> Bool {
//        guard let post = self.post else { return false }
//        var isUpdated = false
//
//        /// Required Field
//        if isSelectedSell != post.isSell {
//            isUpdated = true
//            updatePostParams.updateValue(isSelectedSell, forKey: "isSell")
//        }
//
//        if realEstateType != post.realEstateType {
//            isUpdated = true
//            updatePostParams.updateValue(realEstateType, forKey: "realEstateType")
//        }
//
//        if province != post.provinceName {
//            isUpdated = true
//            updatePostParams.updateValue(self.province.value[selectedProvince].name, forKey: "provinceName")
//            updatePostParams.updateValue(self.province.value[selectedProvince].id, forKey: "provinceCode")
//        }
//
//        if district != post.districtName {
//            isUpdated = true
//            updatePostParams.updateValue(district, forKey: "districtName")
//            updatePostParams.updateValue(self.district.value[selectedDistrict].id, forKey: "districtCode")
//        }
//
//        if ward != post.wardName {
//            isUpdated = true
//            updatePostParams.updateValue(ward, forKey: "wardName")
//            updatePostParams.updateValue(self.ward.value[selectedWard].id, forKey: "wardCode")
//        }
//
//        if address != post.address {
//            isUpdated = true
//            updatePostParams.updateValue(address, forKey: "address")
//        }
//
//        if lat != post.lat {
//            isUpdated = true
//            updatePostParams.updateValue(lat, forKey: "lat")
//        }
//
//        if long != post.long {
//            isUpdated = true
//            updatePostParams.updateValue(long, forKey: "long")
//        }
//
//        if title != post.title {
//            isUpdated = true
//            updatePostParams.updateValue(title, forKey: "title")
//        }
//
//        if description != post.description {
//            isUpdated = true
//            updatePostParams.updateValue(description, forKey: "description")
//        }
//
//
//        if let parseAcreage = Double(acreage),
//           parseAcreage != post.acreage {
//            isUpdated = true
//            updatePostParams.updateValue(parseAcreage, forKey: "acreage")
//            updatePostParams.updateValue(getAcreageRange(acreage: parseAcreage), forKey: "acreageRange")
//        }
//
//        if let parsePrice = Int(price),
//           parsePrice != post.price {
//            isUpdated = true
//            updatePostParams.updateValue(parsePrice, forKey: "price")
//            updatePostParams.updateValue(getPriceRange(price: parsePrice), forKey: "priceRange")
//        }
//
//        if legal != post.legal {
//            isUpdated = true
//            updatePostParams.updateValue(self.legal.value[selectedLegal], forKey: "legal")
//        }
//
//        if contactName != post.contactName {
//            isUpdated = true
//            updatePostParams.updateValue(contactName, forKey: "contactName")
//        }
//
//        if contactNumber != post.contactPhoneNumber {
//            isUpdated = true
//            updatePostParams.updateValue(contactNumber, forKey: "contactNumber")
//        }
//
//        if imagesNameList.sorted() != post.images.sorted() {
//            isUpdated = true
//            updatePostParams.updateValue(imagesNameList, forKey: "images")
//        }
//
//        /// Non required Field
//        if selectedProject > -1 {
//            isUpdated = true
//            updatePostParams.updateValue(self.project.value[selectedProject].name, forKey: "projectName")
//            updatePostParams.updateValue(self.project.value[selectedProject].id, forKey: "project")
//        }
//
//        if selectedFuniture > -1 {
//            isUpdated = true
//            updatePostParams.updateValue(self.funiture.value[selectedFuniture], forKey: "funiture")
//        }
//
//        if let bedroom = Int(bedroom) {
//            if let postBedroom = post.bedroom {
//                if bedroom != postBedroom {
//                    isUpdated = true
//                    updatePostParams.updateValue(bedroom, forKey: "bedroom")
//                    updatePostParams.updateValue(getBedroomRange(bedroom: bedroom), forKey: "bedroomRange")
//                }
//            } else if bedroom > 0 {
//                isUpdated = true
//                updatePostParams.updateValue(bedroom, forKey: "bedroom")
//                updatePostParams.updateValue(getBedroomRange(bedroom: bedroom), forKey: "bedroomRange")
//            }
//        }
//
//        if let bathroom = Int(bathroom) {
//            if let postBathroom = post.bathroom {
//                if bathroom != postBathroom {
//                    isUpdated = true
//                    updatePostParams.updateValue(bathroom, forKey: "bathroom")
//                }
//            } else if bathroom > 0 {
//                isUpdated = true
//                updatePostParams.updateValue(bathroom, forKey: "bathroom")
//            }
//        }
//
//        if let floor = Int(floor) {
//            if let postFloor = post.floor {
//                if floor != postFloor {
//                    isUpdated = true
//                    updatePostParams.updateValue(floor, forKey: "floor")
//                }
//            } else if floor > 0 {
//                isUpdated = true
//                updatePostParams.updateValue(floor, forKey: "floor")
//            }
//        }
//
//        if selectedHouseDirection > -1 {
//            isUpdated = true
//            updatePostParams.updateValue(self.houseDirection.value[selectedHouseDirection], forKey: "houseDirection")
//        }
//
//        if selectedBalconyDirection > -1 {
//            isUpdated = true
//            updatePostParams.updateValue(self.balconyDirection.value[selectedBalconyDirection], forKey: "balconyDirection")
//        }
//
//        if let postWayIn = post.wayIn,
//           let parseWayIn = Double(wayIn),
//           parseWayIn != postWayIn {
//            isUpdated = true
//            updatePostParams.updateValue(parseWayIn, forKey: "wayIn")
//        }
//
//        if let postFacade = post.facade,
//           let parseFacade = Double(facade),
//           parseFacade != postFacade {
//            isUpdated = true
//            updatePostParams.updateValue(parseFacade, forKey: "facade")
//        }
//        return isUpdated
//    }
    
//    func updatePost() -> Observable<Post> {
//        return postService.updatePost(postId: post?.id ?? "", param: updatePostParams)
//    }
    
    func uploadImages(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for (index, element) in imagesList.enumerated() {
            guard let data = element.pngData() else { continue }
            
            let assetDataModel = AssetDataModel(data: data, pathFile: "", thumbnail: element)
            assetDataModel.compressed = true
            assetDataModel.compressData()
            assetDataModel.remoteName = imagesNameList[index]
            
            dispatchGroup.enter()
            awsService.uploadImage(data: assetDataModel, completionHandler: { [weak self] _, error in
                guard self != nil else { return }
                if error != nil {
                    print("---------------- Lỗi upload lên AWS S3 : \(String(describing: error))----------------")
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion()
        }
    }

}
