//  TCPJourneyPostController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/16/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPJourneyPostController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK: - Outlets
  @IBOutlet var journeyTable: UITableView?
  
  // MARK: - Actions
  @IBAction func loadData(_ sender: UIButton) {
    loadJourneys()
  }
  
  // MARK: - Properties
  var journeyPosts: [Journey] = []
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO: TODO: Make sure we always have a journey table
    guard let journeyTable = journeyTable else {
      print("No journey table view in this view controller")
      return
    }
    
    self.journeyTable = journeyTable
    
    // Ask the server for some journeys
    loadJourneys()
  }

  override func viewWillAppear(_ animated: Bool) {
    // TODO: TODO: Make sure we always have a journey table
    guard let journeyTable = journeyTable else {
      print("No journey table view in this view controller")
      return
    }

    // Move the journeys down past the top bar
    journeyTable.contentInset = UIEdgeInsets(top: 75, left: 0, bottom: 0, right: 0)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // Reset tab bar colors
    self.tabBarController!.tabBar.barTintColor = UIColor.TCPBrown // Background
    self.tabBarController!.tabBar.unselectedItemTintColor = UIColor.TCPLightBrown // Light brown unselected icons
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
    #if DEBUG
      var journeyRequest = URLRequest(url: URL(string: "http://10.0.0.8:3000/api/journeys")!)
    #else
      var journeyRequest = URLRequest(url: URL(string: "http://travelingchildrenproject.com/api/journeys")!)
    #endif
    journeyRequest.httpMethod = "POST"
    
    let journeyTask = URLSession.shared.dataTask(with: journeyRequest) {
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
          let travelerName = serializedJourney["traveler_name"] as? String,
          let body = serializedJourney["body"] as? String else {
          print("Missing journey data for journey with _id:", serializedJourney["_id"]!)
          return
        }

        let journeyPost = Journey(
          title: title,
          travelerName: travelerName,
          body: body
        )
        
        self.journeyPosts.insert(journeyPost, at: self.journeyPosts.count)
      }
      
      // Reload table view data
      DispatchQueue.main.async(execute: {
        self.journeyTable!.reloadData()
      })
    }
    
    journeyTask.resume()
  }
  
  // MARK: - UITableViewDataSource Methods
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let journeyPost = tableView.dequeueReusableCell(withIdentifier: "journeyPostCell") as! TCPJourneyPost
    let journey = self.journeyPosts[indexPath.row]

    // Set the view properties
    journeyPost.titleLabel.text = "TC Journey to " + journey.title
    journeyPost.bodyCopy.text = journey.body
    
    return journeyPost
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.journeyPosts.count
  }
}
