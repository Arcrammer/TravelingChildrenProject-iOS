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
  @IBOutlet weak var cellBackgroundView: UIView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var bodyCopy: UITextView!
  @IBOutlet weak var travelerName: UILabel!
  @IBOutlet weak var travelerPortrait: UIImageView!
  @IBOutlet weak var likeIcon: UILabel!
  
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
    self.cellBackgroundView.layer.cornerRadius = 10
    self.cellBackgroundView.layer.masksToBounds = true
    
    // Traveler icon radius
    self.travelerPortrait.layer.cornerRadius = self.travelerPortrait.bounds.size.width / 2
    self.travelerPortrait.layer.masksToBounds = true

    // Like icon
    self.likeIcon.font = UIFont(name: "FontAwesome", size: 26)!
    self.likeIcon.text = "\u{f004}"
  }
  
  override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
    let durations = [0.33, 0.26, 0.26]
    return durations[itemIndex]
  }
}
