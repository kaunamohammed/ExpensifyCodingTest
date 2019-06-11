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
    case failed(title: String?, message: String?)
  }
  
  public var authStateChanged: ((SignInState) -> Void)?
  
  private let manager: SignInManager
  public init(manager: SignInManager) {
    self.manager = manager
  }
  
  /// attempts to sign in the user
  public func attemptSignIn(with credentials: Credentials) {
    authStateChanged?(.signingIn)
    manager.attemptSignIn(with: credentials, completion: { result in self.handle(result: result) })
  }
  
}

private extension SignInViewModel {
  
  /**

   handles the result received from the request
   
   - parameter result:S=a result type
   
   */
  
  func handle(result: Result<Data, Error>) {
    assert(Thread.isMainThread, GlobalConstants.ErrorMessage.notOnMainThread)
    switch result {
    case .success(let data):
      do {
        let apiResponse: APIResponse = try data.decoded()
        switch apiResponse.jsonCode {
        case 200...299:
          guard let email = apiResponse.email else { return }
          guard let authToken = apiResponse.authToken else { return }
          try AuthController.saveUserToKeychain(User(email: email), token: authToken)
          authStateChanged?(.signedIn)
        case 401...500:
          authStateChanged?(.failed(title: nil, message: GlobalConstants.ErrorMessage.invalidCredentials))
        default:
          authStateChanged?(.failed(title: nil, message: GlobalConstants.ErrorMessage.errorFulfillingRequest))
        }
      } catch _ {
        authStateChanged?(.failed(title: nil, message: GlobalConstants.ErrorMessage.internalError))
      }
    case .failure(let error):
      authStateChanged?(.failed(title: nil, message: error.localizedDescription))
    }
  }
}
