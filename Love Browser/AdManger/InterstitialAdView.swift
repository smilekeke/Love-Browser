//
//  InterstitialAdView.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/24.
//

import SwiftUI
import GoogleMobileAds

struct InterstitialAdView: View {
    
    let adCoordinator = InterstitialAdCoordinator.shared
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    
    @Binding var openAdView: Bool
    
    var body: some View {
        VStack {
            
            Color.black.opacity(0.001)
                .onTapGesture {
                    openAdView = false
                }
            
        }.background(adViewControllerRepresentable
            .frame(width: .zero, height: .zero))
        .background(BackgroundBlurView())
        .onAppear {
            
            if adCoordinator.showAdView {
                openAdView = false
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                    adCoordinator.showAd(from: adViewControllerRepresentable.viewController)
                    
                }
            }
        }
    }
}

class InterstitialAdCoordinator: NSObject, GADFullScreenContentDelegate, ObservableObject {
    private var interstitial: GADInterstitialAd?
    var showAdView: Bool = false
    
    static let shared = InterstitialAdCoordinator()
    
    override init() {
        super.init()
        loadInterstitialAd()
    }

    func loadInterstitialAd() {
        GADInterstitialAd.load(
               withAdUnitID: "ca-app-pub-9608024198628702/8899802699",
               request: GADRequest()
        ) { ad, error in
            if let error = error {
                self.showAdView = true
                return print("Failed to load ad with error: \(error.localizedDescription)")
            }
            self.showAdView = false
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        showAdView = true
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitial = nil
        loadInterstitialAd()
        showAdView = true
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        loadInterstitialAd()
    }
    
    func showAd(from viewController: UIViewController) {
        guard let interstitial = interstitial else {
            showAdView = true
            loadInterstitialAd()
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


//struct InterstitialAdView_Previews: PreviewProvider {
//    static var previews: some View {
//        InterstitialAdView()
//    }
//}
