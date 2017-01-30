fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs all the tests
### ios provision
```
fastlane ios provision
```
Creating a code signing certificate and provisioning profile
### ios beta
```
fastlane ios beta
```
Submit a new Beta Build to Apple TestFlight

This will also make sure the profile is up to date
### ios build_for_release
```
fastlane ios build_for_release
```
Increment build number and generate IPA
### ios release
```
fastlane ios release
```
Deploy previously built IPA and metadata to the App Store
### ios build_and_release
```
fastlane ios build_and_release
```
Deploy a new version to the App Store

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
