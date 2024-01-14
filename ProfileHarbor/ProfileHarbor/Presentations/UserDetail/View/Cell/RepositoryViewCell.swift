//
//  RepositoryViewCell.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import UIKit

class RepositoryViewCell: BaseTableViewCell {
    
    class Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var numOfStarLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var circleView: UIView!
    var model: RepositoryCellModel! {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        circleView.layer.cornerRadius = Constants.cornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        nameLabel.text = model.name
        languageLabel.text = model.languages
        numOfStarLabel.text = "\(model.numOfStars)"
        
    }
}
