//  Journey.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/29/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import Foundation

class Journey: NSObject {
  var passport_id: String?
  var title: String
  var travelerName: String
  
  init(title: String, travelerName: String) {
    self.title = title
    self.travelerName = travelerName
  }
}
