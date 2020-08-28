//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by hiroko nagano on 2020/08/25.
//  Copyright © 2020 hiroko.nagano. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageVIew: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var comentButton: UIButton!    
    @IBOutlet weak var comentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //PostDateの内容をセルに表示
    func setPostDate(_ postData: PostData) {
        //画像の表示
        postImageVIew.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageVIew.sd_setImage(with: imageRef)
        
        //キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        //日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            
            self.dateLabel.text = dateString
        }
        
        //コメントの表示
        var comment_text:String = ""
        for comment in postData.coments {
            let comment1 = comment + "\n"
            comment_text = comment_text + comment1
        }
        
        self.comentLabel.text = comment_text
        
        

        //コメントとキャプションの高さ自動調整してレイアウトする
        
        let rect: CGSize = captionLabel.sizeThatFits(CGSize(width: frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        captionLabel.frame = CGRect(x: 10, y: postImageVIew.frame.height + likeButton.frame.height  + 40, width: rect.width, height: rect.height)
        
        let rect2: CGSize = comentLabel.sizeThatFits(CGSize(width: frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        comentLabel.frame = CGRect(x: 10, y: postImageVIew.frame.height + likeButton.frame.height + captionLabel.frame.height + 50, width: rect2.width, height: rect2.height)
        
    
        //いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
