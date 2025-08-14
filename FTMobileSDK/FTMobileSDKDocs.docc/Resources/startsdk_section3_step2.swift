//
//  AppDelegate.swift
//  
//
//  Created by hulilei on 2022/10/25.
//

import Foundation
import FTMobileSDK

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let mobileConfig = FTMobileConfig.init(metricsUrl: "YOUR URL")
        mobileConfig.enableSDKDebugLog = true
        mobileConfig.env = .common
        mobileConfig.globalContext = ["CustomKey":"CustomValue"]
        mobileConfig.service = "Custom Service Name"
        FTMobileAgent.start(withConfigOptions: mobileConfig)
        
        let rumConfig = FTRumConfig.init(appid: "YOUR APP ID")
        rumConfig.samplerate = 50
        rumConfig.enableTraceUserView = true
        rumConfig.enableTraceUserAction = true
        rumConfig.enableTraceUserResource = true
        rumConfig.enableTrackAppCrash = true
        rumConfig.errorMonitorType = .all
        rumConfig.enableTrackAppANR = true
        rumConfig.enableTrackAppFreeze = true
        rumConfig.deviceMetricsMonitorType = .all
        rumConfig.monitorFrequency = .default
        rumConfig.globalContext = ["track_id":"track_id_value"]
        FTMobileAgent.sharedInstance().startRum(withConfigOptions: rumConfig)
        
        let loggerConfig = FTLoggerConfig.init()
        loggerConfig.discardType = .discard
        loggerConfig.enableCustomLog = true
        
        return true
    }

}

