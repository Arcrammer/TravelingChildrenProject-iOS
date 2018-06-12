//  TCPParentPINCodeViewController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 10/10/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPParentPINCodeViewController: UIViewController, UITextFieldDelegate {
  // MARK: - Outlets
  @IBOutlet weak var firstPasscodeField: UITextField!
  
  // MARK: - Actions
  @IBAction func dismiss(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func passcodeFieldValueChanged(_ sender: UITextField) {
    // Either send the user to the next field or verify their passcode
    if sender.text!.count == 1 {
      if let nextTextField = view.viewWithTag(sender.tag + 1) {
        // Send the user to the next passcode field
        nextTextField.becomeFirstResponder()
      } else {
        // Dismiss the keyboard because we're on the last passcode bullet
        sender.resignFirstResponder()
      }
    } else if sender.text!.count == 0, let previousTextField = view.viewWithTag(sender.tag - 1) {
      // Send the user to the previous passcode field
      previousTextField.becomeFirstResponder()
    }
  }

  @IBAction func submitPasscode() {
    print("We're going to pretend the passcode was right")
    performSegue(withIdentifier: "TCPEditReadingLogSegue", sender: self)
  }
  
  // MARK: - Methods
  override func viewDidLoad() {
    // Send the user to the first passcode field
    self.firstPasscodeField.becomeFirstResponder()
  }
  
  // MARK: - UITextFieldDelegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // If the user hit the back button, the current passcode field is
    // empty, and there's a previous passcode field send the user to it
    if strcmp(string.cString(using: String.Encoding.utf8)!, "\\b") == -92,
      textField.text! == "",
      let previousTextField = view.viewWithTag(textField.tag - 1) {
      previousTextField.becomeFirstResponder()
    }

    return true
  }
}
