//  TCPJourneyPostController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/16/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit
import FoldingCell

fileprivate struct C {
  struct CellHeight {
    static let close: CGFloat = 185 // equal or greater foregroundView height
    static let open: CGFloat = 250 // equal or greater containerView height
  }
}

class TCPJourneyPostController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK: - Outlets
  @IBOutlet var journeyTable: UITableView?
  @IBOutlet var iconLabel: UILabel!
  
  // MARK: - Actions
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
  var cellHeights: [CGFloat] = []
  let kCloseCellHeight: CGFloat = 185
  let kOpenCellHeight: CGFloat = 250

  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cellHeights = Array(repeating: kCloseCellHeight, count: self.journeyPosts.count)
    
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
    // TODO: Make sure we always have a journey table
    guard let journeyTable = journeyTable else {
      print("No journey table view in this view controller")
      return
    }

    // Move the journeys down past the top bar and up past the tab bar
    journeyTable.contentInset = UIEdgeInsets(top: 75, left: 0, bottom: 12, right: 0)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // Set the icon
    self.iconLabel.font = UIFont(name: "FontAwesome", size: 20)!
      
    switch self.tabBarController!.selectedIndex {
      case 0:
        self.iconLabel.text = "\u{f124}"
      case 1:
        self.iconLabel.text = "\u{f067}"
      case 2:
        self.iconLabel.text = "\u{f004}"
      default:
        return
    }

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
    print("Requesting journeys from \(kServerDomain)...")
    
    var journeyRequest = URLRequest(url: URL(string: "http://" + kServerDomain + "/journeys")!)
    journeyRequest.httpMethod = "POST"
    
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

      // Set the initial cell height for each cell
      self.cellHeights = (0..<self.journeyPosts.count).map {_ in C.CellHeight.close}
      
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeights[indexPath.row]
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
      return
    }
    
    if cell.isAnimating() {
      return
    }
    
    var duration = 0.0
    let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
    if cellIsCollapsed {
      cellHeights[indexPath.row] = kOpenCellHeight
      cell.selectedAnimation(true, animated: true, completion: nil)
      duration = 0.5
    } else {
      cellHeights[indexPath.row] = kCloseCellHeight
      cell.selectedAnimation(false, animated: true, completion: nil)
      duration = 0.8
    }

    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
      tableView.beginUpdates()
      tableView.endUpdates()
    }, completion: nil)
  }
  
  @nonobjc func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if case let foldingCell as FoldingCell = cell {
      if cellHeights[indexPath.row] == kOpenCellHeight {
        foldingCell.selectedAnimation(false, animated: false, completion:nil)
      } else {
        foldingCell.selectedAnimation(true, animated: false, completion: nil)
      }
    }
  }
}
