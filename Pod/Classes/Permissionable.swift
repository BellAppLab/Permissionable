import UIKit
import AVFoundation
import Photos
import Alertable
import Backgroundable


//MARK: - Main
/*
    An simplified way of asking permissions to the user on iOS.
*/
public enum Permission: Int
{
    /*
        When you ask for permissions, this is how you get a response back.
    */
    public typealias Result = (success: Bool) -> Void
    
    /*
        Types
        
        For now we're supporting Camera and Photos permissions. More to come!
    */
    case Camera, Photos
    
    /**/
    public func request(sender: UIViewController, _ block: Result? = nil)
    {
        if let access = self.hasAccess { //We either have access or we've been denied
            if access { //No need to ask the user
                return
            }
            //We've been denied access
            let privatePermission = PrivatePermission(rawValue: self.rawValue)!
            Alert.show(privatePermission.message, privatePermission.title, sender, privatePermission.actions(block))
            return
        }
        //We haven't asked for permissions yet
        Alert.show(self.message, self.title, sender, self.actions(sender, block))
    }
    
    /*
        These titles are presented when we're trying to get the user's permission.
    
        We do not provide any translations for these messages, so if your app would like to translate them (or if you would like to have a different wording), simply add keys to your Localizable.strings files that match the ones below.
    */
    var title: String {
        switch self
        {
        case .Camera: return NSLocalizedString("Please", comment: "Title for the alert that appears when we want to ask the user for the camera")
        case .Photos: return NSLocalizedString("Please", comment: "Title for the alert that appears when we want to ask the user for their photos")
        }
    }
    
    /*
        These messages are presented when we're trying to get the user's permission.
    
        We do not provide any translations for these messages, so if your app would like to translate them (or if you would like to have a different wording), simply add keys to your Localizable.strings files that match the ones below.
    */
    var message: String {
        switch self
        {
        case .Camera: return NSLocalizedString("Would you mind if we access your camera?", comment: "Message that asks the user for the camera")
        case .Photos: return NSLocalizedString("Would you mind if we access your photos?", comment: "Message that asks the user for their photos")
        }
    }
    
    //MARK: Aux
    private var hasAccess: Bool? {
        switch self
        {
        case .Camera:
            let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
            switch status
            {
            case .Authorized: return true
            case .Denied, .Restricted: return false
            case .NotDetermined: return nil
            }
        case .Photos:
            let status = PHPhotoLibrary.authorizationStatus()
            switch status
            {
            case .Authorized: return true
            case .Denied, .Restricted: return false
            case .NotDetermined: return nil
            }
        }
        
    }
    
    private func actions(sender: UIViewController, _ block: Result?) -> [Alert.Action]
    {
        var result: [Alert.Action] = []
        result.append((title: NSLocalizedString("No", comment: ""), style: .Destructive, handler: block == nil ? nil : { (UIAlertAction) -> Void in
            toMainThread {
                block!(success: false)
            }
        }))
        switch self
        {
        case .Camera:
            result.append((title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
                Alert.on = true
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (success: Bool) -> Void in
                    Alert.on = false
                    toMainThread {
                        block?(success: success)
                    }
                })
            }))
            break
        case .Photos:
            result.append((title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
                Alert.on = true
                PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) -> Void in
                    Alert.on = false
                    toMainThread {
                        if status == .Denied || status == .Restricted {
                            let privatePermission = PrivatePermission(rawValue: self.rawValue)!
                            Alert.show(privatePermission.message, privatePermission.title, sender, privatePermission.actions(block))
                        }
                        block?(success: status == .Authorized)
                    }
                }
            }))
            break
        }
        return result
    }
}


//MARK: - Private
private enum PrivatePermission: Int
{
    case NoCamera, NoPhotos
    
    /*
    These titles are presented when we're trying to get the user's permission.
    
    We do not provide any translations for these messages, so if your app would like to translate them (or if you would like to have a different wording), simply add keys to your Localizable.strings files that match the ones below.
    */
    var title: String {
        switch self
        {
        case .NoCamera, .NoPhotos: return NSLocalizedString("Uh oh", comment: "Title for the alert that appears when something went wrong")
        }
    }
    
    /*
        These messages are presented when there's an error in getting the user's permission. Maybe they have denied it to the app, maybe there are parental controls in place. 
    
        In such cases, we ask the user if they want to go to the device's settings and check them.
    
        We do not provide any translations for these messages, so if your app would like to translate them (or if you would like to have a different wording), simply add keys to your Localizable.strings files that match the ones below.
    */
    var message: String {
        switch self
        {
        case .NoCamera: return NSLocalizedString("Looks like we can't access the camera... Would you like to go to the Settings app to check?", comment: "Message that appears when we're having trouble accessing the camera")
        case .NoPhotos: return NSLocalizedString("Looks like we can't access your photos... Would you like to go to the Settings app to check?", comment: "Message that appears when we're having trouble accessing the user's photos")
        }
    }
    
    func actions(block: Permission.Result?) -> [Alert.Action]
    {
        var result: [Alert.Action] = []
        result.append((title: NSLocalizedString("No", comment: ""), style: .Destructive, handler: block == nil ? nil : { (UIAlertAction) -> Void in
            toMainThread {
                block!(success: false)
            }
        }))
        result.append((title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
            toMainThread {
                UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
            }
            toMainThread {
                block!(success: false)
            }
        }))
        return result
    }
}
