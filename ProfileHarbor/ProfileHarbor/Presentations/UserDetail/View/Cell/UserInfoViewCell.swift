//
//  UserInfoViewCell.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import UIKit

class UserInfoViewCell: BaseTableViewCell {
    
    class Constants {
        static let cornerRadiusAvatar: CGFloat = 30
    }

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    
    var model: UserInfoCellModel! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = Constants.cornerRadiusAvatar
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateUI() {
        fullNameLabel.text = model.fullName
        usernameLabel.text = model.userName
        avatarImageView.imageFromURLString(model.avatarUrl)
        followerLabel.text = "\(model.numOfFollowers)"
        followingLabel.text = "\(model.numOfFollowings)"
    }
}
