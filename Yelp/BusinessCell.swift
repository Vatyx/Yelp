//
//  BusinessCell.swift
//  Yelp
//
//  Created by Vatyx on 2/6/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: myUIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    var business: Business! {
        didSet {
            let strokeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(),
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSStrokeWidthAttributeName : -2.0]
            
            backgroundImage.setImageWithURLRequest(
                NSURLRequest(URL: business.imageURL!),
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.backgroundImage.alpha = 0.0
                    self.backgroundImage.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.backgroundImage.alpha = 0.8
                        
                        }, completion: { (sucess) -> Void in
                            
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })            
            
            nameLabel.attributedText = NSAttributedString(string: business.name!, attributes: strokeTextAttributes)
            addressLabel.attributedText = NSAttributedString(string: business.address!, attributes: strokeTextAttributes)
            distanceLabel.text = business.distance
            
            
            ratingImageView.setImageWithURLRequest(
                NSURLRequest(URL: business.ratingImageURL!),
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.ratingImageView.alpha = 0.0
                    self.ratingImageView.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.ratingImageView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
            
            
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            categoriesLabel.attributedText = NSAttributedString(string: business.categories!, attributes: strokeTextAttributes)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //backgroundImage.updateSize(UIScreen.mainScreen().bounds.width);
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
