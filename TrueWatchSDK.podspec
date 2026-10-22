Pod::Spec.new do |s|

	s.name         = "TrueWatchSDK"
	s.version      = "1.6.8"
	s.summary      = "TrueWatchTech iOS Data Collection SDK"
	#s.description  = ""
	s.homepage     = "https://github.com/TrueWatchTech/datakit-ios.git"

	s.license      = { type: 'Apache', :file => 'LICENSE'}
	s.authors             = { "hulilei" => "huuuu1016@gmail.com","Brandon Zhang" => "brandonzhangdev@gmail.com" }
	s.default_subspec = 'Agent'
	s.swift_versions = ['5.0']

	s.ios.deployment_target = '15.0'
	s.osx.deployment_target = '12.0'
	s.tvos.deployment_target = '15.0'
	s.libraries    = 'z'
	header_search_paths = '$(inherited) $(PODS_TARGET_SRCROOT) $(PODS_TARGET_SRCROOT)/Sources $(PODS_TARGET_SRCROOT)/Sources/Core/** $(PODS_TARGET_SRCROOT)/Sources/Agent/** $(PODS_TARGET_SRCROOT)/Sources/WidgetExtension $(PODS_TARGET_SRCROOT)/Sources/SessionReplay/**'
	s.pod_target_xcconfig = {
		'DEFINES_MODULE' => 'YES',
		'GCC_ENABLE_CPP_EXCEPTIONS' => 'YES',
		'HEADER_SEARCH_PATHS' => header_search_paths,
		'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FT_COCOAPODS=1'
	}

	#1.6.8 replacing "#{s.version}" will cause an error during pod valid phase
	s.source       = { :git => "https://github.com/TrueWatchTech/datakit-ios.git", :tag => s.version.to_s }

    s.resource_bundle = {
      "FTSDKPrivacyInfo" => "Sources/Resources/PrivacyInfo.xcprivacy"
    }

    s.subspec 'Diagnostics' do |d|
        d.source_files = 'Sources/Diagnostics/**/*.{h,m}'
        d.public_header_files = 'Sources/Diagnostics/include/*.h'
        d.dependency 'TrueWatchSDK/Core/BaseUtils'
    end

	s.subspec  'Agent' do | agent |
		core_path='Sources/Agent/'
		agent.ios.deployment_target = '15.0'
		agent.osx.deployment_target = '12.0'
		agent.tvos.deployment_target = '15.0'
		agent.source_files = 'Sources/Agent/Public/*.{h}',
			'Sources/Agent/**/*{.h,.m,.swift}'
		agent.exclude_files = 'Sources/Agent/AutoTrack/FTSwiftUIBridgeStub.m'
		agent.ios.exclude_files = 'Sources/Agent/AutoTrack/Mac/**/*'
		agent.tvos.exclude_files = 'Sources/Agent/AutoTrack/Mac/**/*'
		agent.dependency 'TrueWatchSDK/Core'
	end

	s.subspec 'WidgetExtension' do |e|
		e.platform = :ios, '15.0'
		e.source_files = 'Sources/WidgetExtension/*{.h,.m}','Sources/Agent/Config/*.{h,m}','Sources/Agent/ExternalData/*{.h,.m}','Sources/Agent/Extension/*{.h,.m}','Sources/Agent/Shared/Public/*.h'
		e.dependency 'TrueWatchSDK/Core/FTRUM'
		e.dependency 'TrueWatchSDK/Core/URLSessionAutoInstrumentation'
		e.dependency 'TrueWatchSDK/Core/Logger'
	end

	s.subspec 'Extension' do |e|
		e.platform = :ios, '15.0'
		e.dependency "#{s.name}/WidgetExtension"
	end

	s.subspec 'Core' do |c|
		c.ios.deployment_target = '15.0'
		c.osx.deployment_target = '12.0'
		c.tvos.deployment_target = '15.0'

		c.subspec 'FTRUM' do |r|
			r.source_files = 'Sources/Core/FTRUM/**/*.{h,m,c,cpp}'
			r.dependency 'TrueWatchSDK/Core/BaseUtils'
			r.dependency 'TrueWatchSDK/Core/Protocol'
			r.dependency 'TrueWatchSDK/Core/VisitorID'
		end

		c.subspec 'URLSessionAutoInstrumentation' do |a|
			a.source_files = 'Sources/Core/NetworkAutoInstrumentation/**/*{.h,.m}'
			a.dependency 'TrueWatchSDK/Core/Protocol'
			a.dependency 'TrueWatchSDK/Core/BaseUtils'
			a.dependency 'TrueWatchSDK/Core/VisitorID'
		end

		c.subspec 'VisitorID' do |v|
			v.source_files = 'Sources/Core/VisitorID/**/*{.h,.m}'
			v.dependency 'TrueWatchSDK/Core/BaseUtils'
			v.dependency 'TrueWatchSDK/Core/Protocol'
		end

		c.subspec 'Protocol' do |r|
			r.source_files = 'Sources/Core/Protocol/**/*{.h,.m}'
		end

		c.subspec 'RemoteConfig' do |r|
			r.source_files = 'Sources/Core/RemoteConfig/*{.h,.m}', 'Sources/Core/Public/FTRemoteConfigModel.h'
			r.dependency 'TrueWatchSDK/Core/DataManager'
		end

		c.subspec 'BaseUtils' do |b|
				b.source_files = 'Sources/Core/BaseUtils/**/*{.h,.m,.c}'
		end

		c.subspec 'Logger' do |l|
			l.source_files = 'Sources/Core/Logger/*{.h,.m}'
			l.dependency 'TrueWatchSDK/Core/BaseUtils'
			l.dependency 'TrueWatchSDK/Core/Protocol'
		end

		c.subspec 'FTWKWebView' do |j|
			j.ios.deployment_target = '15.0'
			j.osx.deployment_target = '12.0'
			j.source_files = 'Sources/Core/FTWKWebView/**/*{.h,.m}', 'Sources/Core/Public/FTWKWebViewHandler.h'
			j.dependency 'TrueWatchSDK/Core/Protocol'
			j.dependency 'TrueWatchSDK/Core/BaseUtils'
		end

		c.subspec 'DataManager' do |bb|
			bb.source_files = [
				'Sources/Core/DataManager/*{.h,.m}',
				'Sources/Core/DataManager/Upload/*{.h,.m}',
				'Sources/Core/DataManager/Storage/**/*{.h,.m}',
				'Sources/Core/DataFilter/*{.h,.m}'
			]
			bb.dependency 'TrueWatchSDK/Core/BaseUtils'
			bb.dependency 'TrueWatchSDK/Core/Protocol'
		end
	end

	s.subspec 'SessionReplay' do |sr|
		 sr.ios.deployment_target = '15.0'
		 sr.osx.deployment_target = '12.0'
		 sr.public_header_files = 'Sources/SessionReplay/Public/*.h'
		 sr.source_files = 'Sources/SessionReplay/**/*{.h,.m}'
		 sr.dependency 'TrueWatchSDK/Core'
		 sr.pod_target_xcconfig = {
			 'HEADER_SEARCH_PATHS' => header_search_paths,
			 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FT_COCOAPODS=1'
		 }
	end

	s.subspec 'FTSessionReplay' do |sr|
		sr.ios.deployment_target = '15.0'
		sr.osx.deployment_target = '12.0'
		sr.dependency "#{s.name}/SessionReplay"
	end

	s.subspec 'ElectronWebView' do |electron|
		electron.platform = :osx, '12.0'
		electron.public_header_files = 'Sources/ElectronWebView/Public/*.h'
		electron.source_files = 'Sources/ElectronWebView/**/*{.h,.m}'
		electron.dependency 'TrueWatchSDK/Core'
		electron.dependency 'TrueWatchSDK/SessionReplay'
		electron.pod_target_xcconfig = {
			'HEADER_SEARCH_PATHS' => header_search_paths,
			'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FT_COCOAPODS=1'
		}
	end
end
