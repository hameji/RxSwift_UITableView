//
//  GithubAPI.swift
//  RxSwift+UITableView
//
//  Created by Hajime Taniguchi on 2021/12/12.
//

import Foundation

extension FetchRepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noInput:
            return NSLocalizedString("There was no input for user", comment: "NoInput")
        case .wrongURL:
            return NSLocalizedString("The URL did not exist", comment: "WrongURL")
        case .noData:
            return NSLocalizedString("There was no data at url", comment: "NoData")
        case .parse:
            return NSLocalizedString("Failed to decode json", comment: "Parse")
        }
    }
}

enum FetchRepositoryError: Error {
    case noInput
    case wrongURL
    case noData
    case parse
}

// https://api.github.com/users/hameji/repos

class GithubAPI {
    private static var task: URLSessionTask?
    
    private static let usersURL = "https://api.github.com/users/"
    private static let repos = "/repos"
    
    private static let url = "https://api.github.com/search/repositories?q=Swift"
    
    static func fetchRepository(text: String, completionHandler: @escaping (Result<[Repository], Error>) -> Void) {
        guard !text.isEmpty else {
            completionHandler(.failure(FetchRepositoryError.noInput))
            return
        }
        let urlString = Self.url // Self.usersURL + text + Self.repos
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(FetchRepositoryError.wrongURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let error = err {
                completionHandler(.failure(error))
                return
            }
            guard let safeData = data else {
                completionHandler(.failure(FetchRepositoryError.noData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedData = try decoder.decode(Repositories.self, from: safeData)
                completionHandler(.success(decodedData.items))
            } catch {
                completionHandler(.failure(FetchRepositoryError.parse))
            }
        }
        task.resume()
    }
    
    static func taskCancel() {
        task?.cancel()
    }
}
