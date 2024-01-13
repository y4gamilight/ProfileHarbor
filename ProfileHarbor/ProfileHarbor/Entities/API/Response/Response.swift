//
//  Response.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 12/01/2024.
//

import Foundation

public protocol Response: Codable {
}

public class ListResponse<Element: Response> {
    var items: [Element] = []
    
    init(from jsonData: Data) {
        do {
            let decoder = JSONDecoder()
            items = try decoder.decode([Element].self, from: jsonData)
        } catch ( let error) {
            debugPrint(error.localizedDescription)
            items = []
        }
    }
}
