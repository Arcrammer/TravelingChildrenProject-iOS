//  AppDelegate.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/16/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

// Official TCP colors
extension UIColor {
  static let TCPBrown = UIColor(red: 58/255, green: 36/255, blue: 23/255, alpha: 1)
  static let TCPLightBrown = UIColor(red: 96/255, green: 56/255, blue: 19/255, alpha: 1)
  static let TCPOrange = UIColor(red: 238/255, green: 103/255, blue: 48/255, alpha: 1)
  static let TCPYellow = UIColor(red: 254/255, green: 224/255, blue: 136/255, alpha: 1)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {
  // MARK: - Properties
  var window: UIWindow?
  
  // MARK: - Methods
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window!.backgroundColor = UIColor(red: 157/255, green: 220/255, blue: 249/255, alpha: 1)
    self.window!.makeKeyAndVisible()
    
    // Set the first view controller
    let firstViewController: UIViewController
    if (false) {
      firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainAuthenticationView")
    } else {
      firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBarView")
    }
    self.window!.rootViewController = firstViewController

    // Logo mask background view
    let flyingLogoBackgroundView = UIView(frame: firstViewController.view.frame)
    flyingLogoBackgroundView.backgroundColor = self.window!.backgroundColor
    firstViewController.view.addSubview(flyingLogoBackgroundView)
    firstViewController.view.bringSubview(toFront: flyingLogoBackgroundView)

    // Create the logo layer
    let flyingLogo = CALayer()
    flyingLogo.name = "flyingLogo"
    flyingLogo.contents = UIImage(named: "LaunchLogo")!.cgImage
    flyingLogo.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    flyingLogo.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    flyingLogo.position = CGPoint(x: firstViewController.view.frame.width / 2, y: firstViewController.view.frame.height / 2)
    
    // Insert it above all the other sublayers
    firstViewController.view.layer.insertSublayer(flyingLogo, at: UInt32(firstViewController.view.layer.sublayers!.count))
    
    // Logo scaling animation
    let logoScaleAnimation = CAKeyframeAnimation(keyPath: "bounds")
    logoScaleAnimation.delegate = self
    logoScaleAnimation.duration = 1
    logoScaleAnimation.beginTime = CACurrentMediaTime() + 1 // Add 1 second delay
    logoScaleAnimation.values = [
      NSValue(cgRect: flyingLogo.bounds),
      NSValue(cgRect: CGRect(x: 0, y: 0, width: 50, height: 50)),
      NSValue(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
    ]
    logoScaleAnimation.keyTimes = [0, 0.5, 1]
    logoScaleAnimation.timingFunctions = [
      CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
      CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    ]
    logoScaleAnimation.isRemovedOnCompletion = false
    logoScaleAnimation.fillMode = kCAFillModeForwards
    flyingLogo.add(logoScaleAnimation, forKey: "scaleAnimation")
    
    // Logo transparency animation
    let logoOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    logoOpacityAnimation.delegate = self
    logoOpacityAnimation.duration = 1
    logoOpacityAnimation.beginTime = CACurrentMediaTime() + 1 // Add 1 second delay
    logoOpacityAnimation.values = [
      NSNumber(floatLiteral: 1.0),
      NSNumber(floatLiteral: 0.0)
    ]
    logoOpacityAnimation.keyTimes = [0.75, 1]
    logoOpacityAnimation.timingFunctions = [
      CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
      CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    ]
    logoOpacityAnimation.isRemovedOnCompletion = false
    logoOpacityAnimation.fillMode = kCAFillModeForwards
    flyingLogo.add(logoOpacityAnimation, forKey: "opacityAnimation")
    flyingLogoBackgroundView.layer.add(logoOpacityAnimation, forKey: "opacityAnimation")
    
    // Root view animation
    self.window!.rootViewController!.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    UIView.animate(withDuration: 0.25,
      delay: 1.85,
      options: [],
      animations: {
        self.window!.rootViewController!.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      }, completion: {
        finished in
        flyingLogoBackgroundView.removeFromSuperview()

        UIView.animate(
          withDuration: 0.3,
          delay: 0.0,
          options: UIViewAnimationOptions.curveEaseInOut,
          animations: {},
          completion: nil
        )
    })

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  // MARK: CAAnimationDelegate Methods
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    // Remove mask when animation completes
    for layer in self.window!.rootViewController!.view.layer.sublayers! {
      if let layerName = layer.name, layerName == "flyingLogo" {
        layer.removeFromSuperlayer()
      }
    }
  }
}
