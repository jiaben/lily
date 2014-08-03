cd ../../
git pull
cd -
cd proj.ios
xcodebuild clean
xcodebuild 
xcrun -sdk iphoneos PackageApplication -v Build/Release-iphoneos/XiYouTa.app -o /doc/XiYouTa_inhouse.ipa
