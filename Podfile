platform :ios, '12.0'

target "LJCDBStore" do
    inhibit_all_warnings! #inhibit_warnings!   #禁止三方警告
    use_frameworks!
    
    # Networking -> Model -> DB
    pod 'WCDB.objc'
    #pod 'WCDB', '~> 1.0.5'
    #pod 'YTKKeyValueStore'  #, '~> 0.1.2'
    pod 'AFNetworking'
    pod 'YTKNetwork'
    pod 'MJExtension'
    
    # Common Components
    #pod 'Masonry'  #, '~> 1.1.0'
    pod 'Masonry', :git => 'https://github.com/SnapKit/Masonry.git'
    pod 'MJRefresh' #, '~> 3.1.15'
    pod 'SVProgressHUD' #, '~> 2.2.2'
    #pod 'YYKit'
    # Fix webP framewrk: https://github.com/ibireme/YYKit/pull/596
    pod 'YYKit', git: 'https://github.com/SAGESSE-CN/YYKit.git'
    
    #pod 'GYMonitor'
    #pod 'UITableView+FDTemplateLayoutCell'
    #pod 'Texture'
    pod 'IQKeyboardManager' #, '~> 5.0.6'
    #pod 'ChameleonFramework'    #颜色框架
    pod 'MWPhotoBrowser'    #, '~> 2.1.2'
    pod 'TZImagePickerController', '~> 3.8.6'
    pod 'SCRecorder'
    pod 'LLSimpleCamera'
    
    
    # Others
    #pod 'MLeaksFinder'
    pod 'Aspects'   #hook
    
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 强制设置最低部署目标为 iOS 12.0
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      # 兼容 Xcode 14+ 的额外配置（可选，防止其他兼容问题）
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
