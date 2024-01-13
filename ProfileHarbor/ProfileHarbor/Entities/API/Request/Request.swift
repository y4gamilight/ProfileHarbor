//
//  Request.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 12/01/2024.
//

import Foundation
import Combine

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol Request {
    associatedtype Reps: Response
    var path: String { get }
    var method: HTTPMethod { get }
    var body: [String: Any]? { get }
    var queryParam: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension Request {
    
    private var queryPathString: String? {
        get {
            guard let queryParam = self.queryParam, queryParam.count > 0 else { return nil }
            var strings = [String]()
            for (key, value) in queryParam {
                strings.append("\(key)=\(value)")
            }
            let combineString = strings.joined(separator: "&")
            return combineString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
    }
    
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
          guard let params = params else { return nil }
          guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
              return nil
          }
          return httpBody
      }
      /// Transforms a Request into a standard URL request
      /// - Parameter baseURL: API Base URL to be used
      /// - Returns: A ready to use URLRequest
    func asURLRequest(baseURL: String, headerDefault: [String: String]) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        urlComponents.query = self.queryPathString
        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        request.allHTTPHeaderFields = headerDefault
        if let headers = self.headers {
            request.allHTTPHeaderFields = headers
        }
        return request
    }
}
