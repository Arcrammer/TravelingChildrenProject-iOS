//  TCPJourneyPost.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/29/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPJourneyPost: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var bodyCopy: UITextView!
  
  // MARK: - Methods
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func layoutSubviews() {
    self.contentView.frame = UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsets(
      top: 10,
      left: 10,
      bottom: 10,
      right: 10
    ))
    self.contentView.layer.cornerRadius = 10
  }
}
