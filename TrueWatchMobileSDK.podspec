Pod::Spec.new do |s|

  s.name         = "TrueWatchMobileSDK"
  s.version      = "1.6.5"
  s.summary      = "TrueWatchTech iOS Data Collection SDK"
  s.homepage     = "https://github.com/TrueWatchTech/datakit-ios"

  s.license      = { type: "Apache", :file => "LICENSE" }
  s.authors      = {
    "hulilei" => "huuuu1016@gmail.com",
    "Brandon Zhang" => "brandonzhangdev@gmail.com"
  }
  s.default_subspec = "FTMobileAgent"
  s.swift_versions = ["5.0"]

  s.ios.deployment_target = "12.0"
  s.osx.deployment_target = "10.14"
  s.tvos.deployment_target = "12.0"
  s.libraries = "z"
  s.pod_target_xcconfig = {
    "DEFINES_MODULE" => "YES",
    "GCC_ENABLE_CPP_EXCEPTIONS" => "YES"
  }

  s.source = {
    :git => "https://github.com/TrueWatchTech/datakit-ios.git",
    :tag => s.version.to_s
  }

  s.resource_bundle = {
    "FTSDKPrivacyInfo" => "FTMobileSDK/Resources/PrivacyInfo.xcprivacy"
  }

  s.subspec "FTMobileAgent" do |agent|
    agent.ios.deployment_target = "12.0"
    agent.tvos.deployment_target = "12.0"
    agent.source_files = "FTMobileSDK/FTMobileAgent/**/*{.h,.m,.swift}"
    agent.dependency "TrueWatchMobileSDK/FTSDKCore"
  end

  s.subspec "Extension" do |e|
    e.platform = :ios, "12.0"
    e.source_files = [
      "FTMobileSDK/FTMobileExtension/*{.h,.m}",
      "FTMobileSDK/FTMobileAgent/Config/*.{h,m}",
      "FTMobileSDK/FTMobileAgent/ExternalData/*{.h,.m}",
      "FTMobileSDK/FTMobileAgent/Extension/*{.h,.m}"
    ]
    e.dependency "TrueWatchMobileSDK/FTSDKCore/FTRUM"
    e.dependency "TrueWatchMobileSDK/FTSDKCore/URLSessionAutoInstrumentation"
    e.dependency "TrueWatchMobileSDK/FTSDKCore/Logger"
  end

  s.subspec "FTSDKCore" do |c|
    c.ios.deployment_target = "12.0"
    c.osx.deployment_target = "10.14"
    c.tvos.deployment_target = "12.0"

    c.subspec "FTRUM" do |r|
      core_path = "FTMobileSDK/FTSDKCore/FTRUM/"
      r.source_files = core_path + "**/*.{h,m,c,cpp}"
      r.dependency "TrueWatchMobileSDK/FTSDKCore/BaseUtils/Base"
      r.dependency "TrueWatchMobileSDK/FTSDKCore/Protocol"
    end

    c.subspec "URLSessionAutoInstrumentation" do |a|
      a.source_files = "FTMobileSDK/FTSDKCore/URLSessionAutoInstrumentation/**/*{.h,.m}"
      a.dependency "TrueWatchMobileSDK/FTSDKCore/Protocol"
      a.dependency "TrueWatchMobileSDK/FTSDKCore/BaseUtils/Swizzle"
    end

    c.subspec "Protocol" do |r|
      r.source_files = "FTMobileSDK/FTSDKCore/Protocol/**/*{.h,.m}"
    end

    c.subspec "RemoteConfig" do |r|
      r.source_files = "FTMobileSDK/FTSDKCore/RemoteConfig/*{.h,.m}"
      r.dependency "TrueWatchMobileSDK/FTSDKCore/DataManager"
    end

    c.subspec "BaseUtils" do |b|
      b.subspec "Base" do |bb|
        bb.source_files = "FTMobileSDK/FTSDKCore/BaseUtils/Base/**/*{.h,.m,.c}"
        bb.dependency "TrueWatchMobileSDK/FTSDKCore/BaseUtils/Thread"
      end

      b.subspec "Thread" do |bb|
        bb.source_files = "FTMobileSDK/FTSDKCore/BaseUtils/Thread/**/*{.h,.m}"
      end

      b.subspec "Swizzle" do |bb|
        bb.source_files = "FTMobileSDK/FTSDKCore/BaseUtils/Swizzle/*{.h,.m,.c}"
        bb.dependency "TrueWatchMobileSDK/FTSDKCore/BaseUtils/Base"
      end
    end

    c.subspec "Logger" do |l|
      l.source_files = "FTMobileSDK/FTSDKCore/Logger/*{.h,.m}"
      l.dependency "TrueWatchMobileSDK/FTSDKCore/BaseUtils/Base"
      l.dependency "TrueWatchMobileSDK/FTSDKCore/Protocol"
    end

    c.subspec "FTWKWebView" do |j|
      j.ios.deployment_target = "12.0"
      j.osx.deployment_target = "10.14"
      j.source_files = "FTMobileSDK/FTSDKCore/FTWKWebView/**/*{.h,.m}"
      j.dependency "TrueWatchMobileSDK/FTSDKCore/Protocol"
      j.dependency "TrueWatchMobileSDK/FTSDKCore/BaseUtils/Swizzle"
    end

    c.subspec "DataManager" do |bb|
      bb.source_files = [
        "FTMobileSDK/FTSDKCore/DataManager/*{.h,.m}",
        "FTMobileSDK/FTSDKCore/DataManager/Upload/*{.h,.m}",
        "FTMobileSDK/FTSDKCore/DataManager/Storage/**/*{.h,.m}",
        "FTMobileSDK/FTSDKCore/DataFilter/*{.h,.m}"
      ]
      bb.dependency "TrueWatchMobileSDK/FTSDKCore/BaseUtils/Thread"
      bb.dependency "TrueWatchMobileSDK/FTSDKCore/BaseUtils/Base"
      bb.dependency "TrueWatchMobileSDK/FTSDKCore/Protocol"
    end
  end

  s.subspec "FTSessionReplay" do |sr|
    sr.platform = :ios, "12.0"
    sr.public_header_files = "FTMobileSDK/FTSessionReplay/Public/*.h"
    sr.source_files = "FTMobileSDK/FTSessionReplay/**/*{.h,.m,.swift}"
    sr.dependency "TrueWatchMobileSDK/FTSDKCore"
    sr.pod_target_xcconfig = {
      "HEADER_SEARCH_PATHS" => "$(inherited) $(PODS_TARGET_SRCROOT)"
    }
  end
end
