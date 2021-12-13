//
//  GithubAPI.swift
//  RxSwift+UITableView
//
//  Created by Hajime Taniguchi on 2021/12/12.
//

import Foundation

class GithubAPI {
    private static var task: URLSessionTask?
    
    private static let usersURL = "https://api.github.com/users/"
    private static let repos = "/repos"

    enum FetchRepositoryError: Error {
        case noInput
        case wrongURL
        case noData
        case parse
    }
    
    static func fetchRepository(text: String, completionHandler: @escaping (Result<[Repository], Error>) -> Void) {
        guard !text.isEmpty else {
            completionHandler(.failure(FetchRepositoryError.noInput))
            return
        }
        let urlString = Self.usersURL + text + Self.repos
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
