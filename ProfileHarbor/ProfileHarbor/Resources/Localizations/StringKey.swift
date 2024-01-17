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
    static var textNoData: String { return localized("text_no_data") }
    static var textLoading: String { return localized("text_loading") }
    static var msgErrorInvalidURL: String { return localized("msg_error_invalid_url")}
    static var msgErrorUserInvalid: String { return localized("msg_error_user_invalid")}
    static var msgErrorServerTrouble: String { return localized("msg_error_server_trouble")}
    static var msgErrorInternetOffline: String { return localized("msg_error_internet_offline")}
    static var msgErrorTooManyRequest: String { return localized("msg_error_too_many_request")}
    static var textRefresh: String { return localized("text_refresh") }
    
    static func textNumUsers(_ nums: Int) -> String {
        return "\(localized("text_users")) \(nums)"
    }
}

extension StringKey {
    static func localized(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
}
