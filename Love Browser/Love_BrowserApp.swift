//
//  Love_BrowserApp.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@available(iOS 14.0, *)
@main

struct Love_BrowserApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    private let adCoordinator = AdCoordinator()
    @State private var firstOpen = true
    @State private var showWaitView = true
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "7536558ae3f1b23c56535c44b46640ec" ]
        adCoordinator.requestAppOpenAd()
    }
   

    var body: some Scene {
       
        WindowGroup {
            
            if showWaitView {
                WaitView()
            } else {
                ContentView()
                    .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
            }

        }
        .onChange(of: scenePhase) { phase in
            
            if phase == .active && firstOpen {
                firstOpen = false
                requestTrackingAuthorization()
                showAdView()
            }
        }
        
    }
    
    private func showAdView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            adCoordinator.tryToPresentAd()
            showWaitView = false
        }
    }
    
    private func requestTrackingAuthorization () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { status in
                //弹出跟踪广告权限后获取广告ID
                adCoordinator.requestAppOpenAd()
                
                if status == .authorized {

                }
            }
        }
    }
    
}
