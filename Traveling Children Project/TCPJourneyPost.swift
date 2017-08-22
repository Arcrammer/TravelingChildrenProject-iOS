//  TCPJourneyPost.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/29/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit
import FoldingCell

class TCPJourneyPost: FoldingCell {
  // MARK: - Outlets
  @IBOutlet var backgroundViews: [UIView]!
  @IBOutlet var titleLabels: [UILabel]!
  @IBOutlet var bodies: [UITextView]!
  @IBOutlet var travelerNames: [UILabel]!
  @IBOutlet var travelerPortraits: [UIImageView]!
  @IBOutlet var likeIcons: [UILabel]!
  
  // MARK: - Methods
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Background radius
    for backgroundView in self.backgroundViews {
      backgroundView.layer.cornerRadius = 10
      backgroundView.layer.masksToBounds = true
    }
    
    // Traveler icon radius
    for travelerPortrait in self.travelerPortraits {
      travelerPortrait.layer.cornerRadius = travelerPortrait.bounds.size.width / 2
      travelerPortrait.layer.masksToBounds = true
    }
      
    // Like icon
    for likeIcon in self.likeIcons {
      likeIcon.font = UIFont(name: "FontAwesome", size: 26)!
      likeIcon.text = "\u{f004}"
    }
  }
  
  override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
    let durations = [0.33, 0.26, 0.26]
    return durations[itemIndex]
  }
}
