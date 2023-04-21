//
//  AdCoordinator.swift
//  Love Browser
//
//  Created by 豆子 on 2023/3/30.
//
import GoogleMobileAds

class AdCoordinator: NSObject, GADFullScreenContentDelegate, ObservableObject {
    
    @Published var appOpenAdLoaded: Bool = false
    var ad: GADAppOpenAd?
    var loadTime = Date()

    override init() {
        super.init()
        requestAppOpenAd()
    }

    func requestAppOpenAd() {
        GADAppOpenAd.load(withAdUnitID: "ca-app-pub-9608024198628702/6854868529",
                          request: GADRequest()) { appOpenAdIn, error in
            if let error = error {
                self.ad = nil
                print("App open ad failed to load with error: \(error.localizedDescription).")
                return
            }
            self.ad = appOpenAdIn
            self.ad?.fullScreenContentDelegate = self
            self.loadTime = Date()
            self.appOpenAdLoaded = true
            print("[OPEN AD]>>>>>>appAd is ok")
        }
    }
   
    func tryToPresentAd() {
        if let gOpenAd = self.ad, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
            gOpenAd.present(fromRootViewController: (UIApplication.shared.windows.first?.rootViewController)!)
            print("[OPEN AD]>>>>>>Ad is show")
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
