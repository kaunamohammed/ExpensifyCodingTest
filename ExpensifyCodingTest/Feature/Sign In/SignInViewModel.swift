//
//  SignInViewModel.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 07/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public struct SignInViewModel {
  
  public enum SignInState {
    case signingIn
    case signedIn
    case failed(title: String?, reason: String?)
  }
  
  public var signInStateChanged: ((SignInState) -> Void)?
  
  private let router: NetworkRouter
  public init(router: NetworkRouter) {
    self.router = router
  }
  
  public func attemptSignIn(with credentials: Credentials) {
    signInStateChanged?(.signingIn)
    // I prefer to capture objects directly rather than doing the weak/unowned self dance
    router.request(EndPoint.authenticateUser(partnerUserID: credentials.id,
                                             partnerUserSecret: credentials.password),
                   completion: { [handle] result in handle(result) })
  }
  
  private func handle(result: Result<Data, Error>) {
    assert(Thread.isMainThread, "Get on the main thread dude")
    switch result {
    case .success(let data):
      do {
        // here i'm taking advantage of the decoded() extension on `Data`
        let apiResponse: APIResponse = try data.decoded()
        switch apiResponse.jsonCode {
        case 200...299:
          try AuthController.saveUserToKeychain(User(email: apiResponse.email.orEmpty), token: apiResponse.authToken.orEmpty)
          signInStateChanged?(.signedIn)
        case 401...500:
          signInStateChanged?(.failed(title: nil, reason: "Please check your email or password and try again"))
        case 501...599:
          signInStateChanged?(.failed(title: nil, reason: "An internal error has occured. Please try again"))
        default:
          signInStateChanged?(.failed(title: nil, reason: "An unknown problem occured. Please try again"))
        }
      } catch let error {
        signInStateChanged?(.failed(title: nil, reason: error.localizedDescription))
      }
      
    case .failure(let error):
      signInStateChanged?(.failed(title: nil, reason: error.localizedDescription))
    }
  }
  
}
