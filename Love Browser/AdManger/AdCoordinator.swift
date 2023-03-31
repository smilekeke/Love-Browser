//
//  AdCoordinator.swift
//  Love Browser
//
//  Created by 豆子 on 2023/3/30.
//
import GoogleMobileAds

final class AdCoordinator: NSObject, GADFullScreenContentDelegate {
    var ad: GADAppOpenAd?
    var loadTime = Date()
   
    func requestAppOpenAd() {
        GADAppOpenAd.load(withAdUnitID: "ca-app-pub-9608024198628702/6854868529",
                          request: GADRequest(),
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: { (appOpenAdIn, _) in
                            self.ad = appOpenAdIn
                            self.ad?.fullScreenContentDelegate = self
                            self.loadTime = Date()
                            print("[OPEN AD] Ad is ready")
                         })
    }
   
    func tryToPresentAd() {
        if let gOpenAd = self.ad, wasLoadTimeLessThanNHoursAgo(thresholdN: 3) {
            gOpenAd.present(fromRootViewController: (UIApplication.shared.windows.first?.rootViewController)!)
        } else {
            self.requestAppOpenAd()
        }
    }
   
    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }
   
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("[OPEN AD] Failed: \(error)")
        requestAppOpenAd()
    }
   
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestAppOpenAd()
        print("[OPEN AD] Ad dismissed")
    }
 
}
