# Permissionable

A simplified Swifty way of asking users for permissions on iOS, inpired by Cluster's Pre-Permissions: https://github.com/clusterinc/ClusterPrePermissions

_v0.6.0_

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

* iOS 8+
* Swift 3.0

## Installation

### Cocoapods

Because of [this](http://stackoverflow.com/questions/39637123/cocoapods-app-xcworkspace-does-not-exists), I've dropped support for Cocoapods on this repo. I cannot have production code rely on a dependency manager that breaks this badly. 

### Git Submodules

**Why submodules, you ask?**

Following [this thread](http://stackoverflow.com/questions/31080284/adding-several-pods-increases-ios-app-launch-time-by-10-seconds#31573908) and other similar to it, and given that Cocoapods only works with Swift by adding the use_frameworks! directive, there's a strong case for not bloating the app up with too many frameworks. Although git submodules are a bit trickier to work with, the burden of adding dependencies should weigh on the developer, not on the user. :wink:

To install Permissionable using git submodules:

```
cd toYourProjectsFolder
git submodule add -b submodule --name Permissionable https://github.com/BellAppLab/Permissionable.git && git submodule update --recursive Permissionable
```

Navigate to the new Permissionable, Alertable and Defines folders and drag each of the `Source` folders to your Xcode project.

### Sub-permissions

* **Camera:** If your project requires getting permission to use the camera, make sure to link it to `AVFoundation`. If you don't require it, remove the `Camera` folder.
* **Location:** If your project requires getting permission to use location services, make sure to link it to `CoreLocation`. If you don't require it, remove the `Location` folder.
* **Photos:** If your project requires getting permission to access the user's photos, make sure to link it to `Photos`. If you don't require them, remove the `Photos` folder.

## Author

Bell App Lab, apps@bellapplab.com

## License

Permissionable is available under the MIT license. See the LICENSE file for more info.
