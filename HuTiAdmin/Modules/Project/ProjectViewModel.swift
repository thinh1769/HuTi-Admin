//
//  ProjectViewModel.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 01/05/2023.
//

import Foundation
import RxSwift
import RxRelay

class ProjectViewModel {
    let bag = DisposeBag()
    let projectService = ProjectService()
    let project = BehaviorRelay<[Project]>(value: [])
    var page = 1
    
    func getProject() -> Observable<[Project]> {
        return projectService.getListProjects(page: page)
    }
}
