//
//  Love_BrowserApp.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import AppTrackingTransparency

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "7536558ae3f1b23c56535c44b46640ec" ]
        return true
    }
}

@available(iOS 14.0, *)
@main

struct Love_BrowserApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    private let urlSessionManager = URLSessionManager()
    @ObservedObject var adCoordinator = AdCoordinator()
    @State private var firstOpen = true
    @State private var showWaitView = true
   
    var body: some Scene {
       
        WindowGroup {
            
            if showWaitView {
                WaitView()
            } else {
                
                if urlSessionManager.results.count == 0 {
                    
                    if let data = UserDefaults.standard.data(forKey: "SegmentViewData") {
                        if let decoded = try? JSONDecoder().decode([SegmentModel].self, from: data) {
                            ContentView(segmentModels: decoded)
                                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
                        }
                    }
    
                } else {
                    ContentView(segmentModels: urlSessionManager.results )
                        .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
                }
            }

        }
        .onChange(of: scenePhase) { phase in
            
            if phase == .active {
                firstOpen = false
                requestTrackingAuthorization()
                hideWaitView()
            }
        }
        
    }
    
    private func hideWaitView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (firstOpen ? 3 : 1)) {
            showWaitView = false
            adCoordinator.tryToPresentAd()
        }
    }
    
    private func requestTrackingAuthorization () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { status in
//                //弹出跟踪广告权限后获取广告ID
//                adCoordinator.requestAppOpenAd()
                
                if status == .authorized {

                }
            }
        }
    }
    
}
