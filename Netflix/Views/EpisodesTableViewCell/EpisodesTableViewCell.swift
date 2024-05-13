//
//  EpisodesTableViewCell.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import UIKit
import AVFoundation

class EpisodesTableViewCell: UITableViewCell {
    
    static let identifier = "EpisodesTableViewCell"

    
    @IBOutlet weak var imgThumnail: UIImageView!
    @IBOutlet weak var episodesView: UIView!
    @IBOutlet weak var nameEpisodesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentEpisodesLabel: UILabel!
    
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
        nameEpisodesLabel.text = video.name
        if !video.key.isEmpty {
            getVideoInfo(with: video.key)
        }
        timeLabel.textColor = UIColor("#8C8C8C")
        contentEpisodesLabel.lineBreakMode = .byWordWrapping
        contentEpisodesLabel.numberOfLines = 0
        guard let url = URL(string: "https://img.youtube.com/vi/\(video.key)/0.jpg") else {return}
        imgThumnail.sd_setImage(with: url, completed: nil)
        
    }
    
    func getVideoInfo(with videoKey: String) {
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/videos?key=\(Constants.YoutubeAPIKey)&part=snippet,contentDetails&id=\(videoKey)") else {return}
        URLSession.shared.dataTask(with: url){(data,response,err) in
            if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let videoInfo = try decoder.decode(VideoInfo.self, from: data)
                            let video = videoInfo.items[0]
                            DispatchQueue.main.async {
                                self.timeLabel.text = video.contentDetails.duration.getYoutubeFormattedDuration() + " • " +  self.convertDateFormat(inputDate: "2014-08-26T13:27:51.000Z", toFormat: Constants.MMMMDDYYYY)
                                self.contentEpisodesLabel.text = video.snippet.description
                            }
                        } catch {
                            print("Failed to decode response data:", error)
                        }
                    }
            }.resume()
    }
    
    func convertDateFormat(inputDate: String, toFormat: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = toFormat

         return convertDateFormatter.string(from: oldDate ?? Date())
    }

}
