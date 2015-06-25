platform :ios, "7.0"

target :Ovatemp do
  pod "Inflections", inhibit_warnings: true
  pod "Reachability", inhibit_warnings: true
  pod "Helpshift"
  pod 'Localytics',  '~> 3.0'
  pod "TAOverlay"
  pod "CocoaLumberjack"
  pod "CCMPopup"
  pod "AFNetworking"
  pod "Stripe"
  pod "Stripe/ApplePay"
  pod "ApplePayStubs"
  pod "FBSDKCoreKit"
end

target :OvatempTests, exclusive: true do
  pod "Expecta", inhibit_warnings: true
  pod "KIF", inhibit_warnings: true, podspec: 'Podspecs/Kif.podspec'
  pod "OCMock", inhibit_warnings: true
  pod "Nocilla", inhibit_warnings: true
  pod "Specta", inhibit_warnings: true
end
