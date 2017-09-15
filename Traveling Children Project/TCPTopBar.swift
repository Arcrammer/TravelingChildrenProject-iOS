//  TCPTopBar.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 9/15/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPTopBar: UIView {
  // MARK: - Methods
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // Grab the user data from UserDefaults
    let userData = UserDefaults.standard.object(forKey: "Traveler") as! Dictionary<String, Any>
    
    // Set the traveler name from UserDefaults
    if let travelerNameLabel = self.viewWithTag(2) as? UILabel,
      let travelerName = userData["first_name"] as? String {
      // Update the travelers name in the top bar
      travelerNameLabel.text = "Traveling " + travelerName
    }
    
    // Set the traveler portrait image from UserDefaults
    if let travelerPortraitImageView = self.viewWithTag(3) as? UIImageView,
      let travelerPortrait = userData["travelerPortrait"] as? Data {
      travelerPortraitImageView.image = UIImage(data: travelerPortrait)!
      
      // Round the edges
      travelerPortraitImageView.layer.cornerRadius = travelerPortraitImageView.bounds.size.width / 2
      travelerPortraitImageView.layer.masksToBounds = true
    }
  }
}
