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
  @IBOutlet weak var titleHeader: UILabel!
  @IBOutlet weak var body: UITextView!
  @IBOutlet weak var travelerName: UILabel!
  
  // MARK: - Actions
  @IBAction func pop(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Properties
  var selectedJourney: Journey?
  
  // MARK: - Methods
  override func viewDidLoad() {
    guard let selectedJourney = self.selectedJourney else {
      return
    }
    
    // Update the view data
    self.titleHeader.text! += selectedJourney.title
    self.body.text = selectedJourney.body
    self.travelerName.text = selectedJourney.travelerName
  }
}
