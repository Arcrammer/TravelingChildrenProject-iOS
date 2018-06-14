//  TCPJourneyBlogController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/16/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPJourneyBlogController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK: - Outlets
  @IBOutlet var journeyTable: UITableView?
  @IBOutlet var iconLabel: UILabel!
  @IBOutlet weak var topBar: UIView!
  
  // MARK: - Actions
  @IBAction func reloadJourneys(_ sender: Any) {
    self.loadJourneys()
  }
  
  @IBAction func logOut(_ sender: Any) {
    // Deauth the user
    TCPAuthenticationController.logOut()
    
    // Send the user to the auth view
    let authenticationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainAuthenticationView")
    authenticationView.modalTransitionStyle = .crossDissolve
    present(authenticationView, animated: true, completion: nil)
  }
  
  // MARK: - Properties
  var journeyPosts: [Journey] = []
  var selectedJourney: Journey?

  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let topBar = self.topBar,
    let journeyTable = self.journeyTable {
      // Move the journeys below the top bar (so they can blur behind it)
      journeyTable.contentInset = UIEdgeInsetsMake(topBar.frame.size.height + 4, 0, 4, 0)
    }

    // TODO: Make sure we always have a journey table
    guard journeyTable != nil else {
      print("No journey table view in this view controller")
      return
    }
    
    // Ask the server for some journeys
    loadJourneys()
  }

  override func viewWillAppear(_ animated: Bool) {
    // TODO: Make sure we always have a journey table
    guard journeyTable != nil else {
      print("No journey table view in this view controller")
      return
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // Set the icon
    if (self.iconLabel != nil) {
      self.iconLabel.font = UIFont(name: "FontAwesome", size: 20)!

      // Icon labels
      switch self.tabBarController!.selectedIndex {
      case 0:
        // Home for 'Journeys'
        self.iconLabel.text = "\u{f015}"
      case 1:
        // Location arrow for 'My Journeys'
        self.iconLabel.text = "\u{f124}"
      case 3:
        // Heart for 'Liked Journeys'
        self.iconLabel.text = "\u{f004}"
      default:
        return
      }
    }

    // Reset tab bar colors
    self.tabBarController!.tabBar.barTintColor = UIColor.TCPBrown // Background
    self.tabBarController!.tabBar.unselectedItemTintColor = UIColor.TCPLightBrown // Light brown unselected icons
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // If we're going to a TCPJourneyPostController send the selected journey over
    if let journeyPostController = segue.destination as? TCPJourneyPostController {
      // Pass the journey post to the next view
      journeyPostController.selectedJourney = self.selectedJourney
      
      // Because OCD
      self.selectedJourney = nil
    }
  }

  /**
   * loadJourneys()
   *
   * Grabs journeys from the server
   */
  private func loadJourneys() {
    // Determine which URL to send the request to based on which view this object is
    var journeyRequestURL: String = "http://" + kServerDomain + "/journeys"
    if let title = self.title {
      switch title {
      case "My Journeys":
        journeyRequestURL = "http://" + kServerDomain + "/journeys/created"
        break
        
      default:
        return
      }
    }

    var journeyRequest = URLRequest(url: URL(string: journeyRequestURL)!)
    journeyRequest.httpMethod = "POST"
    print("Requesting journeys from \(journeyRequestURL)...")

    // Send the Passport ID too
    let userData = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "Traveler") as! Data) as! [String: AnyObject]
    guard let passportID = userData["passport_id"] as? String else {
      return
    }
    journeyRequest.httpBody = "passport_id=\(passportID)".data(using: String.Encoding.utf8)

    let journeyTask = URLSession.shared.dataTask(with: journeyRequest) {
      data, response, error in
      
      // Make sure there aren't any errors
      guard error == nil else {
        let errorAlertController = UIAlertController(title: "Something Happened", message: error!.localizedDescription, preferredStyle: .actionSheet)
        errorAlertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {
          (action: UIAlertAction) in
          self.loadJourneys()
        }))
        errorAlertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(errorAlertController, animated: true, completion: nil)
        
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

      // Clear out all the old journey posts from last time we grabbed data from the server
      self.journeyPosts.removeAll(keepingCapacity: false)
      
      for serializedJourney in journeys {
        guard let title = serializedJourney["title"] as? String,
          let travelerName = serializedJourney["traveler_name"] as? String,
          let body = serializedJourney["body"] as? String else {
            print("Missing journey data for journey with _id:", serializedJourney["_id"]!)
            return
        }
        
        let journeyPost = Journey(
          title: title,
          travelerName: "Traveling " + travelerName,
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

  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let journeyPost = tableView.dequeueReusableCell(withIdentifier: "journeyPostCell") as! TCPJourneyPost
    let journey = self.journeyPosts[indexPath.row]
    
    // Set the view properties
    for titleLabel in journeyPost.titleLabels {
      titleLabel.text = "TC Journey to " + journey.title
    }

    for body in journeyPost.bodies {
      body.text = journey.body
    }

    for travelerName in journeyPost.travelerNames {
      travelerName.text = journey.travelerName
    }

    return journeyPost
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let background = UIView(frame: CGRect(
      x: cell.frame.minX + 10,
      y: cell.frame.maxX + 10,
      width: cell.frame.width - 10,
      height: cell.frame.height - 10
    ))
    background.backgroundColor = UIColor.TCPYellow
    cell.addSubview(background)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.journeyPosts.count
  }
  
  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Remember the selected journey post so we can send it to the next view
    self.selectedJourney = self.journeyPosts[indexPath.row]
    
    performSegue(withIdentifier: "journeyPostSegue", sender: self)
  }
}
