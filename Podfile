# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Tweety' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tweety
  pod 'Firebase/Core'
#  pod 'Firebase/Firestore'
  # added this for development, above pod takes too much to build
  pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '6.34.0'
  pod 'Firebase/Auth'
  
  # added this pod for managing Firestore - Codable
  pod 'FirebaseFirestoreSwift'
  
  # flexible stackview, https://github.com/Himanshuarora97/SuperStackView
  pod "SuperStackView"
  
  pod 'Toast-Swift', '~> 5.0.1'

  target 'TweetyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TweetyUITests' do
    # Pods for testing
  end

end
