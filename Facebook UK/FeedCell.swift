//
//  FeedCell.swift
//  Facebook UK
//
//  Created by Ang Sherpa on 30/01/2017.
//  Copyright © 2017 ES Studios Inc. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    
    var post: Post? {
        didSet {
            
            if let name = post?.name {
                let attributedtext = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                
                if let city = post?.location?.city, let state = post?.location?.state {
                    attributedtext.append(NSAttributedString(string: "\n\(city), \(state)  •  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.rgb(red: 155, green: 161, blue: 161)]))
                }
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributedtext.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedtext.string.characters.count))
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedtext.append(NSAttributedString(attachment: attachment))
                
                
                nameLabel.attributedText = attributedtext
            }
            
            
            if let statusText = post?.statusText {
                statusTextview.text = statusText
            }
            
            
            if let profileImageName = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
            }
            
            if let statusImageName = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImageName)
                DispatchQueue.global(qos: .userInitiated).async {
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        self.loader.stopAnimating()
                    }
                }
            }
            
            /*
            if let statusImageUrl = post?.statusImageUrl {
                
                if let image = imageCache.object(forKey: statusImageUrl as AnyObject) {
                    statusImageView.image = image as? UIImage
                } else {
                    
                    let url = URL(string: statusImageUrl)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print("George: \(error)")
                        }
                        
                        if data == nil {
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                        imageCache.setObject(image!, forKey: statusImageUrl as AnyObject)
                        
                        // Move to a background thread to do some long running work
                        DispatchQueue.global(qos: .userInitiated).async {
                            // Bounce back to the main thread to update the UI
                            DispatchQueue.main.async {
                                self.statusImageView.image = image
                                self.loader.stopAnimating()
                            }
                        }
                        
                    }).resume()
                }
                
                
            }
            */
            
            if let numLikes = post?.numLikes, let numComments = post?.numComments {
                likesCommentsLabel.text = "\(numLikes) Likes  \(numComments) Comments"
            }
            
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        
        return label
        
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.red
        return imageView
    }()
    
    let statusTextview: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton = FeedCell.buttonForTitle(title: "Like", imageView: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle(title: "Comment", imageView: "comment")
    let shareButton: UIButton = FeedCell.buttonForTitle(title: "Share", imageView: "share")
    
    static func buttonForTitle(title: String, imageView: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        
        button.setImage(UIImage(named: imageView), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    
    func animate() {
        
        feedController?.animateImageView(statusImageView: statusImageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextview)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        //
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedCell.animate as (FeedCell) -> () -> ())))
        
        setupStatusImageViewLoader()
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", view: profileImageView, nameLabel)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", view: nameLabel)
        
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", view: statusTextview)
        
        addConstraintsWithFormat(format: "H:|[v0]|", view: statusImageView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", view: dividerLineView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]|", view: likesCommentsLabel)
        // button Comment
        addConstraintsWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", view: likeButton, commentButton, shareButton)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", view: profileImageView, statusTextview, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", view: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", view: shareButton)
        
    }
    
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.black
        statusImageView.addSubview(loader)
        statusImageView.addConstraintsWithFormat(format: "H:|[v0]|", view: loader)
        statusImageView.addConstraintsWithFormat(format: "V:|[v0]|", view: loader)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
