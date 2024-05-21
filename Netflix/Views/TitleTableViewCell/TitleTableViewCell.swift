

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showImageView.frame = contentView.bounds
    }
    
    public func configure(with model: TitleView) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        showImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }
}
