//
//  RepositoryStatusCell.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 17/01/2024.
//

import UIKit

class RepositoryStatusCell: BaseTableViewCell {

    @IBOutlet weak var illustrationView: CustomIllustrationView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateStatus(_ isFetched: Bool) {
        illustrationView.updateUI( isFetched ? .empty : .loading )
    }
    
}
