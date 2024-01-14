//
//  UserViewCell.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import UIKit

class UserViewCell: UITableViewCell {
    static let nibName: String = "UserViewCell"
    static let identifier: String = "UserViewCell"
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var model: UserViewModel! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func updateUI() {
        nameLabel.text = model.fullName
        usernameLabel.text = model.userName
        do {
            let data = try Data(contentsOf: URL(string: model.avatarURL)!)
            avatarImageView.image = UIImage(data: data)
        } catch (let e) {
            debugPrint("thanhlt \(e.localizedDescription)")
        }
    }
}
