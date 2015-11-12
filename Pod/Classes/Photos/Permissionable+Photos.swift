import Photos
import Alertable
import Backgroundable


internal extension Permission
{
    internal func hasPhotosPermission() -> Bool?
    {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status
        {
        case .Authorized: return true
        case .Denied, .Restricted: return false
        case .NotDetermined: return nil
        }
    }
    
    internal func makePhotosAction(sender: UIViewController, _ block: Result?) -> Alert.Action
    {
        return (title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
            Alert.on = true
            PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) -> Void in
                Alert.on = false
                toMainThread {
                    if status == .Denied || status == .Restricted {
                        if let privatePermission = PrivatePermission.privateFor(publicPermission: self) {
                            Alert.show(privatePermission.message, privatePermission.title, sender, privatePermission.actions(block))
                        }
                    }
                    block?(success: status == .Authorized)
                }
            }
        })
    }
}