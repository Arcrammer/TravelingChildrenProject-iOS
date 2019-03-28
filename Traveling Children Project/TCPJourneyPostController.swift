//
//  TCPJourneyPostController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 6/12/18.
//  Copyright © 2018 Traveling Children Project. All rights reserved.
//

import UIKit

class TCPJourneyPostController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var journeyPhoto: UIImageView!
  @IBOutlet weak var titleHeader: UILabel!
  @IBOutlet weak var body: UITextView!
  @IBOutlet weak var tags: UITextView!
  @IBOutlet weak var travelerName: UILabel!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var travelerPortrait: UIImageView!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var heartButton: UIButton!
  
  // MARK: - Actions
  @IBAction func pop(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Properties
  var selectedJourney: Journey?
  
  // MARK: - Methods
  override func viewDidLoad() {
    self.backgroundView.layer.cornerRadius = 10
    self.backgroundView.layer.masksToBounds = true
    
    guard let selectedJourney = self.selectedJourney else {
      return
    }

    // Buttons
    self.editButton.titleLabel!.font = UIFont(name: "FontAwesome", size: 28)
    self.deleteButton.titleLabel!.font = UIFont(name: "FontAwesome", size: 32)
    self.heartButton.titleLabel!.font = UIFont(name: "FontAwesome", size: 26)

    self.editButton.setTitle("\u{f040}", for: .normal)
    self.deleteButton.setTitle("\u{f00d}", for: .normal)
    self.heartButton.setTitle("\u{f004}", for: .normal)

    // Update the view data
    self.titleHeader.text! += " " + selectedJourney.title
    self.body.text = selectedJourney.body
    self.travelerName.text = selectedJourney.travelerName
    self.tags.text = selectedJourney.tags
    
    // Header images
    do {
      let journeyHeaderImage = try UIImage(data: Data(contentsOf: URL(string: "http://" + kServerDomain + "/images/journey-images/" + self.selectedJourney!.imageFileName)!))
      self.journeyPhoto.image = journeyHeaderImage
    } catch {
      print(error)
    }

    // Round the traveler portrait
    self.travelerPortrait.layer.masksToBounds = true
    self.travelerPortrait.layer.cornerRadius = self.travelerPortrait.frame.size.width / 2
  }
}
