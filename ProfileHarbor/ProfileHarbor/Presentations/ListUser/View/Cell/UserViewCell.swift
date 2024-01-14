//
//  UserViewCell.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import UIKit

class UserViewCell: UITableViewCell {
    struct Constants {
        static let cornerRadiusImage: CGFloat = 30
    }
    static let nibName: String = "UserViewCell"
    static let identifier: String = "UserViewCell"
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var model: UserViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = Constants.cornerRadiusImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func updateUI() {
        nameLabel.text = model?.fullName ?? ""
        usernameLabel.text = model?.userName ?? ""
        if let data = model?.imageData {
            avatarImageView.image = UIImage(data: data)
        } else {
            avatarImageView.image = UIImage(named: PHImages.Name.icAvaPlaceholder)
        }
    }
}
