//
//  Reachability.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  License: GNU GPLv3 (see LICENSE)
//

import Foundation
#if os(iOS)
import SystemConfiguration
#endif

/// Class for determining if this device is online
public class Reachability {

    /**
     simply determine if this device has a network connection
     
     - returns: Bool
     */
    class func isConnectedToNetwork() -> Bool {
        #if os(iOS)
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        #else
            //let the DataTask handle the failure
            return true
        #endif
    }
}
