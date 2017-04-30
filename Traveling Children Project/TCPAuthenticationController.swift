//  TCPAuthenticationController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/30/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPAuthenticationController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
  // MARK: - Outlets
  @IBOutlet var container: UIView!
  @IBOutlet var scrollViewBottom: NSLayoutConstraint!

  // MARK: - Actions
  @IBAction func handleContainerTap(_ sender: Any) {
    // Dismiss the keyboard
    self.view.endEditing(true)
  }
  
  // MARK: - Properties
  var keyboardHeight: CGFloat?
  
  // MARK: - Methods
  override func viewWillAppear(_ animated: Bool) {
    // Give the form view rounded corners
    self.container.layer.cornerRadius = 10
    
    // Watch the keyboard so we can adjust the bottom position of the scroll view when it shows and hides
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Dismiss the keyboard
    self.view.endEditing(true)
  }
  
  func keyboardDidShow(notification: NSNotification) {
    // Move the bottom of the scroll view to the top
    // of the keyboard now that we know its' height
    guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
      print("Coulnd't get the height of the keyboard")
      return
    }

    guard let scrollViewBottom = self.scrollViewBottom else {
      print("Couldn't get the bottom constraint")
      return
    }
    
    // Don't change the constraint unless the keyboard frame actually changed
    let beginFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue!
    let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue!
    guard beginFrame.equalTo(endFrame) == false else {
      print("Keyboard frame didn't change — Skipping scroll bottom view constraint change")
      return
    }
    
    // Remember how much space we added so we can remove it later — Especially needed in case of rotation changes
    // since the keyboard height isn't going to match what we had previously added to the bottom constraint
    self.keyboardHeight = keyboardFrame.size.height

    // Add the keyboards' height to the bottom distance of the scroll view
    scrollViewBottom.constant += self.keyboardHeight!
  }
  
  func keyboardWillHide(notification: NSNotification) {
    // Remove the extra space we added earlier when the keyboard is dismissed
    guard let keyboardHeight = self.keyboardHeight else {
      print("Coulnd't get the keyboard height that was supposed to be saved from first showing")
      return
    }
    
    guard let scrollViewBottom = self.scrollViewBottom else {
      print("Couldn't get the bottom constraint")
      return
    }
    
    // Don't change the constraint unless the keyboard frame actually changed
    let beginFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue!
    let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue!
    guard beginFrame.equalTo(endFrame) == false else {
      print("Keyboard frame didn't change — Skipping scroll bottom view constraint change")
      return
    }

    // Remove the keyboards' height from the
    // bottom distance of the scroll view
    scrollViewBottom.constant -= keyboardHeight
  }
  
  // MARK: - UITextFieldDelegate Methods
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextField = textField.superview!.viewWithTag(textField.tag + 1) {
      nextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }

    return true
  }
}
