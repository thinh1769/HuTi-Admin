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
    var findProjectParams = [String: Any]()
    var page = 1
    
    func findProject(param: [String: Any]) -> Observable<[Project]> {
        return projectService.findProject(params: param, page: page)
    }
}
