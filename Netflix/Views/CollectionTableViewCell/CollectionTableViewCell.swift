//
//  CollectionTableViewCell.swift
//  Netflix
//
//

import UIKit

class CollectTableViewCell: UITableViewCell {
    
    static let identifier = "CollectTableViewCell"

    @IBOutlet weak var imgCollection: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    var videoKey: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with video: Video) {
        nameLabel.text = "Test"
        timeLabel.text = "37m"
        timeLabel.textColor = UIColor("#8C8C8C")
        contentLabel.text = "Flying high: Chrishell reveals her latest love - Jason. In LA, the agents get real about the relationship while Christine readies her return."
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/") else {return}
        imgCollection.sd_setImage(with: url, completed: nil)
    }

}
