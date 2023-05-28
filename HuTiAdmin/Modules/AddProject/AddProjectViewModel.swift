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
    var project: Project?
    var projectDetail: Project?
    var updateProjectParams = [String: Any]()
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
        newProjectParams.updateValue(minPrice, forKey: "minPrice")
        newProjectParams.updateValue(maxPrice, forKey: "maxPrice")
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
            provinceArray.append((id: element.idProvince, name: element.name))
        }
        let sortedProvince = provinceArray.sorted { $0.name < $1.name }
        return sortedProvince
    }
    
    func parseDistrictsArray(districts: [District]) -> [(id: String, name: String)] {
        var districtArray = [(id: String, name: String)]()
        for (_, element) in districts.enumerated() {
            districtArray.append((id: element.idDistrict, name: element.name))
        }
        let sortedDistrict = districtArray.sorted { $0.name < $1.name }
        return sortedDistrict
    }
    
    func parseWardsArray(wards: [Ward]) -> [(id: String, name: String)] {
        var wardArray = [(id: String, name: String)]()
        for (_, element) in wards.enumerated() {
            wardArray.append((id: element.idWard, name: element.name))
        }
        let sortedWard = wardArray.sorted { $0.name < $1.name }
        return sortedWard
    }
    
    func checkUpdateProject(_ type: String,
                            _ province: String,
                            _ district: String,
                            _ ward: String,
                            _ lat: Double,
                            _ long: Double,
                            _ name: String,
                            _ description: String,
                            _ acreage: String,
                            _ minPrice: String,
                            _ maxPrice: String,
                            _ legal: String,
                            _ status: String,
                            _ building: String,
                            _ apartment: String,
                            _ invertor: String) -> Bool {
        guard let project = self.project else { return false }
        var isUpdated = false

        /// Required Field
        if type != project.projectType {
            isUpdated = true
            updateProjectParams.updateValue(type, forKey: "projectType")
        }

        if province != project.provinceName {
            isUpdated = true
            updateProjectParams.updateValue(self.province.value[selectedProvince].name, forKey: "provinceName")
            updateProjectParams.updateValue(self.province.value[selectedProvince].id, forKey: "provinceCode")
        }

        if district != project.districtName {
            isUpdated = true
            updateProjectParams.updateValue(district, forKey: "districtName")
            updateProjectParams.updateValue(self.district.value[selectedDistrict].id, forKey: "districtCode")
        }

        if ward != project.wardName {
            isUpdated = true
            updateProjectParams.updateValue(ward, forKey: "wardName")
            updateProjectParams.updateValue(self.ward.value[selectedWard].id, forKey: "wardCode")
        }

        if lat != project.lat {
            isUpdated = true
            updateProjectParams.updateValue(lat, forKey: "lat")
        }

        if long != project.long {
            isUpdated = true
            updateProjectParams.updateValue(long, forKey: "long")
        }

        if name != project.name {
            isUpdated = true
            updateProjectParams.updateValue(name, forKey: "name")
        }

        if description != project.description {
            isUpdated = true
            updateProjectParams.updateValue(description, forKey: "description")
        }

        if acreage != project.acreage {
            isUpdated = true
            updateProjectParams.updateValue(acreage, forKey: "acreage")
        }

        if let parseMinPrice = Double(minPrice),
           parseMinPrice != project.minPrice {
            isUpdated = true
            updateProjectParams.updateValue(parseMinPrice, forKey: "minPrice")
            updateProjectParams.updateValue(getPriceRange(price: parseMinPrice), forKey: "priceRange")
        }
        
        if let parseMaxPrice = Double(maxPrice),
           parseMaxPrice != project.maxPrice {
            isUpdated = true
            updateProjectParams.updateValue(parseMaxPrice, forKey: "maxPrice")
        }

        if legal != project.legal {
            isUpdated = true
            updateProjectParams.updateValue(legal, forKey: "legal")
        }
        
        if status != project.status {
            isUpdated = true
            updateProjectParams.updateValue(status, forKey: "status")
        }

        if imagesNameList.sorted() != project.images.sorted() {
            isUpdated = true
            updateProjectParams.updateValue(imagesNameList, forKey: "images")
        }

        if let parseBuilding = Int(building),
           parseBuilding != project.building {
            isUpdated = true
            updateProjectParams.updateValue(parseBuilding, forKey: "building")
        }
        
        if let parseApartment = Int(apartment),
           parseApartment != project.apartment {
            isUpdated = true
            updateProjectParams.updateValue(parseApartment, forKey: "apartment")
        }
        
        if invertor != project.investor {
            isUpdated = true
            updateProjectParams.updateValue(invertor, forKey: "investor")
        }
        
        return isUpdated
    }
    
    func updateProject() -> Observable<Project> {
        return projectService.updateProject(projectId: project?.id ?? "", param: updateProjectParams)
    }
    
    func deleteProject() -> Observable<String> {
        return projectService.deleteProject(projectId: project?.id ?? "")
    }
    
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
