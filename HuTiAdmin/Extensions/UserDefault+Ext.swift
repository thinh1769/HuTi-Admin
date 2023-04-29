//
//  UserDefault+Ext.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation

extension UserDefaults {
    private enum Key : String {
        case userInfo = "UserInfo"
        case token = "Token"
    }
    
    private static let defs = UserDefaults.standard
    
    static var userInfo: User? {
        get {
            let data = defs.object(forKey: Key.userInfo.rawValue) as? Data
            guard data != nil else { return nil }
            let info = try? JSONDecoder().decode(User.self, from: data!)
            return info
        }

        set {
            guard let value = newValue else {
                defs.removeObject(forKey: Key.userInfo.rawValue)
                return
            }

            let data = try? JSONEncoder().encode(value)
            if data != nil {
                defs.set(data, forKey: Key.userInfo.rawValue)
            }
        }
    }
    
    static var token: String? {
        get {
            return defs.string(forKey: Key.token.rawValue)
        }

        set {
            guard let value = newValue else {
                defs.removeObject(forKey: Key.token.rawValue)
                return
            }
            defs.set(value, forKey: Key.token.rawValue)
        }
    }
}

extension String {
    func getName() -> String {
        let components = self.components(separatedBy: " ")
        if components.count > 0 {
//            let firstName = components.removeFirst()
            let lastName = components.joined(separator: " ")
            return lastName
        } else {
            return ""
        }
    }
}

