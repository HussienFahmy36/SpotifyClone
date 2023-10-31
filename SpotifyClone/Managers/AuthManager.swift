// https://accounts.spotify.com/authorize?response_type=code&client_id=238121f4d9634abaa25a5412c9a722a4&scope=user-read-private&redirect_uri=https://www.iosacademy.io
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import Foundation
extension String {
    static func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""

        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }

}
final class AuthManager {
    public static let shared = AuthManager()
    
    private struct Constants {
        static let clientID = "238121f4d9634abaa25a5412c9a722a4"
        static let clientSecret = "f573937da14b4ddfa90e1e84e1c7d74d"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirect_uri = "https://google.com.eg"
        static let scopes = "user-read-private user-read-email playlist-modify-public playlist-read-private playlist-modify-private user-follow-read user-follow-modify user-library-modify user-library-read"
    }
    
    public var signInURL: URL? {
        var urlComponents = URLComponents()
        urlComponents.host = "accounts.spotify.com"
        urlComponents.scheme = "https"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "scope", value: Constants.scopes),
            URLQueryItem(name: "redirect_uri", value: Constants.redirect_uri),
            URLQueryItem(name: "state", value: String.randomAlphaNumericString(length: 16))
        ]
        return urlComponents.url

    }
    private init() {
        
    }
    
    var isSignedIn: Bool {
        accessToken != nil
    }
    
    private var accessToken: String? {
        UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        UserDefaults.standard.string(forKey: "refresh_token")

    }
    
    private var tokenExpirationDate: Date? {
        UserDefaults.standard.object(forKey: "expires_in") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        var currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        currentDate = currentDate.addingTimeInterval(fiveMinutes)
        return currentDate >= expirationDate // if five minutes passed after token expiration date, should refresh
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> ()) {
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        var components = URLComponents()
        components.queryItems = [
        URLQueryItem(name: "grant_type", value: "authorization_code"),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "redirect_uri", value: Constants.redirect_uri),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    /// supplies valid token per request
    public func withValidToken(completion: @escaping (String)-> Void) {
        if shouldRefreshToken {
            refreshToken {[weak self] success in
                guard let self else { return }
                if let accessToken, success {
                    completion(accessToken)
                } else {
                    
                }
            }
        } else {
            if let accessToken {
                completion(accessToken)
            }
        }
        
    }
    
    private func refreshToken(completion: @escaping (Bool)-> Void) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else{
            return
        }

        guard let url = URL(string: Constants.tokenAPIURL) else { return }

        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),

        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed")
                self.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()


    }
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")

    }
}
