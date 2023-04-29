//
//  BaseService.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay

class BaseService: NSObject {
    var baseHeader = HTTPHeaders()
    override init() {
        baseHeader.add(HTTPHeader(name: "token", value: "Bearer " + (UserDefaults.token ?? "")))
    }
    
    func authRequest<Params: Codable, Response: Codable>(api: APIConstants, method: HTTPMethod, parameters: Params, headers: [String: String]? = nil) -> Observable<Response> {
        let url = Base.URL + api.rawValue
        if headers != nil {
            for header in headers! {
                baseHeader.add(name: header.key, value: header.value)
            }
        }
        let request = AF.request(url, method: method, parameters: parameters, encoder: .json, headers: self.baseHeader)
        return performRequest(request)
    }
    
    func authRequest<Response: Codable>(api: APIConstants, method: HTTPMethod, headers: [String: String]? = nil) -> Observable<Response> {
        let url = Base.URL + api.rawValue
        if headers != nil {
            for header in headers! {
                baseHeader.add(name: header.key, value: header.value)
            }
        }
        let request = AF.request(url, method: method, headers: self.baseHeader)
        return performRequest(request)
    }
    
    func request<Params: Codable, Response: Codable>(api: APIConstants, headers: [String: String] = [:], params: Params) -> Observable<Response> {
        let url = Base.URL + api.rawValue
        headers.forEach {
            baseHeader.add(name: $0.key, value: $0.value)
        }
        
        guard let methodSupport = HTTPMethod.convert(api.method) else {
            return Observable.create { response in
                Disposables.create {
                    return print("Error: Invalid method")
                }
            }
        }
        
        if methodSupport == .get {
            return performRequest(AF.request(url, method: methodSupport, parameters: params, encoder: URLEncodedFormParameterEncoder.default, headers:  self.baseHeader))
        } else {
            return performRequest(AF.request(url, method: methodSupport, parameters: params, encoder: .json, headers: self.baseHeader))
        }
    }
    
    func request<Response: Codable>(api: APIConstants, headers: [String: String] = [:], params: Parameters? = nil) -> Observable<Response> {
        let url = Base.URL + api.rawValue
        headers.forEach {
            baseHeader.add(name: $0.key, value: $0.value)
        }
        guard let methodSupport = HTTPMethod.convert(api.method) else {
            return Observable.create { response in
                Disposables.create {
                    return print("Error: Invalid method")
                }
            }
        }
        
        if methodSupport == .get {
            return performRequest(AF.request(url, method: methodSupport, encoding: URLEncoding.default, headers: self.baseHeader))
        } else {
            return performRequest(AF.request(url, method: methodSupport, parameters: params, encoding: JSONEncoding.default, headers: self.baseHeader))
        }
    }
    
    func request<Params: Encodable, Response: Codable>(api: String, method: HTTPMethodSupport, headers: [String: String] = [:], params: Params) -> Observable<Response> {
        let url = Base.URL + api
        headers.forEach { baseHeader.add(name: $0.key, value: $0.value) }
        guard let methodSupport = HTTPMethod.convert(method) else {
            return Observable.create { response in
                Disposables.create {
                    return print("Error: Invalid method")
                }
            }
        }
        return performRequest(AF.request(url, method: methodSupport, parameters: params, encoder: .json, headers: self.baseHeader))
    }
    
    func request<Response: Codable>(api: String, method: HTTPMethodSupport, headers: [String: String] = [:], params: Parameters? = nil) -> Observable<Response> {
        let url = Base.URL + api
        headers.forEach { baseHeader.add(name: $0.key, value: $0.value) }
        guard let methodSupport = HTTPMethod.convert(method) else {
            return Observable.create { response in
                Disposables.create {
                    return print("Error: Invalid method")
                }
            }
        }
        return performRequest(AF.request(url, method: methodSupport, parameters: params, encoding: JSONEncoding.default, headers: self.baseHeader))
    }
    
    private func performRequest<Response: Codable>(_ request: DataRequest) -> Observable<Response> {
        return Observable.create { observer in
            request.responseDecodable(of: ResponseMain<Response>.self) { response in
                var error: Error? = nil
                if response.error != nil {
                    error = ServiceError.network
                } else if let data = response.value {
                    switch data.status {
                    case StatusCode.OK:
                        if let payload = data.payload {
                            observer.onNext(payload)
                        }
                        observer.onCompleted()
                    default:
                        error = ServiceError.unknown(message: data.message)
                        observer.onError(error!)
                    }
                }
                if let er = error {
                    print("Error : \(er)")
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension HTTPMethod {
    static func convert(_ methodSupport: HTTPMethodSupport) -> Self? {
        if methodSupport == .post { return .post }
        else if methodSupport == .get { return .get }
        else if methodSupport == .put { return .put }
        else if methodSupport == .patch { return .patch}
        else { return nil }
    }
}
