//
//  ProjectViewController.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 01/05/2023.
//

import UIKit

class ProjectViewController: HuTiViewController {

    @IBOutlet weak var projectTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func didTapAddProjectButton(_ sender: UIButton) {
        let vc = AddProjectViewController()
        navigateTo(vc)
    }
    
}
