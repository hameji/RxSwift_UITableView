//
//  ViewController.swift
//  RxSwift+UITableView
//
//  Created by Hajime Taniguchi on 2021/12/12.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            let repositoryCell = UINib(nibName: "RepositoryCell", bundle: nil)
            tableView.register(repositoryCell, forCellReuseIdentifier: "RepositoryCell")
        }
    }
    
    private var repositories: [Repository] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GithubAPI.fetchRepository(text: "hameji") { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let repos):
                print(repos.count)
                self?.repositories = repos
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        let repoData = repositories[indexPath.row]
        // cell.bind(repoData)
        return cell
    }
}

