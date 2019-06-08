//
//  Router.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public final class Router: NetworkRouter {
  
  private var task: URLSessionTask?
  
  public func request(_ route: URLProducer, completion: @escaping NetworkCompletion) {
    let session = URLSession.shared
    guard let request = buildRequest(from: route) else { return }

    task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      DispatchQueue.main.async {
        guard error == nil else { completion(.failure(.requestFailure)); return }

        if let httpResponse = response as? HTTPURLResponse {
          switch httpResponse.statusCode {
          case 200: completion(.success(data!))
          case 400: completion(.failure(.unrecognizedCommand))
          case 402: completion(.failure(.missingArgument))
          case 407: completion(.failure(.malformedOrExpiredToken))
          case 408: completion(.failure(.accountDeleted))
          case 411: completion(.failure(.insufficientPrivelages))
          case 500: completion(.failure(.aborted))
          case 501: completion(.failure(.dbTransactionError))
          case 502: completion(.failure(.queryError))
          case 503: completion(.failure(.QueryResponseError))
          case 504: completion(.failure(.unrecognizedObjectState))
          default: completion(.failure(.unknown))
          }
        }
      }
      
    })
    task?.resume()
  }
  
  public func cancel() {
    task?.cancel()
  }
  
  private func buildRequest(from route: URLProducer) -> URLRequest? {
    guard let url = route.url else { return nil }
    var request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("accept", forHTTPHeaderField: "application/json")
    return request
  }
}
