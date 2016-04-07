# Permissionable

[![CI Status](http://img.shields.io/travis/Bell App Lab/Permissionable.svg?style=flat)](https://travis-ci.org/Bell App Lab/Permissionable)
[![Version](https://img.shields.io/cocoapods/v/Permissionable.svg?style=flat)](http://cocoapods.org/pods/Permissionable)
[![License](https://img.shields.io/cocoapods/l/Permissionable.svg?style=flat)](http://cocoapods.org/pods/Permissionable)
[![Platform](https://img.shields.io/cocoapods/p/Permissionable.svg?style=flat)](http://cocoapods.org/pods/Permissionable)

## Usage

```swift
import Permissionable

class ViewController: UIViewController {
    func askPermission() {
        Permissions.Camera.request(self) { (success: Bool) -> Void in 
            if success {
                print("\o/")
            }
        }
    }
    func askForPushPermission() {
        Permissions.Push.request(self, categories) { (success: Bool) -> Void in 
            if success {
                print("\o/")
            }
        }
    }
}
    
//===================================================
    
import Permissionable

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    {...}

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Permissions.didFinishRegisteringForPushNotifications(error)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //Do domething with the token
        Permissions.didFinishRegisteringForPushNotifications(nil)
    }
}

//===================================================

import Permissionable

class UserHandler {
    func logout() {
        Permissions.reset()
    }
}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Localization

To localize this library, make sure you include the following entries in your Localizable.strings file:

`"Yes" = "<Your translation>";`

`"No" = "<Your translation>";`

`"Please" = "<Your translation>"; //Default alert title`

`"Would you mind if we send you push notifications?" = "<Your translation>"; //Default message for push notifications`

`"Would you mind if we access your camera?" = "<Your translation>"; //Default message for the device's camera`

`"Would you mind if we access your photos?" = "<Your translation>"; //Default message for the user's photos`

`"Uh oh" = "<Your translation>"; //Default alert title for when things go wrong`

`"Looks like we can't access the camera... Would you like to go to the Settings app to check?" = "<Your translation>"; //Default message to prompt the user to fix a permission on the Settings app`

`"Looks like we can't access your photos... Would you like to go to the Settings app to check?" = "<Your translation>"; //Default message to prompt the user to fix a permission on the Settings app`


## Requirements

iOS 8+

## Installation

### CocoaPods

Permissionable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Permissionable"
```

**Please note** that this will install all possible permissions (and their related libraries as well), bloating up your app's dependencies. Take a look at the commands below to find one that suits your needs:

```ruby
pod "Permissionable/Camera"
```

```ruby
pod "Permissionable/Photos"
```

```ruby
pod "Permissionable/Location"
```

### Git Submodules

**Why submodules, you ask?**

Following [this thread](http://stackoverflow.com/questions/31080284/adding-several-pods-increases-ios-app-launch-time-by-10-seconds#31573908) and other similar to it, and given that Cocoapods only works with Swift by adding the use_frameworks! directive, there's a strong case for not bloating the app up with too many frameworks. Although git submodules are a bit trickier to work with, the burden of adding dependencies should weigh on the developer, not on the user. :wink:

To install Alertable using git submodules:

```
cd toYourProjectsFolder
git submodule add -b Submodule --name Permissionable https://github.com/BellAppLab/Permissionable.git && git submodule add -b Submodule --name Defines https://github.com/BellAppLab/Defines.git && git submodule add -b Submodule --name Alertable https://github.com/BellAppLab/Alertable.git
```

Navigate to the new Permissionable, Alertable and Defines folders and drag each of the Pods folders to your Xcode project.

*Note: Git submodules with nested submodules can get very messy quite quickly. So it sounds prudent to have dependencies be handled as regular submodules.*

## Author

Bell App Lab, apps@bellapplab.com

## License

Permissionable is available under the MIT license. See the LICENSE file for more info.
