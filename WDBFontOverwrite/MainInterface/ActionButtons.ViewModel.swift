//
//  ActionButtons.ViewModel.swift
//  WDBFontOverwrite
//
//  Created by Noah Little on 9/2/2023.
//

import UIKit.UIApplication

extension ActionButtons {
    struct ViewModel {
        func clearKBCache() {
            grant_full_disk_access { error in
                if error != nil {
                    print("can't get disk access")
                } else {
                    _UIKeyboardCache.purge()
                }
            }
        }
        
        @available(iOS 15, *)
        func respringModern() {
            grant_full_disk_access { error in
                if error != nil {
                    print("can't get disk access, using backup respring")
                    respringLegacy()
                    xpc_crasher(UnsafeMutablePointer<CChar>(mutating: "com.apple.backboard.TouchDeliveryPolicyServer"))
                } else {
                    xpc_crasher(UnsafeMutablePointer<CChar>(mutating: "com.apple.frontboard.systemappservices"))
                    xpc_crasher(UnsafeMutablePointer<CChar>(mutating: "com.apple.backboard.TouchDeliveryPolicyServer"))
                }
            }
        }
        
        @available(iOS, deprecated: 15)
        func respringLegacy() {
            xpc_crasher(UnsafeMutablePointer<CChar>(mutating: "com.apple.backboard.TouchDeliveryPolicyServer"))
            let sharedApplication = UIApplication.shared
            let windows = sharedApplication.windows
            if let window = windows.first {
                while true {
                    window.snapshotView(afterScreenUpdates: false)
                }
            }
        }
    }
}
