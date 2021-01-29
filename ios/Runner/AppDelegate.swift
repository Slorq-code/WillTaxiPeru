import UIKit
import Flutter
import GoogleMaps
import FBSDKLoginKit
import FBSDKCoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GMSServices.provideAPIKey("AIzaSyC5w0fmK1CYAiY8JvlFRmTASVepmwE9DjM")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @available(iOS 9.0, *)
  override  func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
    -> Bool {
      return FBSDKApplicationDelegate.sharedInstance().application(application,  open: url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
  }

    // para iOS menor a 9.0
  override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application,open: url as URL!,sourceApplication: sourceApplication,annotation: annotation)
  }
}
