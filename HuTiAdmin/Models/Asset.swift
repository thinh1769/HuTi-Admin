//
//  Asset.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import UIKit

protocol Asset {
    var pathFile: String? { get set }
    var thumbnail: UIImage { get set }
    var url: String? { get set }
}
