//  TCPJourneyPostController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/16/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPJourneyPostController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK: - Outlets
  @IBOutlet var journeyTable: UITableView!
  
  // MARK: - Actions
  @IBAction func loadData(_ sender: UIButton) {
    loadJourneys()
  }
  
  // MARK: - Properties
  var journeyPosts: [Journey] = []
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Ask the server for some journeys
    loadJourneys()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /**
   * loadJourneys()
   *
   * Grabs journeys from the server
   */
  private func loadJourneys() {
    let journeyTask = URLSession.shared.dataTask(with: URL(string: "http://10.0.0.8:3000/api/journeys")!) {
      data, response, error in
      
      // Make sure there aren't any errors
      guard error == nil else {
        print(error!)
        return
      }
      
      // Make sure there's data
      guard let data = data else {
        print("No data in that request... :/")
        return
      }
      
      // Make sure there are journeys
      guard let journeys = try? JSONSerialization.jsonObject(with: data, options: []) as! Array<[String: Any]> else {
        print("Couldn't serialize journeys to JSON")
        return
      }
      
      for serializedJourney in journeys {
        guard let title = serializedJourney["title"] as? String,
          let travelerName = serializedJourney["traveler_name"] as? String else {
          print("Missing journey data for journey with _id:", serializedJourney["_id"]!)
          return
        }

        let journeyPost = Journey(title: title, travelerName: travelerName)
        
        self.journeyPosts.insert(journeyPost, at: self.journeyPosts.count)
      }
      
      // Reload table view data
      DispatchQueue.main.async(execute: {
        self.journeyTable.reloadData()
      })
    }
    
    journeyTask.resume()
  }
  
  // MARK: - UITableViewDataSource Methods
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let journeyPost = tableView.dequeueReusableCell(withIdentifier: "journeyPostCell") as! TCPJourneyPost
    let journey = self.journeyPosts[indexPath.row]

    // Set the view properties starting with the title
    journeyPost.titleLabel.text = "TC Journey to " + journey.title
    
    return journeyPost
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.journeyPosts.count
  }
}
