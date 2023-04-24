//
//  InterstitialAdCoordinator.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/23.
//

import Foundation
import SwiftUI
import GoogleMobileAds

 class InterstitialAdCoordinator: NSObject, GADFullScreenContentDelegate, ObservableObject {
    private var interstitial: GADInterstitialAd?
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
     
     override init() {
         super.init()
         loadInterstitialAd()
     }
     
     var adViewControllerRepresentableView: some View {
         adViewControllerRepresentable
             .frame(width: .zero, height: .zero)
     }

     func loadInterstitialAd() {
         GADInterstitialAd.load(
                withAdUnitID: "ca-app-pub-9608024198628702/8899802699",
                request: GADRequest()
         ) { ad, error in
             if let error = error {
                 return print("Failed to load ad with error: \(error.localizedDescription)")
             }
             self.interstitial = ad
             self.interstitial?.fullScreenContentDelegate = self
         }
     }

     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
         interstitial = nil
     }
     
     func showAd(from viewController: UIViewController) {
         guard let interstitial = interstitial else {
             return print("Ad wasn't ready")
         }

         interstitial.present(fromRootViewController: viewController)
     }

}

// MARK: - Helper to present Interstitial Ad
 struct AdViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UIViewController()

    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}



