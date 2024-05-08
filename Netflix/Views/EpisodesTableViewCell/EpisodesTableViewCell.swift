//
//  EpisodesTableViewCell.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import UIKit

class EpisodesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameEpisodesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentEpisodesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
