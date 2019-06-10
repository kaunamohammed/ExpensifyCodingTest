/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

final class AuthController {
  
  static let serviceName = "ExpensifyService"
  
  static var isSignedIn: Bool {
    guard let currentUser = Settings.currentUser else { return false }
    
    do {
      let token = try KeychainPasswordItem(service: serviceName, account: currentUser.email).readPassword()
      return token.count > 0
    } catch {
      return false
    }
  }
  
  static var authToken: String {
    guard let currentUser = Settings.currentUser else { return "" }

    do {
      let token = try KeychainPasswordItem(service: serviceName, account: currentUser.email).readPassword()
      return token
    } catch {
      return ""
    }
  }

  class func saveUserToKeychain(_ user: User, token: String) throws {
    try KeychainPasswordItem(service: serviceName, account: user.email).savePassword(token)
    
    Settings.currentUser = user
    NotificationCenter.default.post(name: .authStateChanged, object: nil)
  }
  
  class func signOut() throws {
    guard let currentUser = Settings.currentUser else {
      return
    }
    
    try KeychainPasswordItem(service: serviceName, account: currentUser.email).deleteItem()
    
    Settings.currentUser = nil
    NotificationCenter.default.post(name: .authStateChanged, object: nil)
  }
  
}

extension Notification.Name {
  static let authStateChanged = Notification.Name(rawValue: "com.codingtest.ExpensifyCodingTest.authStateChanged")
}
