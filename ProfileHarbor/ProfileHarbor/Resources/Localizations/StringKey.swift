//
//  StringKey.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 12/01/2024.
//

import Foundation

struct StringKey {
    static var appName: String { return localized("app_name") }
    static var textOk: String { return localized("text_ok") }
    static var textCancel: String { return localized("text_cancel") }
    static var msgErrorInvalidURL: String { return localized("msg_error_invalid_url")}
}

extension StringKey {
    static func localized(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
}
