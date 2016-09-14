////
////  UserInfoRow.swift
////  Get To It
////
////  Created by Richard Blakeney-Williams on 9/09/16.
////  Copyright © 2016 Get To It Ltd. All rights reserved.
////
//
//import Foundation
//import Eureka
//
//struct User: Equatable {
//    var name: String
//    var pictureUrl: URL?
//    var rating: String
//    var whenPosted: Date
//    
//}
//
//func ==(lhs: User, rhs: User) -> Bool {
//    return lhs.name == rhs.name
//}
//
//final class UserInfoCell: Cell<User>, CellType {
//    
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var ratingsLabel: UILabel!
//    @IBOutlet weak var whenPostedLabel: UILabel!
//    @IBOutlet weak var pictureImageView: UIImageView!
//    
//    
//    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    override func setup() {
//        super.setup()
//        
//        //Don't want cell to be selected
//        selectionStyle = .none
//        
//        //Configure our profile picture imageView
//        pictureImageView.contentMode = .scaleAspectFill
//        pictureImageView.clipsToBounds = true
//        pictureImageView.layer.cornerRadius = pictureImageView.frame.size.width / 2;
//
//
//        
//        //define fonts for our labels 
//        for label in [nameLabel,ratingsLabel,whenPostedLabel]{
//            label?.textColor = UIColor.gray
//        }
//        //specify the desired height for our cell
//        height = { return 94 }
//        
//        //set a light background color for our cell
//        backgroundColor = UIColor.white
//    }
//    
//    
//    override func update() {
//        super.update()
//        
//        //we do not want to show the default UITableViewCell's textLabel
//        textLabel?.text = nil
//        
//        //get the value from our row
//        guard let user = row.value else { return }
//        
//        //set the image to the userImageView. AlamofireImage/Firebase here???
//        if let url = user.pictureUrl, let data = Data(contentsOfURL: url){
//            pictureImageView.image = UIImage(data: data)
//            
//            
//            
//        } else {
//            pictureImageView.image = UIImage(named: "DefaultProfilePic")
//        }
//        
//        //Get image and set it's size
//        let image = UIImage(named: "DefaultProfilePic")
//        let newSize = CGSize(width: 10, height: 10)
//        
//        //Resize image
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//        let imageResized = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        //Create attachment text with image
//        var attachment = NSTextAttachment()
//        attachment.image = imageResized
//        var attachmentString = NSAttributedString(attachment: attachment)
//        var myString = NSMutableAttributedString(string: "I love swift ")
//        myString.append(attachmentString)
//        //myLabel.attributedText = myString
//        
//        
//        //Set the texts to the labels
//        nameLabel.text = user.name
//        ratingsLabel.text = user.rating
//        whenPostedLabel.text = DateFormatter().string(from: user.whenPosted)
//        
//        nameLabel.attributedText = myString
//        
//        
//    }
//    
//    
//}
//
//final class UserInfoRow: Row<User, UserInfoCell>, RowType {
//    required init(tag: String?) {
//        super.init(tag: tag)
//        cellProvider = CellProvider<UserInfoCell>(nibName: "UserCell")
//    }
//}
//
//
