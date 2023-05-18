//
//  HuTiConstants.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation

struct CommonConstants {
    static let tableRowHeight = 130.0
    static let phoneNumber = "Số điện thoại"
    static let password = "Mật khẩu"
    static let confirmPassword = "Xác nhận mật khẩu"
    static let done = "Xong"
    static let cancel = "Thoát"
    static let edit = "Sửa"
    static let updateInfo = "Vui lòng cập nhật thông tin tài khoản!"
    static let DATE_FORMAT = "dd/MM/yyyy"
    static let dateFormatAWSS3 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let networkError = "Lỗi kết nối mạng"
    static let firstSubtitle = "Hiện tại có"
    static let realEstate = "nhà đất"
    static let sell = "đang bán"
    static let forRent = "đang cho thuê"
    static let project = "dự án"
    static let pageSize = 5
}

struct TextFieldPlaceHolder {
    static let typeRealEstate = "Loại nhà đất"
    static let typeProject = "Loại dự án"
    static let city = "Tỉnh, thành phố"
    static let district = "Quận, huyện"
    static let ward = "Phường, xã"
    static let street = "Đường phố"
    static let price = "Mức giá"
    static let acreage = "Diện tích"
    static let legal = "Giấy tờ pháp lý"
    static let funiture = "Nội thất"
    static let houseDirection = "Hướng nhà"
    static let balconyDirection = "Hướng ban công"
}

struct PickerTag {
    static let type = 0
    static let province = 1
    static let district = 2
    static let ward = 3
    static let project = 4
    static let price = 5
    static let acreage = 6
    static let legal = 7
    static let funiture = 8
    static let houseDirection = 9
    static let balconyDirection = 10
    static let bedroom = 11
    static let status = 12
    static let gender = 13
    static let dob = 14
}

struct ImageName {
    static let house = "house"
    static let project = "project"
    static let user = "user"
    static let list = "list"
    static let map = "map"
    static let backButton = "chevron.left"
    static let circle = "circle"
    static let checkmarkFill = "checkmark.circle.fill"
    static let save = "save"
    static let edit = "edit"
 }

struct ColorName {
    static let background = "background"
    static let themeText = "themeText"
    static let otpBackground = "otpBackground"
    static let gray = "gray"
    static let white = "white"
    static let black = "black"
    static let redStatusBackground = "redStatusBackground"
    static let greenStatusBackground = "greenStatusBackground"
    static let purpleStatusBackground = "purpleStatusBackground"
    static let redStatusText = "redStatusText"
    static let greenStatusText = "greenStatusText"
    static let purpleStatusText = "purpleStatusText"
    static let darkBackground = "darkBackground"
}

struct TabBarItemTitle {
    static let sell = "Bán"
    static let forRent = "Cho thuê"
    static let project = "Dự án"
    static let account = "Tài khoản"
}
    
struct ClassNibName {
    static let FilterResultViewController = "FilterResultViewController"
    static let FilterViewController = "FilterViewController"
    static let PostedViewController = "PostedViewController"
    static let OTPViewController = "OTPViewController"
    static let ConfirmPasswordViewController = "ConfirmPasswordViewController"
    static let PostDetailViewController = "PostDetailViewController"
    static let ProjectDetailViewController = "ProjectDetailViewController"
    static let SignUpViewController = "SignUpViewController"
    static let NewPostViewController = "NewPostViewController"
    static let HomeViewController = "HomeViewController"
    static let AddProjectViewController = "AddProjectViewController"
    static let UserDetailViewController = "UserDetailViewController"
    static let ReportDetailViewController = "ReportDetailViewController"
}

struct MainTitle {
    static let sell = "Nhà đất bán"
    static let forRent = "Nhà đất cho thuê"
    static let project = "Dự án"
    static let postedPosts = "Các tin đã đăng"
    static let favoritePosts = "Tin đăng yêu thích"
}

struct RealEstateType {
    static let newPostSell = [Self.apartment, Self.home, Self.villa, Self.streetHouse, Self.shopHouse, Self.projectLand, Self.land, Self.farmResort, Self.codontel, Self.wareHouseFactory, Self.otherRealEstate]
    static let sell = [Self.all, Self.apartment, Self.home, Self.villa, Self.streetHouse, Self.shopHouse, Self.projectLand, Self.land, Self.farmResort, Self.codontel, Self.wareHouseFactory, Self.otherRealEstate]
    static let newPostForRent = [Self.apartment, Self.home, Self.villa, Self.streetHouse, Self.shopHouse, Self.motel, Self.office, Self.shopKiosk, Self.wareHouseFactory, Self.land, Self.otherRealEstate]
    static let forRent = [Self.all, Self.apartment, Self.home, Self.villa, Self.streetHouse, Self.shopHouse, Self.motel, Self.office, Self.shopKiosk, Self.wareHouseFactory, Self.land, Self.otherRealEstate]
    
    static let project = ["Tất cả dự án", Self.apartment, "Cao ốc văn phòng", "Trung tâm thương mại", "Khu đô thị mới", "Khu phức hợp", "Nhà ở xã hội", "Khu nghỉ dưỡng, Sinh thái", "Khu công nghiệp", "Biệt thự liền kề", "Shophouse", Self.streetHouse, "Dự án khác"]
    
    static let addProject = [Self.apartment, "Cao ốc văn phòng", "Trung tâm thương mại", "Khu đô thị mới", "Khu phức hợp", "Nhà ở xã hội", "Khu nghỉ dưỡng, Sinh thái", "Khu công nghiệp", "Biệt thự liền kề", "Shophouse", Self.streetHouse, "Dự án khác"]
    
    static let all = "Tất cả nhà đất"
    static let apartment = "Căn hộ chung cư"
    static let home = "Nhà riêng"
    static let villa = "Nhà biệt thự, liền kề"
    static let streetHouse = "Nhà mặt phố"
    static let shopHouse = "Nhà phố thương mại"
    static let projectLand = "Đất nền dự án"
    static let land = "Đất"
    static let farmResort = "Trang trại, khu nghỉ dưỡng"
    static let codontel = "Codontel"
    static let motel = "Nhà trọ, phòng trọ"
    static let office = "Văn phòng"
    static let shopKiosk = "Cửa hàng, kiot"
    static let wareHouseFactory = "Kho, nhà xưởng"
    static let otherRealEstate = "Bất động sản khác"
}

struct PickerData {
    static let price = ["Tất cả mức giá", "Dưới 500 triệu", "500 - 800 triệu", "800 triệu - 1 tỷ", "1 - 2 tỷ", "2 - 3 tỷ", "3 - 5 tỷ", "5 - 7 tỷ", "7 - 10 tỷ", "10 - 20 tỷ", "20 - 30 tỷ", "30 - 40 tỷ", "40 - 60 tỷ", "Trên 60 tỷ"]
    static let acreage = ["Tất cả diện tích", "Dưới 30 m²", "30 - 50 m²", "50 - 80 m²", "80 - 100 m²", "100 - 150 m²", "150 - 200 m²", "200 - 250 m²", "250 - 300 m²", "300 - 500 m²", "Trên 500 m²"]
    static let bedroom = ["1 phòng ngủ", "2 phòng ngủ", "3 phòng ngủ", "4 phòng ngủ", "Từ 5 phòng ngủ trở lên"]
    static let direction = ["Đông", "Tây", "Nam", "Bắc", "Đông - Bắc", "Tây - Bắc", "Tây - Nam", "Đông - Nam"]
    static let status = ["Sắp mở bán", "Đang mở bán", "Đã bàn giao"]
    static let legal = ["Sổ đỏ/ Sổ hồng", "Hợp đồng mua bán", "Đang chờ sổ"]
    static let funiture = ["Đầy đủ", "Cơ bản", "Không nội thất"]
    static let gender = ["Nam", "Nữ", "Khác"]
    static let day = ["01", "02", "03"]
    static let projectPrice = ["Tất cả mức giá", "Dưới 5 triệu/m2", "5 - 10 triệu/m2", "10 - 20 triệu/m2", "20 - 35 triệu/m2", "35 - 50 triệu/m2", "50 - 80 triệu/m2", "Trên 80 triệu/m2"]
}

enum SubviewTag: Int {
    case otherView
    case detailView
}

struct RegexConstants {
    static let PHONE_NUMBER = "^0\\d{9}$"
    static let PASSWORD = "^\\S{5,20}$"
    static let DOUBLE = #"^\d+(\.\d+)?$"#
    //static let NUMBER = "^\\d{1,}$"
}

struct Alert {
    static let numberOfPhoneNumber = "Số điện thoại phải có 10 chữ số"
    static let numberOfPass = "Mật khẩu phải có ít nhất 5 ký tự"
    static let ok = "OK"
    static let wrongSignInInfo = "Thông tin đăng nhập không đúng"
    static let registedPhoneNumber = "Số điện thoại đã được đăng ký"
    static let nonRegistedPhoneNumber = "Số điện thoại chưa được đăng ký"
    static let wrongOTP = "OTP không đúng"
    static let notTheSamePass = "Mật khẩu và xác nhận mật khẩu không giống nhau"
    static let phoneBeginByZero = "Số điện thoại phải bắt đầu bằng số 0"
    static let pleaseUpdateAccountInfo = "Vui lòng cập nhật thông tin tài khoản"
    static let updatedAccountSuccessfully = "Cập nhật tài khoản thành công"
    static let postSuccessfully = "Đăng tin thành công"
    static let pleaseChooseTypeProvince = "Vui lòng chọn loại và tỉnh thành"
}
