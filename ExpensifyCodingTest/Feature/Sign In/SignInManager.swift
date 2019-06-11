//
//  SignInManager.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 11/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public class SignInManager {
  
  private let router: NetworkRouter
  
  public init(router: NetworkRouter) {
    self.router = router
  }
  
  public func attemptSignIn(with credentials: Credentials, completion: @escaping (Result<Data, Error>) -> Void) {
    
    router.request(EndPoint.authenticateUser(partnerUserID: credentials.id,
                                             partnerUserSecret: credentials.password),
                   completion: { result in
                    switch result {
                    case .success(let data):
                      completion(.success(data))
                    case .failure(let error):
                      completion(.failure(error))
                    }
    })
    
  }
  
}


