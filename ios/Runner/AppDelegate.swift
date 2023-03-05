import UIKit
import Flutter
import GoogleMaps
import Firebase
import UserNotifications
import GoogleMobileAds
import AppTrackingTransparency

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey(Environment.googleApiKeyIos)
        GeneratedPluginRegistrant.register(with: self)
        if #available(iOS 10.0, *) {
            application.applicationIconBadgeNumber = 0 // Clear Badge Counts
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
