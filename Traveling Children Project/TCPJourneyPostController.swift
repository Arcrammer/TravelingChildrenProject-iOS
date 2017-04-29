//  TCPJourneyPostController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/16/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPJourneyPostController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - UITableViewDataSource Methods
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let journeyPost = tableView.dequeueReusableCell(withIdentifier: "journeyPostCell") as! TCPJourneyPost
    
    journeyPost.titleLabel.text = "Sandy Springs"
    journeyPost.titleLabel.text = "TC Journey to " + journeyPost.titleLabel.text!
    
    return journeyPost
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 30
  }
}
