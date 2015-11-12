import AVFoundation
import Alertable
import Backgroundable


internal extension Permission
{
    internal func hasCameraPermission() -> Bool?
    {
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch status
        {
        case .Authorized: return true
        case .Denied, .Restricted: return false
        case .NotDetermined: return nil
        }
    }
    
    internal func makeCameraAction(block: Result?) -> Alert.Action
    {
        return (title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
            Alert.on = true
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (success: Bool) -> Void in
                Alert.on = false
                toMainThread {
                    block?(success: success)
                }
            })
        })
    }
}
