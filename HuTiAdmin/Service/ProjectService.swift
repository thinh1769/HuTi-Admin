//
//  ProjectService.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation
import RxSwift
import RxRelay

class ProjectService: BaseService {
    func getListProjects(page: Int) -> Observable<[Project]> {
        return request(api: "\(APIConstants.getProject.rawValue)?page=\(page)", method: .get)
    }
    
    func getProjectById(projectId: String) -> Observable<Project> {
        return request(api: APIConstants.getProjectById.rawValue + projectId, method: .get)
    }
    
    func findProject(params: [String: Any], page: Int?) -> Observable<[Project]> {
        if let page = page {
            return request(api: "\(APIConstants.findProject.rawValue)?page=\(page)", method: .post, params: params)
        } else {
            return request(api: APIConstants.findProject.rawValue, method: .post, params: params)
        }
    }
    
    func addProject(params: [String: Any]) -> Observable<Project> {
        return request(api: APIConstants.getProject.rawValue, method: .post, params: params)
    }
    
    func updateProject(projectId: String, param: [String: Any]) -> Observable<Project> {
        return request(api: APIConstants.updateProject.rawValue + projectId, method: .put, params: param)
    }
    
    func deleteProject(projectId: String) -> Observable<String> {
        return request(api: APIConstants.updateProject.rawValue + projectId, method: .delete)
    }
}
