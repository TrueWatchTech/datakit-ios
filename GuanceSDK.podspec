Pod::Spec.new do |s|

	s.name         = "GuanceSDK"
	s.version      = "1.6.5"
	s.summary      = "Guance Cloud iOS Data Collection SDK"
	#s.description  = ""
	s.homepage     = "https://github.com/GuanceCloud/datakit-ios.git"

	s.license      = { type: 'Apache', :file => 'LICENSE'}
	s.authors             = { "hulilei" => "hulilei@guance.com","Brandon Zhang" => "zhangbo@guance.com" }
	s.default_subspec = 'Agent'
	s.swift_versions = ['5.0']

	s.ios.deployment_target = '12.0'
	s.osx.deployment_target = '10.14'
	s.tvos.deployment_target = '12.0'
	s.libraries    = 'z'
	header_search_paths = '$(inherited) $(PODS_TARGET_SRCROOT) $(PODS_TARGET_SRCROOT)/Sources $(PODS_TARGET_SRCROOT)/Sources/Core/** $(PODS_TARGET_SRCROOT)/Sources/Agent/** $(PODS_TARGET_SRCROOT)/Sources/WidgetExtension $(PODS_TARGET_SRCROOT)/Sources/SessionReplay/**'
	core_source_files = 'Sources/Core/**/*.{h,m,c,cpp}'
	s.pod_target_xcconfig = {
		'DEFINES_MODULE' => 'YES',
		'GCC_ENABLE_CPP_EXCEPTIONS' => 'YES',
		'HEADER_SEARCH_PATHS' => header_search_paths,
		'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GUANCE_COCOAPODS=1'
	}

	#$JENKINS_DYNAMIC_VERSION replacing "#{s.version}" will cause an error during pod valid phase
	s.source       = { :git => "https://github.com/GuanceCloud/datakit-ios.git", :tag => s.version.to_s }

    s.resource_bundle = {
      "FTSDKPrivacyInfo" => "Sources/Resources/PrivacyInfo.xcprivacy"
    }

	s.source_files = core_source_files

	s.subspec  'Agent' do | agent |
		core_path='Sources/Agent/'
		agent.ios.deployment_target = '12.0'
		agent.osx.deployment_target = '10.14'
		agent.tvos.deployment_target = '12.0'
		agent.source_files =  core_source_files,
			'Sources/Agent/**/*{.h,.m}'

	end

	s.subspec 'WidgetExtension' do |e|
		e.platform = :ios, '12.0'
		e.source_files = core_source_files,'Sources/WidgetExtension/*{.h,.m}','Sources/Agent/Config/*.{h,m}','Sources/Agent/ExternalData/*{.h,.m}','Sources/Agent/Extension/*{.h,.m}'
	end

	s.subspec 'SessionReplay' do |sr|
		 sr.platform = :ios, '12.0'
		 sr.public_header_files = 'Sources/SessionReplay/Public/*.h'
		 sr.source_files = core_source_files,
		 	'Sources/SessionReplay/**/*{.h,.m}'
		 sr.pod_target_xcconfig = {
			 'HEADER_SEARCH_PATHS' => header_search_paths,
			 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GUANCE_COCOAPODS=1'
		 }
	end
end
