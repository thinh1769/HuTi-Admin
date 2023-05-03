//
//  ProjectDetailViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 03/05/2023.
//

import Foundation
import RxSwift
import RxRelay

class ProjectDetailViewModel {
    let bag = DisposeBag()
    let projectService = ProjectService()
    var project : Project?
    let images = BehaviorRelay<[String]>(value: [])
    var projectId = ""
    var page = 1
    
    func getProjectById() -> Observable<Project> {
        return projectService.getProjectById(projectId: projectId)
    }
}
