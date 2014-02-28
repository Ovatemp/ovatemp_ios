platform :ios, "6.0"

target :Ovatemp do
  pod "HockeySDK", inhibit_warnings: true
  pod "Mixpanel", inhibit_warnings: true
end

target :OvatempTests, exclusive: true do
  pod "Expecta", inhibit_warnings: true
  # pod "Igor", inhibit_warnings: true, podspec: 'Podspecs/Igor.podspec'
  pod "KIF", inhibit_warnings: true, podspec: 'Podspecs/Kif.podspec'
  pod "OCMock", inhibit_warnings: true
  pod "Nocilla", inhibit_warnings: true
  pod "Specta", inhibit_warnings: true
end
