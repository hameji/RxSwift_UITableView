//
//  RepositoryCell.swift
//  RxSwift+UITableView
//
//  Created by Hajime Taniguchi on 2021/12/12.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    
    @IBOutlet weak var starImageView: UIImageView! {
        didSet {
            starImageView.image = UIImage(systemName: "star") // tintColor: UIColor.systemGray)
        }
    }
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(data: Repository) {
        ownerImageView.image = nil
        ownerNameLabel.text = data.owner.login
        repositoryNameLabel.text = data.fullName
        repositoryDescriptionLabel.text = data.description
        starImageView.image = nil
        starCountLabel.text = "\(data.stargazersCount)"
        languageLabel.text = data.language
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
