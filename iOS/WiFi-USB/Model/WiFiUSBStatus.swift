//
//  WiFiUSBStatus.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/25/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import Foundation

struct WiFiUSBStatus {
    static private(set) internal var on: Bool = false
    static private(set) internal var raw: UInt8 = 0
    static private(set) internal var description: String = ""
    
    static func set(fromJson: JsonResponse) {
        WiFiUSBStatus.on = fromJson.on!
        WiFiUSBStatus.raw = UInt8(fromJson.raw!)
        WiFiUSBStatus.description = fromJson.description!
    }
}