//
//  WKWebViewConfigurationExtension.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/22.
//

import WebKit

extension WKWebViewConfiguration {
        
    public func persistent() -> WKWebViewConfiguration {
        return configuration(persistsData: true)
    }

    public func nonPersistent() -> WKWebViewConfiguration {
        return configuration(persistsData: false)
    }
    
    private func configuration(persistsData: Bool) -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        if !persistsData {
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        }
//        configuration.dataDetectorTypes = [.phoneNumber]

        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.ignoresViewportScaleLimits = true
        configuration.preferences.isFraudulentWebsiteWarningEnabled = false
        

        return configuration
    }

}

